(function() {
  const EMOJI_TYPES = {
    chinese: '🥡',
    pasta: '🍝',
    fries: '🍟',
    pizza: '🍕',
    pitta: '🥙',
    burgers: '🍔',
    sandwich: '🥪'
  }
  function instanceChart() {
    var margin = { top: 40, right: 60, bottom: 20, left: 20 };
    var data;
    var updateData;

    function chart(svg) {
      let width = svg.attr('width');
      let height = svg.attr('height');

      width -= margin.left + margin.right;
      height -= margin.top + margin.bottom;

      const g = svg.append('g')
        .attr("transform", `translate(${margin.left}, ${margin.top})`);

      updateData = function () {
        times = _(data).toPairs().map(1).flatten().map('starttime').value();

        const leftPad = 170;

        const x = d3.scaleTime()
          .domain(d3.extent(times))
          .range([0, width - leftPad])
          ;
        
        console.log(x.domain());
        

        const y = d3.scaleBand()
          .domain(d3.keys(data))
          .range([0, height])
          ;

        const yLegend = d3.scaleBand()
          .domain(d3.keys(EMOJI_TYPES))
          .range([0, 170])
          .paddingInner(0.4)
          ;

        // const c = d3.scaleOrdinal(d3.schemeCategory10);
        const c = d3.scaleOrdinal(d3.schemeCategory10).domain(d3.keys(EMOJI_TYPES));

        let axis = d3.axisTop(x);

        const selection = g.selectAll('g.instance').data(d3.entries(data));

        let instance = selection.enter().append('g')
          .classed('instance', true)
          .attr('transform', d => `translate(0, ${y(d.key)})`)
          ;

        instance.append('text')
          .attr('y', y.bandwidth() / 2)
          // .style('fill', d => `${c(d.value[0].type)}`)
          .text(d => `${EMOJI_TYPES[d.value[0].type]} ${d.key} (${d.value.length})`)
          .style('font-size', '12pt')
          ;
        
        const iHeightMod = 0.8;
        
        // GRAY BACKGROUND
        instance.append('rect')
          .attr('x', leftPad)
          .attr('width', width - leftPad)
          .attr('height', y.bandwidth() * iHeightMod)
          .attr('fill-opacity', 0.03)
          ;

        instance.append('g')
          .classed('innerInstance', true)
          .selectAll('rect.tick').data(d => d.value).enter().append('rect')
          .classed('tick', true)
          .attr('x', d => leftPad + x(d.starttime))
          .attr('width', 2)
          .attr('height', y.bandwidth() * iHeightMod)
          .attr('fill', d => c(d.type))
          .attr('fill-opacity', 0.8)
          ;

        g.append('g')
          .attr('transform', `translate(${leftPad}, -5)`)
          .call(axis)
          ;

        const text = d3.select('body').append('div')
          .style('position', 'fixed')
          .style('opacity', 0)
          .style('background-color', 'white')
          .style('border-radius', '20px')
          .style('padding', '5px')
          ;
        
        const line = g.append('rect')
          .attr('y', 0)
          .attr('height', height - (y.bandwidth() * (1 - iHeightMod)))
          .attr('width', 1)
          .attr('opacity', 0)
          ;
        
        const legendEntry = g.selectAll('g.legendEntry').data(d3.keys(EMOJI_TYPES)).enter().append('g')
          .classed('legendEntry', true)
          .attr('transform', d => `translate(${20 + leftPad + x.range()[1]}, ${yLegend(d)})`)
          ;
        
        legendEntry
          .append('rect')
          .attr('width', yLegend.bandwidth())
          .attr('height', yLegend.bandwidth())
          .attr('fill', c)
          .attr('fill-opacity', 0.8)
          ;

        legendEntry
          .append('text')
          .attr('x', yLegend.bandwidth() + 5)
          .attr('y', 17)
          .text(d => EMOJI_TYPES[d])
          ;

        g.append('rect')
          .attr('width', x.range()[1])
          .attr('height', y.range()[1])
          .attr('fill-opacity', 0)
          .attr('x', leftPad)
          .on('mouseover', () => {
            text.style('opacity', 1);
            line.attr('opacity', 1);
          })
          .on('mousemove', function () {
            let mouse = d3.mouse(this);
            let date = x.invert(mouse[0] - leftPad);

            text
              .style('left', `${d3.event.x + 15}px`)
              .style('top', `${d3.event.y - 20}px`)
              ;
            
            let fmt = d3.timeFormat('%d/%m/%y');
            text.text(fmt(date));
            line.attr('x', mouse[0])
          })
          .on('mouseout', () => {
            text.style('opacity', 0);
            line.attr('opacity', 0);
          })
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

window['instanceChart'] = instanceChart;
})();
