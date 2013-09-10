class TimelineChart
  constructor: (@container) ->
    @_xScale = d3.scale.linear()
    @_yScale = d3.scale.linear()
    @_height = 80
    @_data = []

  draw: () =>
    @applyZoom()
    @_draw()

  _draw: =>
    @drawArcs()
    @drawAxis()

  drawAxis: =>
    @container.append('g')
      .attr('class', 'axis')
      .call(@_xAxis)
      .attr('transform', "translate(0,#{@_height})")

  drawArcs: =>
    @container.selectAll(".arc")
      .data(@_data)
      .enter()
      .append('path')
      .classed("arc", true)
      .attr('d', @line())

  applyZoom: =>
    zoom = d3.behavior.zoom()
      .scaleExtent([1,8])
      .x(@_xScale)
      .on("zoom", =>
        @container.selectAll(".arc").attr('d', @line())
        @container.select(".axis").call(@_xAxis)
      )
    @container.call zoom

  data: (value) ->
    if !arguments.length
      return @_data
    @_data = value
    @

  xScale: (value) ->
    if !arguments.length
      return @_xScale
    @_xScale = value
    @resetXAxis()
    @

  yScale: (value) ->
    if !arguments.length
      return @_yScale
    @_yScale = value
    @

  height: (value) ->
    if !arguments.length
      return @_height
    @_height = value
    @

  line: =>
    instance = @
    d3.svg.line()
      .x((d) ->
        instance._xScale(d))
      .y((d, i) ->
        datum = this.__data__
        if (i == 0 || i == datum.length- 1)
          300
        else
          instance._yScale(_.last(datum) - _.first(datum))
      ).interpolate('basis')

  setXAxis: ->
    @_xAxis ||= d3.svg.axis().scale(@_xScale).orient('bottom')

  resetXAxis: ->
    @_xAxis = undefined
    @setXAxis()

window.TimelineChart = TimelineChart
