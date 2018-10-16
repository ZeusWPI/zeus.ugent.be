var margin = {top: 20, right: 10, bottom: 30, left: 10};
var width = 700 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom;

const mat = [];

const interpol = d3.interpolateViridis;
const colorScaleRel = d3.scaleSequential(interpol).domain([0, 100]);
const colorScaleAbs = d3.scaleSequential(interpol).domain([0, 306]); //oeps harcoded

const svg = d3.select('#gridlo')
  .append('svg')
  .attr("width", width + margin.left + margin.right)
  .attr("height", height + margin.top + margin.bottom)
  .append("g")
  .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

const products = [];
const locations = [];
d3.csv("/csvdata/elodata.csv", d => {
  d.product_id = +d.product_id;
  d.location_id = +d.location_id;

  if (!mat[d.product_id]) {
    products[d.product_id] = d.name_x;
    mat[d.product_id] = Array(...Array(110)).map(Number.prototype.valueOf, 0);
  }
  // at this point tha array is made d.location_id
  if (!mat[d.product_id][d.location_id]) {
    locations[d.location_id] = d.name_y;
    mat[d.product_id][d.location_id] = 1;
  } else {
    mat[d.product_id][d.location_id] += 1;
  }
  return d;
}).then((data) => {
  const mat2 = [];
  let prod2 = [];
  mat.forEach((a, i) => {
    prod2.push(products[i]);
    mat2.push(a);
  });
  let mat3 = [];
  let loc2 = [];
  for (var i = 0; i < prod2.length; i++) {
    mat3[i] = [];
  }
  var i = 0;
  let mat_scaled = [];
  locations.forEach((l, k) => {
    loc2.push(l);
    for (let j = 0; j < prod2.length; j++) {
      mat3[j][i] = mat2[j][k];
    }
    i++;
  });

  //rectangles
  let comb = _.sortBy(_.zip(prod2, mat3), e => -_.sum(e[1]));
  prod2 = _.unzip(comb)[0];
  mat3 = _.unzip(comb)[1];

  comb = _.sortBy(_.zip(loc2, _.unzip(mat3)), e => -_.sum(e[1]));
  loc2 = _.unzip(comb)[0];
  mat3 = _.unzip(_.unzip(comb)[1]);

  max = 0;
  sums = []
  for (var i = 0; i < mat3[0].length; i++) {
    sums[i] = 0;
  }
  mat3.forEach(d => {
    d.forEach((e, i) => {
      sums[i] += e;
    });
  });
  mat_scaled = mat3.map((r, i) => r.map((e, j) => 100 * e / sums[j]));
  relative = false; // 0 is false -> scaled
  data = [mat_scaled, mat3];
  scales = [colorScaleRel, colorScaleAbs];
  const legends = [[0, 20, 40, 60, 80, 100], [0, 60, 120, 180, 240, 300]];
  let d = data[+relative];
  const top = svg.append("g").attr("id", "top");
  
  const boxScale = d3.scaleBand()
    .domain(d3.range(Math.max(d.length, d[0].length)))
    .range([0, Math.min(height, width)])
    .round(true)
    ;
  
  d3.select("#switch").on("click", updateData);

  function updateData() {
    relative = !relative;
    d = data[+relative];
    scale = scales[+relative]

    // ENTER -- Rows
    top.selectAll('g').data(d, (_, i) => i).enter().append('g')
      .attr('opacity', 0.95)
      .attr("transform", (_, i) => `translate(0, ${(boxScale(i))})`)
      .attr('data-row-idx', (_, i) => i)
      // ENTER -- Boxes
      .selectAll('rect').data(d => d, (_, i) => i).enter().append("rect")
      .attr('opacity', 0.95)
      .attr("class", (_, i) => `id${i}`)
      .attr('width', boxScale.bandwidth() * 1.01)
      .attr('height', boxScale.bandwidth() * 1.01)
      .attr("x", (_, i) => boxScale(i) + 150)
      .on("mouseover", mouse_over_rect)
      .on("mouseout", mouse_out_rect);

    const boxes = top.selectAll('g').data(d, (_, i) => i).selectAll('rect').data(d => d, (_, i) => i);

    boxes
      .transition()
      .attr('fill', d => scale(d));

    svg.selectAll(".legend text")
      .transition().duration(500)
      .text((_, i) => {
        const d = legends[+relative][i];
        return relative ? d : d + '%';
      });

    svg.selectAll(".legend rect")
      .transition().duration(500)
      .style("fill", (d, i) => scale(legends[+relative][i]));

  };
  updateData();

  function mouse_over_rect(d, i, j) {  // Add interactivity
    const row = d3.select(this.parentNode);
    const block = d3.select(this);
    const tooltip = d3.select('.tooltip');
    
    //row
    row.attr("opacity", 1);
    d3.selectAll(`.id${i}`).attr("opacity", 1);
    
    tooltip
      .style("opacity", .9)
      .html(relative ? d : `${d.toFixed(2)}%`);

    // We calculate the bounding rects after setting the html
    let rect = block.node().getBoundingClientRect();
    let t_rect = tooltip.node().getBoundingClientRect();

    tooltip
      .style("left", (rect.left + rect.width / 2 - t_rect.width / 2) + "px")
      .style("top", (rect.top - t_rect.height - 5) + "px");

    //Labels
    d3.select(`#rest${i}`)
      .attr("fill", scale(d))
      .attr("font-weight", "bold")
      ;

    d3.select(`#prod${row.attr('data-row-idx')}`)
      .attr("fill", scale(d))
      .attr("font-weight", "bold")
      ;
  }
  function mouse_out_rect(d, i, j) {
    const row = d3.select(this.parentNode);
    const block = d3.select(this);
    const tooltip = d3.select('.tooltip');
  
    //rm border and text
    row.attr("stroke", "none");
    row.attr("opacity", 0.95);
    d3.selectAll(`.id${i}`).attr("opacity", 0.95);
    
    tooltip.style('opacity', 0);

    d3.select(`#rest${i}`)
      .attr("fill", "black")
      .attr("font-weight", "")
      ;
    d3.select(`#prod${row.attr('data-row-idx')}`)
      .attr("fill", "black")
      .attr("font-weight", "")
      ;
  }

  // product labels
  let prodLabels = svg.append("g")
    .selectAll("g")
    .data(prod2)
    .enter()
    .append("text")
    .text(d => d)
    .attr("x", 30)
    .attr("y", (_, i) => boxScale(i) + 15)
    .attr("id", (_, i) => `prod${i}`)
    .attr("font-family", "sans-serif")
    .attr("font-size", "11px")
    .attr("fill", "black");
  
  // location labels
  let locLabels = svg.append("g")
    .selectAll("g")
    .data(loc2)
    .enter()
    .append("text")
    .text(d => d)
    .attr("text-anchor", "middle")
    .attr("transform", (_, i) => `translate(${(boxScale(i) + 150)},${boxScale(prodLabels.size() - 1) + 70}) rotate(-65)`)
    .attr("font-family", "sans-serif")
    .attr("id", (_, i) => `rest${i}`)
    .attr("font-size", "11px")
    .attr("fill", "black");
  
  //Legend
  let legend = svg.append('g')
    .classed('legendWrapper', 'true')
    .attr("transform", `translate(${boxScale(locLabels.size() - 1) + boxScale.bandwidth() + 160}, 0)`);
    ;

  let legendAbs = legend.selectAll(".legend")
    .data(legends[+relative])
    .enter().append("g")
    .attr("class", "legend")
    .attr("transform", (d, i) => `translate(0 ,${boxScale(i) + 20})`);

  legendAbs.append("rect")
    .attr("width", 20)
    .attr("height", 20)
    .style("fill", d => colorScaleAbs(d));

  legendAbs.append("text")
    .attr("x", 26)
    .attr("y", 10)
    .attr("dy", ".35em")
    .text(d => relative ? d : `${d.toFixed(2)}%`);

  legend.append("text")
    .attr("class", "label")
    .attr("x", 0)
    .attr("y", 10)
    .attr("dy", ".35em")
    .text("Count");
});
