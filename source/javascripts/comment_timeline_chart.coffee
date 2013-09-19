class CommentTimelineChart
  constructor: (@container) ->
    @_xScale = d3.time.scale()
    @_yScale = d3.scale.linear()

  draw: =>


window.CommentTimelineChart = CommentTimelineChart
