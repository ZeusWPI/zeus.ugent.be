(function () {
  function bubbleMap() {
    // Empty map variable, will init once
    var map;

    function init(mapId) {
      if (map == null) {
        map = new L.Map(mapId, { center: [51.023115, 3.710299], zoom: 12 })
          .addLayer(new L.TileLayer('https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png'));

        map._initPathRoot();

        d3.select(`#${mapId}`)
          .select('svg')
          .append('g')
          .attr("class", "leaflet-zoom-hide")
      }
    }

    function my(sel) {
      init(sel.attr('id'));

      const g = sel.select('g');
      const dt = g.datum();

      var div = d3.select(".tooltip").style('opacity', 0);

      function vrUpdate() {
        let g = d3.select('g');

        const selection = g.selectAll('.location');
        const data = selection.data();
        const lines = g.selectAll('line');
        const latlngs = data.map(e => map.latLngToLayerPoint(new L.LatLng(e.lat, e.lon)));

        selection
          .attr('cx', (e, i) => latlngs[i].x)
          .attr('cy', (e, i) => latlngs[i].y)
          ;
      }

      const t = d3.transition()
        .ease(d3.easeLinear)
        .duration(100);

      const sizes = _.countBy(dt, 'location_id');
      const data = _.uniqBy(dt, 'location_id')

      let radius = d3.scaleSqrt()
        .range([0, 50])
        .domain([0, 177])
        ;

      // JOIN DATA
      const selection = g.selectAll('.location').data(data, d => d.location_id);
      const lines = g.selectAll('line').data(data, d => d.location_id);

      // EXIT
      selection.exit()
        .transition(t)
        .attr('r', 0)
        .remove();

      // ENTER
      selection.enter()
        .append('circle')
        .style("stroke", "white")
        .style("opacity", .4)
        .style("fill", "blue")
        .attr("r", 0)
        .attr('class', 'location')
        .each(d => {
          const coord = map.latLngToLayerPoint(new L.LatLng(d.lat, d.lon));
          g.append('circle')
            .attr('r', radius(sizes[d.location_id]))
            .attr('fill-opacity', 0)
            .style('stroke', 'black')
            .attr('transform', e => `translate(${coord.x}, ${coord.y})`)
            .attr('opacity', 1)
            .transition()
            .duration(1000)
            .ease(d3.easeLinear)
            .attr('r', 75)
            .attr('opacity', 0)
            .remove();
        })
        .on("mouseout", _ => {
          div.style("opacity", 0);
        })
        .merge(selection)
        // We do the mouseover after the merge so the values update when changing time
        .on("mouseover", function (d) {
          div.text(`${d.name} (${sizes[d.location_id]})`);

          let rect = d3.select(this).node().getBoundingClientRect();
          let t_rect = div.node().getBoundingClientRect();
          div
            .style("opacity", .9)
            .style("left", (rect.left + rect.width/2 - t_rect.width/2) + "px")
            .style("top", (rect.top - t_rect.height - 5) + "px")
            ;
        })
        .transition(t)
        .attr("r", d => radius(sizes[d.location_id]))
        ;

      vrUpdate();

      map.on("viewreset", vrUpdate);
    }

    return my;
  }

  window['bubbleMap'] = bubbleMap;
})();
