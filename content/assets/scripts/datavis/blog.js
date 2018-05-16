// BUBBLEMAP
(function () {
  let dayFilter = new Set();

  function applyFilter(data) {
    if (dayFilter.size > 0) {
      return _.filter(data, e => dayFilter.has(moment(e.starttime).day()))
    }

    return data;
  }

  function filterData(data, beginTime, endTime) {
    data = applyFilter(data);
    return _(data).filter(e => beginTime <= moment(e.starttime) && moment(e.starttime) <= endTime).value();
  }

  d3.csv(`/csvdata/punchcard.csv`).then(data => {
    // Sort the data chronologically
    data = _.sortBy(data, e => Date.parse(e.starttime));

    const chart = bubbleMap();
    const selection = d3.select('#leafletmap')
      .datum(data)
      .call(chart);

    const times = _(data).map(e => moment(e.starttime));

    const slider = timeSlider()
      .domain([times.min().toDate(), times.max().toDate()])
      .data(times.value())
      .on('slide.hm', domain => {
        const beginTime = domain[0];
        const endTime = domain[1];

        const d = filterData(data, beginTime, endTime);
        selection.datum(d).call(chart)
      });
    const sel2 = d3.select('#slider1').call(slider);

    d3.selectAll("#dayButtons .button")
      .on("click", function () {
        const btn = d3.select(this);
        const num = +btn.attr('data-day-idx');
        const selected = btn.classed('is-outlined');

        if (num >= 0) {
          selected ? dayFilter.add(num) : dayFilter.delete(num) ;
          btn.classed('is-outlined', !selected)
        } else {
          dayFilter = new Set();
          d3.selectAll("#dayButtons .button").classed('is-outlined', true);
        }

        const filtered = applyFilter(data);

        const sliderData = _(filtered).map(e => moment(e.starttime).toDate()).value();
        selection.datum(filtered).call(chart);
        slider.data(sliderData);
      });

    var playing = false;
    var interval;

    d3.select('#playButton')
      .on('click', function () {
        if(playing) {
          clearInterval(interval);
          playing = false;
          d3.select(this).text('Play');
          return;
        }

        playing = true;
        d3.select(this).text('Pause');

        let beginTime = moment(slider.slider()[0]);
        let endTime = moment(slider.slider()[1]);

        interval = setInterval(() => {
          const bt = beginTime.toDate();
          const et = endTime.toDate();

          if (endTime < times.max()) {
            const filtData = filterData(data, bt, et);

            selection.datum(filtData).call(chart);
            slider.slider([bt, et]);

            beginTime.add(1, 'd');
            endTime.add(1, 'd');
          } else {
            clearInterval(interval);
          }
        }, 20);

        d3.select(this).text('Pause');
      });
  });
})();

// PUNCHCARD
(function () {
  d3.csv(`/csvdata/punchcard.csv`, e => { return { ...e, starttime: d3.isoParse(e.starttime) } }).then(data => {
    function prepareData(data) {
      let grouped = _(data).groupBy(e => e.name).mapValues(e => _(e).groupBy(e => e.starttime.getHours()).mapValues(e => e.length).value()).value();
      grouped = _(grouped).toPairs().sortBy(e => -_(e[1]).values().sum()).fromPairs().value();

      return grouped;
    }

    const grouped = prepareData(data);

    const pChart = punchCard().data(grouped);
    const svg = d3.select('svg#punchcard').call(pChart);

    const times = _(data).map(e => e.starttime);

    function filterData(data, beginTime, endTime) {
      return _(data).filter(e => beginTime <= e.starttime && e.starttime <= endTime).value();
    }

    const slider = timeSlider()
      .domain([times.min(), times.max()])
      .data(times.value())
      .on('slide.punchcard', domain => {
        const beginTime = domain[0];
        const endTime = domain[1];

        const d = filterData(data, beginTime, endTime);
        pChart.data(prepareData(d));
      });
    const sel2 = d3.select('#slider2').call(slider);

    var playing = false;
    var interval;

    d3.select('#playButton2')
      .on('click', function () {
        if(playing) {
          clearInterval(interval);
          playing = false;
          d3.select(this).text('Play');
          return;
        }

        playing = true;
        d3.select(this).text('Pause');

        let beginTime = moment(slider.slider()[0]);
        let endTime = moment(slider.slider()[1]);

        interval = setInterval(() => {
          const bt = beginTime.toDate();
          const et = endTime.toDate();

          if (endTime < times.max()) {
            const filtData = prepareData(filterData(data, bt, et));

            pChart.data(filtData);
            slider.slider([bt, et]);

            beginTime.add(1, 'd');
            endTime.add(1, 'd');
          } else {
            clearInterval(interval);
          }
        }, 20);
      });
  });
})();

// INSTANCE CHART
(function () {
  d3.csv(`/csvdata/punchcard.csv`, e => {
    return { ...e, starttime: d3.isoParse(e.starttime) }
  }).then(data => {
    function prepareData(data, interval) {
      data = _(data).sortBy(e => e.starttime).groupBy('name').value();
      return data
    }

    const prepped = prepareData(data, d3.timeDay);

    let chart = instanceChart().data(prepped);

    d3.select('svg#instance').call(chart);
  });
})();

// RANKING CHART
(function () {
  function prepareData(data, interval) {
    let l = data.length;

    data = _(data).sortBy(e => e.starttime).value();

    let slices = [];
    let slice = []
    let itv = interval(data[0].starttime);

    for (const d of data) {
      slice.push(d);
      let nItv = interval(d.starttime);

      if (itv.getTime() !== nItv.getTime()) {
        slices.push({
          slice: slice.slice(),
          time: itv
        });
        itv = nItv;
      }
    }

    let res = slices.map(e => {
      let r = _(e.slice).countBy('name').toPairs().orderBy('1', 'desc').value();

      return { slice: r, time: e.time };
    });

    res = res.map((l, _) => l.slice.map((e, i) => { return { time: l.time, name: e[0], count: e[1], idx: i }; }));
    res = _(res).flatten();

    return res.groupBy('name').value();
  }

  d3.csv(`/csvdata/punchcard.csv`, e => {
    return { ...e, starttime: d3.isoParse(e.starttime) }
  }).then(data => {
    const prepped = prepareData(data, d3.timeDay.every(1));

    let chart = rankingChart()
      .data(prepped);

    d3.select('svg#rankings').call(chart);
  });
})();
