class PullRequestData
  constructor: (@data) ->

  insertMeanIntoDataRow: ->
    dataWithMean = _.map @data, (d) ->
      created_at = Date.parse(d.created_at)
      closed_at = Date.parse(d.closed_at)
      {
        merged: !(d.merged_at == '')
        data: [created_at, created_at + 10, closed_at - 10, closed_at]
      }
    @meanData = dataWithMean

  dataWithMean: =>
    @meanData ||= @insertMeanIntoDataRow()

  minDate: ->
    Date.parse d3.min _.pluck @data, 'created_at'

  maxDate: ->
    Date.parse d3.max _.pluck @data, 'closed_at'

class CommentTimelinePullRequestData
  constructor: (@data) ->

  minDate: =>
    _.min(@allDates(), (date) -> date.ts).ts

  maxDate: ->
    _.max(@allDates(), (date) -> date.ts).ts

  allDates: ->
    _.flatten(_.pluck(@data, 'timestamps'))

window.PullRequestData = PullRequestData
window.CommentTimelinePullRequestData = CommentTimelinePullRequestData
