(function() {
function timeSlider() {
  var data;
  var sliderValue;
  var updateSlider;
  var updateData;

  let width = 50;
  let midPoint = width / 2;
  let domain = [moment().subtract(1, 'year').toDate(), moment().toDate()]

  const dispatch = d3.dispatch('slide');
  var margin = { top: 2, right: 40, bottom: 20, left: 40 };

  function my(svg) {
    let xScale;

    let tWidth = $(svg.node()).width();
    let tHeight = $(svg.node()).height();

    tWidth -= margin.left + margin.right;
    tHeight -= margin.top + margin.bottom;

    const g = svg.append('g')
      .attr("transform", `translate(${margin.left}, ${margin.top})`);
    
    const gAxis = g.append('g');

    // Create the svg:defs element and the main gradient definition.
    var svgDefs = g.append('defs');
    var mainGradient = svgDefs.append('linearGradient')
      .attr('id', 'mainGradient');
    // Create the stops of the main gradient. Each stop will be assigned
    // a class to style the stop using CSS.
    mainGradient.append('stop')
      .attr('stop-opacity', '0')
      .attr('offset', '0%');
    mainGradient.append('stop')
      .attr('stop-color', 'blue')
      .attr('stop-opacity', '1')
      .attr('offset', '45%');
    mainGradient.append('stop')
      .attr('stop-color', 'blue')
      .attr('stop-opacity', '1')
      .attr('offset', '55%');
    mainGradient.append('stop')
      .attr('stop-opacity', '0')
      .attr('offset', '100%');

    updateData = function (data, updateDomain) {
      if (updateDomain) {
        domain = d3.extent(data);
      }

      xScale = d3.scaleTime()
        .domain(domain)
        .range([0, tWidth])
        .nice()
        ;

      const xAxis = d3.axisBottom(xScale)
        .tickFormat(d3.timeFormat("%b '%y"))
        ;
      gAxis
        .attr('transform', 'translate(0,' + 50 + ')')
        .classed('x axis', true)
        .call(xAxis)
        .selectAll("text")
        ;

      const sliderHeatmap = g.selectAll('rect.heatTick').data(data, d => d);

      sliderHeatmap.exit().transition().attr('height', 0).remove();

      sliderHeatmap.enter().append('rect')
        .attr('x', e => xScale(e))
        .attr('class', 'heatTick')
        .attr('fill', 'blue')
        .attr('width', 3)
        .attr('height', 0)
        .attr('fill-opacity', 0.2)
        .transition()
        .attr('height', 50)
        ;
      
    }
    updateData(data);

    const outer = g.append('rect')
      .attr('stroke', 'black')
      .attr('fill-opacity', 0)
      .attr('stroke-width', 1)
      .attr('width', tWidth)
      .attr('height', 50);

    const t1 = g.append('text')
      .attr('font-size', '.6em')
      .attr('y', 50);
    const t2 = g.append('text')
      .attr('font-size', '.6em')
      .attr('y', 50);

    const inner = g.append('rect')
      .attr('stroke', 'black')
      .attr('fill-opacity', 0)
      .attr('stroke-width', 2)
      .attr('width', 50)
      .attr('height', width)
      .call(d3.drag()
        .on("drag", function (d) {
          const dx = d3.event.dx;
          const dy = d3.event.dy;

          let nx = midPoint + dx - width / 2;

          width -= 1.5 * dy;
          width = Math.max(10, width);

          nx += 1.5 * dy / 2;
          nx = Math.min(tWidth - width, nx);
          nx = Math.max(0, nx);

          midPoint = nx + width / 2;

          width = Math.min(width, tWidth);

          const beginTime = xScale.invert(nx);
          const endTime = xScale.invert(nx + width);

          sliderValue = [beginTime, endTime];

          updateSlider(sliderValue);

          dispatch.call('slide', this, sliderValue);
        }));

    updateSlider = function (value) {
      sliderValue = value

      nx = xScale(sliderValue[0]);
      width = xScale(sliderValue[1]) - xScale(sliderValue[0]);
      midPoint = nx + width / 2;

      inner.attr('x', nx)
        .attr('width', width);

      const fmtStr = 'DD/MM/YY'

      t1.text(moment(sliderValue[0]).format(fmtStr))
        .attr('x', nx)
        .attr('transform', `rotate(45 ${nx},50) translate(20,20)`);
      t2.text(moment(sliderValue[1]).format(fmtStr))
        .attr('x', nx + width)
        .attr('transform', `rotate(45 ${nx + width},50) translate(20,20)`);
    }
    updateSlider(xScale.domain());
  }

  my.on = function () {
    let value = dispatch.on.apply(dispatch, arguments);
    return value === dispatch ? my : value;
  }

  my.domain = function (value) {
    if (!arguments.length) return domain;
    domain = value;
    if (typeof updateData === 'function') updateData(data);
    return my;
  }

  my.slider = function (value) {
    if (!arguments.length) return sliderValue;
    if (typeof updateSlider === 'function') updateSlider(value);
    return my;
  }

  my.data = function (dt) {
    if (!arguments.length) return intensity;
    data = dt
    if (typeof updateData === 'function') updateData(data);
    return my;
  }

  return my;
}

window['timeSlider'] = timeSlider;

})();
