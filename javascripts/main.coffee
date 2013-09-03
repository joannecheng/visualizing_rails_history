d3.csv '/data.cvs', (error, data) ->
  window.d = data
  insertMeanIntoDatum = (d) ->
    created_at = Date.parse(d.created_at)
    closed_at = Date.parse(d.closed_at)
    [created_at, created_at + 10, closed_at - 10, closed_at]

  width = 1000
  height = 400
  paddingBottom = 20

  minDate = Date.parse d3.min _.pluck data, 'created_at'
  maxDate = Date.parse d3.max _.pluck data, 'closed_at'
  xScale = d3.time.scale().domain([minDate, maxDate]).range([3, width-3])
  yScale = d3.scale.linear().domain([0, maxDate - minDate]).range([298, 50])

  svg = d3.select('.content')
    .append('svg')
    .attr('class', 'data-container')
    .attr('width', width + 100)
    .attr('height', height + paddingBottom)

  svg.append('g')
    .attr('class', 'axis')
    .call(d3.svg.axis()
      .scale(xScale)
      .orient('bottom'))
    .attr('transform', "translate(0,#{height})")

  xAxisLabel = svg.selectAll('text')

  line = d3.svg.line()
    .x((d) ->
      xScale(d))
    .y((d, i) ->
      datum = this.__data__
      if (i == 0 || i == datum.length- 1)
        300
      else
        yScale(_.last(datum) - _.first(datum))
    ).interpolate('basis')

  for datum in data
    datum = insertMeanIntoDatum(datum)
    svg.append('path')
      .datum(datum)
      .attr('d', line)
      .style("fill", "none")
      .style("stroke", "#000000")
      .style("stroke-width", 1)
      .style('opacity', 0.4)
      .attr('transform', "translate(0, 100)")
