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

window.PullRequestData = PullRequestData
