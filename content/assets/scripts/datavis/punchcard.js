(function () {
  function punchCard() {
    var margin = { top: 20, right: 20, bottom: 30, left: 150 };
    var data;
    var updateData;

    const tooltip = d3.select('body').append('div')
      .classed('tooltip', true)
      .attr('id', 'pCardTooltip')
      .style("opacity", 0);
      ;

    function chart(svg) {
      let width = svg.attr('width');
      let height = svg.attr('height');

      width -= margin.left + margin.right;
      height -= margin.top + margin.bottom;

      const g = svg.append('g')
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

      const gAxis = g.append('g')
        .classed('axis', true);


      updateData = function () {
        const maxValue = _(data).values().map(e => _(e).values().value()).map(e => _(e).max()).max();
        const x = d3.scaleLinear()
          .domain([0, 23])
          .range([0, width])
          ;

        const y = d3.scaleLinear()
          .domain([0, d3.keys(data).length])
          .range([0, height])
          ;

        const r = d3.scaleSqrt()
          .domain([1, maxValue])
          .range([3, 11])
          ;

        let rows = g.selectAll('g.row').data(d3.entries(data), d => d.key);

        let erows = rows.enter().append('g')
          .classed('row', true)
          .attr('opacity', 1)

        erows
          .append('text')
          .attr('x', -10)
          .attr('y', 3)
          .attr('text-anchor', 'end')
          .text(d => d.key);

        rows.exit().remove();

        rows = erows.merge(rows);

        rows.transition().duration(25).attr('transform', (d, i) => `translate(0, ${y(i)})`);

        const circles = rows.selectAll('circle.punch').data(d => d3.entries(d.value), d => d.key);
        circles.enter().append('circle')
          .classed('punch', true)
          .attr('cx', d => x(+d.key))
          .attr('fill', 'orange')
          .attr('r', 0)
          .on("mouseover", function (d) {
            tooltip.transition()
              .duration(200)
              .style("opacity", .9);
            tooltip.html(d.value);

            // We calculate the bounding rects after setting the html
            let rect = d3.select(this).node().getBoundingClientRect();
            let t_rect = tooltip.node().getBoundingClientRect();
            tooltip
              .style("left", (rect.left + rect.width/2 - t_rect.width/2) + "px")
              .style("top", (rect.top - t_rect.height - 5) + "px");
          })
          .on("mouseout", _ => {
            tooltip.transition()
              .duration(500)
              .style("opacity", 0);
          })
          .merge(circles)
          .transition()
          .duration(25)
          .attr('r', d => r(d.value))
          ;

        circles.exit().transition()
          .attr('r', 0)
          .remove();

        rows.selectAll('circle.punch').attr('r', d => r(d.value));

        const axis = d3.axisBottom(x).ticks(24);

        gAxis
          .attr('transform', `translate(0, ${y.range()[1]})`)
          .call(axis);
      }
      updateData();
    }

    chart.data = function (value) {
      if (!arguments.length) return data;
      data = value;
      if (typeof updateData === 'function') updateData();
      return chart;
    }

    return chart;
  }

  window['punchCard'] = punchCard;
})();
