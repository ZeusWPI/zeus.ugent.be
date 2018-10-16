(function() {
  function rankingChart() {
    var margin = { top: 50, right: 120, bottom: 20, left: 120 };
    var data;
    var updateData;

    function chart(svg) {
      let width = $(svg.node()).width();
      let height = svg.attr('height');

      width -= margin.left + margin.right;
      height -= margin.top + margin.bottom;

      const g = svg.append('g')
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

      updateData = function () {
        let allDates = _(d3.entries(data).map(e => e.value)).flatten().value().map(e => e.time);
        let allIdx = _(d3.entries(data).map(e => e.value)).flatten().value().map(e => e.idx);

        const x = d3.scaleTime()
          .domain(d3.extent(allDates))
          .range([0, width])
          .nice()
          ;

        let axis = d3.axisTop(x);

        g.append('g')
          .attr('transform', `translate(0, -20)`)
          .call(axis);

        const y = d3.scaleLinear()
          .domain([0, d3.max(allIdx)])
          .range([0, height])
          ;

        const c = d3.scaleOrdinal(d3.schemeCategory10);

        const line = d3.line()
          .x(d => x(d.time))
          .y(d => y(d.idx))
          .curve(d3.curveMonotoneX)
          ;

        const minTimes = d3.entries(data).map(e => _(e.value).minBy('time'));
        const maxTimes = d3.entries(data).map(e => _(e.value).maxBy('time'));

        function mouseover(ident) {
          return function inner(d, i, sel) {
            const path = g.selectAll('path.rankPath').filter(e => d[ident] === e.key);
            const others = g.selectAll('path.rankPath').filter(e => d[ident] !== e.key);
            path.attr('stroke-width', 6);
            others.attr('stroke', 'gray');
          }
        }

        function mouseout(ident) {
          return function inner(d, i, sel) {
            const path = g.selectAll('path.rankPath').filter(e => d[ident] === e.key);
            const others = g.selectAll('path.rankPath');
            path.attr('stroke-width', 3);
            others.attr('stroke', (_, i) => c(i));
          }
        }

        g.selectAll('path.rankPath').data(d3.entries(data)).enter().append('path')
          .classed('rankPath', true)
          .attr('fill-opacity', 0)
          .attr('stroke', (_, i) => c(i))
          .attr('stroke-width', 3)
          .attr('d', d => {
            const lastVal = d.value[d.value.length - 1];
            const nVal = {...lastVal, time: x.domain()[1]}
            return line(d.value.concat([nVal]));
          })
          .on('mouseover', mouseover('key'))
          .on('mouseout', mouseout('key'))
          ;

        g.selectAll('text.begin').data(minTimes).enter().append('text')
          .classed('begin', true)
          .attr('x', d => x(d.time) - 5)
          .attr('y', d => y(d.idx) + 4)
          .attr('text-anchor', 'end')
          .text(d => d.name)
          .on('mouseover', mouseover('name'))
          .on('mouseout', mouseout('name'))
          ;

        g.selectAll('text.end').data(maxTimes).enter().append('text')
          .classed('end', true)
          .attr('x', d => x.range()[1] + 5)
          .attr('y', d => y(d.idx) + 4)
          .attr('text-anchor', 'begin')
          .text(d => d.name)
          .on('mouseover', mouseover('name'))
          .on('mouseout', mouseout('name'))
          ;
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

window['rankingChart'] = rankingChart;

})();
