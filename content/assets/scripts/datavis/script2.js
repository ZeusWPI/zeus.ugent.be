(function () {
  const width = 1000;
  const height = 800;
  const middle = height / 2;
  const barPadding = 1;
  const padding = { top: 50, left: 50, right: 40, bottom: 50 };
  const formatTime = d3.timeFormat('%b %e %Y');

  let prevUpper, prevLower;
  let xScale, yScale1, yScale2, xAxis, yAxis1, yAxis2;
  let prevUpperButton, prevLowerButton;
  var chart, chart2, slider, selection;
  var userdata, pricedata, eventdata, tapordersdata, tapusersdata;

  d3.csv('/csvdata/haldis-price-time.csv', d => {
    return {
      date: d3.timeParse('%Y-%m-%d')(d.starttime).setHours(0, 0, 0, 0),
      value: parseInt(d.total_price) / 100
    };
  }).then(function (data) {
    pricedata = data;

    return d3.csv('/csvdata/haldis-num-users-time.csv', d => {
      return {
        date: d3.timeParse("%Y-%m-%d")(d.starttime).setHours(0, 0, 0, 0),
        value: parseInt(d.num_users)
      };
    });
  }).then(function (data) {
    userdata = data;

    return d3.csv('/csvdata/eventdata.csv', d => {
      return {
        date: d3.utcParse("%Y-%m-%dT%H:%M:%S%Z")(d.date).setHours(0, 0, 0, 0),
        title: d.title
      };
    });
  }).then(function (data) {
    eventdata = data;

    return d3.csv('/csvdata/tap-orders-day.csv', d => {
      return {
        date: d3.timeParse('%Y-%m-%d')(d.created_at).setHours(0, 0, 0, 0),
        value: parseInt(d.count)
      };
    });
  }).then(function (data) {
    tapordersdata = data;

    return d3.csv('/csvdata/tap-orders-users-day.csv', d => {
      return {
        date: d3.timeParse('%Y-%m-%d')(d.created_at).setHours(0, 0, 0, 0),
        value: parseInt(d.count)
      };
    });
  }).then(function (data) {
    tapusersdata = data;

    xScale = d3.scaleTime().range([padding.left, width - padding.right]);
    yScale1 = d3.scaleLinear().range([middle, padding.top]);
    yScale2 = d3.scaleLinear().range([padding.bottom, middle]);
    xAxis = d3.axisBottom().scale(xScale).ticks().tickFormat('').tickSize(0);
    yAxis1 = d3.axisLeft().scale(yScale1).ticks();
    yAxis2 = d3.axisLeft().scale(yScale2).ticks();


    chart = timeBarChart();
    chart.upper = true;
    chart.eventdata = eventdata;

    chart2 = timeBarChart();
    chart2.upper = false;
    chart2.eventdata = eventdata;

    selection = d3.select('#barchart').append('g');

    selection.append('g')
      .attr('class', 'x axis')
      .attr('transform', `translate(0, ${middle})`);

    selection.append('g')
      .attr('class', 'y axis')
      .attr('transform', `translate(${padding.left}, 0)`);

    selection.append('g')
      .attr('class', 'y axis2')
      .attr('transform', `translate(${padding.left}, ${middle - padding.top})`);

    slider = timeSlider();

    prevUpper = userdata;
    prevLower = tapordersdata;
    updateData(userdata, true);
    updateData(tapordersdata, false);

    prevUpperButton = d3.select("#user-button");
    prevLowerButton = d3.select("#tap-order-button");
    setActiveButton('#haldis-user-button', true);
    setActiveButton('#tap-order-button', false);

    slider.on('slide', domain => {
      chart.domain.start = domain[0];
      chart.domain.end = domain[1];
      chart2.domain.start = domain[0];
      chart2.domain.end = domain[1];

      const d1 = filterData(prevUpper, chart.domain.start, chart.domain.end);
      const d2 = filterData(prevLower, chart2.domain.start, chart2.domain.end);

      selection.datum(d1).call(chart);
      selection.datum(d2).call(chart2);
    });
    d3.select('#slider').call(slider);
  });

  function setActiveButton(name, upper) {
    curButton = d3.select(name);
    if (upper) {
        prevUpperButton.classed("is-focused", false);
        prevUpperButton = curButton;
    } else {
      prevLowerButton.classed("is-focused", false);
      prevLowerButton = curButton;
    }
    curButton.classed("is-focused", true);
  }

  function filterData(data, beginTime, endTime) {
    return _(data).filter(e => beginTime <= e.date && e.date <= endTime).value();
  }

  function timeBarChart() {
    function my(svg) {
      let eventdata = my.eventdata;
      var dt = svg.datum();

      const t = d3.transition()
        .ease(d3.easeLinear)
        .duration(100);

      xScale.domain([my.domain.start, my.domain.end]);

      svg.select('.x.axis')
        .transition(t)
        .call(xAxis);

      if (my.upper) {
        yScale1.domain(d3.extent(dt, d => d.value));
        svg.select('.y.axis')
          .transition(t)
          .call(yAxis1);
      } else {
        yScale2.domain(d3.extent(dt, d => d.value));
        svg.select('.y.axis2')
          .transition(t)
          .call(yAxis2);
      }

      function update() {
        let g = d3.select('svg#barchart > g');

        var selection, sellines, eventlines;
        if (my.upper) {
          selection = g.selectAll('.datacircle');
          sellines = g.selectAll('.line');
          eventlines = g.selectAll('.eventline');
        } else {
          selection = g.selectAll('.datacircle2');
          sellines = g.selectAll('.line2');
          eventlines = g.selectAll('.eventline2');
        }

        sellines
          .attr('x1', d => xScale(d.date))
          .attr('y1', () => my.upper ? middle : padding.top)
          .attr('x2', d => xScale(d.date))
          .attr('y2', d => my.upper ? yScale1(d.value) : yScale2(d.value));

        eventlines
          .attr('x1', d => xScale(d.date))
          .attr('y1', () => my.upper ? middle : padding.top)
          .attr('x2', d => xScale(d.date))
          .attr('y2', (d) => {
            let yValue = 0;
            selection.data().forEach(function (el) {
              if (el.date === d.date) {
                yValue = el.value;
              }
            })
            return my.upper ? yScale1(yValue) : yScale2(yValue);
          });

        selection
          .attr('cx', d => xScale(d.date))
          .attr('cy', d => my.upper ? yScale1(d.value) : yScale2(d.value));

      }

      const fed = filterData(eventdata, my.domain.start, my.domain.end);

      var selection, sellines, eventlines;
      if (my.upper) {
        selection = svg.selectAll('.datacircle').data(dt, d => d.date);
        sellines = svg.selectAll('.line').data(dt, d => d.date);
        eventlines = svg.selectAll('.eventline').data(fed, d => d.date);
      } else {
        selection = svg.selectAll('.datacircle2').data(dt, d => d.date);
        sellines = svg.selectAll('.line2').data(dt, d => d.date);
        eventlines = svg.selectAll('.eventline2').data(fed, d => d.date);
      }

      const fmtStr = 'DD/MM/YY';

      sellines.exit().remove();

      sellines.enter()
        .append('line')
        .attr('stroke', '#ddd')
        .attr('stroke-width', 2)
        .attr('class', () => my.upper ? 'line' : 'line2')
        .attr('transform', () => my.upper ? `translate(0, 0)` : `translate(0, ${middle - padding.bottom})`)
        .merge(sellines);

      eventlines.exit().remove();

      eventlines.enter()
        .append('line')
        .attr('stroke', '#f4a442')
        .attr('stroke-width', 2)
        .attr('class', () => my.upper ? 'eventline' : 'eventline2')
        .attr('transform', () => my.upper ? `translate(0, 0)` : `translate(0, ${middle - padding.bottom})`)
        .on("mouseover", function (d) {
          const tooltip = d3.select('.tooltip');

          tooltip
            .style("opacity", .9)
            .html(moment(d.date).format(fmtStr) + ' - ' + d.title);

          // We calculate the bounding rects after setting the html
          let rect = d3.select(this).node().getBoundingClientRect();
          let t_rect = tooltip.node().getBoundingClientRect();

          tooltip
            .style("left", (rect.left + rect.width / 2 - t_rect.width / 2) + "px")
            .style("top", (rect.top - t_rect.height - 5) + "px");
        })
        .on("mouseout", _ => {
          const tooltip = d3.select('.tooltip');
          tooltip.style("opacity", 0);
        })
        .merge(eventlines);

      selection.exit().remove();

      selection.enter()
        .append('circle')
        .attr('fill', 'lightblue')
        .attr('class', () => my.upper ? 'datacircle' : 'datacircle2')
        .attr('transform', () => my.upper ? `translate(0, 0)` : `translate(0, ${middle - padding.bottom})`)
        .on("mouseover", function (d) {
          const tooltip = d3.select('.tooltip');

          tooltip
            .style("opacity", .9)
            .html(moment(d.date).format(fmtStr) + ' - ' + d.value);

          // We calculate the bounding rects after setting the html
          let rect = d3.select(this).node().getBoundingClientRect();
          let t_rect = tooltip.node().getBoundingClientRect();

          tooltip
            .style("left", (rect.left + rect.width / 2 - t_rect.width / 2) + "px")
            .style("top", (rect.top - t_rect.height - 5) + "px");
        })
        .on("mouseout", _ => {
          const tooltip = d3.select('.tooltip');
          tooltip.style("opacity", 0);
        })
        .merge(selection)
        .attr('r', 3)
        ;

      update();
    }

    return my;
  }

  function updateData(data, upper) {
    domain = d3.extent(data, d => d.date);
    chart.domain = {
      'start': domain[0],
      'end': domain[1]
    };
    chart2.domain = {
      'start': domain[0],
      'end': domain[1]
    };

    const times = _(data).map(e => moment(e.date));

    if (upper) {
      prevUpper = data;
      const fd = filterData(prevLower, chart.domain.start, chart.domain.end);
      selection.datum(data).call(chart);
      selection.datum(fd).call(chart2);
      slider.domain([times.min(), times.max()]).data(times.value(), true);
    } else {
      prevLower = data;
      const fd = filterData(prevUpper, chart.domain.start, chart.domain.end);
      selection.datum(data).call(chart2);
      selection.datum(fd).call(chart);
      slider.domain([times.min(), times.max()]).data(times.value(), true);
    }

  }

  d3.select('#haldis-user-button').on('click', () => {
    updateData(userdata, true);
    setActiveButton('#haldis-user-button', true);
  });
  d3.select('#haldis-price-button').on('click', () => {
    updateData(pricedata, true);
    setActiveButton('#haldis-price-button', true);
  });
  d3.select('#tap-order-button').on('click', () => {
    updateData(tapordersdata, false);
    setActiveButton('#tap-order-button', false);
  });
  d3.select('#tap-user-button').on('click', () => {
    updateData(tapusersdata, false);
    setActiveButton('#tap-user-button', false);
  });
})();
