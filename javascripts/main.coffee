class PullRequestData
  constructor: (@data) ->
    @insertMeanIntoDataRow()

  insertMeanIntoDataRow: ->
    dataWithMean = _.map @data, (d) ->
      created_at = Date.parse(d.created_at)
      closed_at = Date.parse(d.closed_at)
      [created_at, created_at + 10, closed_at - 10, closed_at]
    @meanData = dataWithMean

  graphData: =>
    @meanData ||= @insertMeanIntoDataRow()

  minDate: ->
    Date.parse d3.min _.pluck @data, 'created_at'

  maxDate: ->
    Date.parse d3.max _.pluck @data, 'closed_at'

d3.csv '/data.cvs', (error, data) ->
  width = 1000
  height = 300
  paddingBottom = 20
  pullRequestData = new PullRequestData(data)
  minDate = pullRequestData.minDate()
  maxDate = pullRequestData.maxDate()

  xScale = d3.time.scale().domain([minDate, maxDate]).range([3, width-3])
  yScale = d3.scale.linear().domain([0, maxDate - minDate]).range([298, 50])

  xAxis = d3.svg.axis()
      .scale(xScale)
      .orient('bottom')

  graphData = pullRequestData.graphData()

  svg = d3.select('.content')
    .append('svg')
    .attr('class', 'data-container')
    .attr('width', width + 100)
    .attr('height', height + paddingBottom)

  container = svg.append("g")
    .classed("container",true)

  container.append('g')
    .attr('class', 'axis')
    .call(xAxis)
    .attr('transform', "translate(0,#{height})")

  xAxisLabel = svg.selectAll('text')

  draw = () ->
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
    container.selectAll(".arc")
      .data(graphData)
      .enter()
      .append('path')
      .classed("arc",true)
      .attr('d', line)

    container.select(".axis").call(xAxis)
    container.selectAll(".arc").attr('d',line)

  zoom = d3.behavior.zoom()
    .scaleExtent([1,16])
    .x(xScale)
    .on("zoom", draw)

  container.call(zoom)

  draw()

