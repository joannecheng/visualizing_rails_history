class CommentTimelineLegend
  constructor: (svg)->
    @data = ['merged', 'unmerged']
    @drawLegendBoxes()
    @drawLegendLabels()

  drawLegendBoxes: =>
    d3.selectAll('.legend-box')
      .data(@data)
      .enter().append('rect')
      .attr('width', 5)
      .attr('height', 5)
      .classed((d) -> d)
      .classed('.legend-box', true)

  drawLegendLabels: ->
    d3.selectAll('.legend-label')

window.CommentTimelineLegend = CommentTimelineLegend
