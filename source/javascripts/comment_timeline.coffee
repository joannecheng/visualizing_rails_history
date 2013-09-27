commentText = (row) ->
  $('.textbox').html('')
  textbox = d3.select('.textbox')
  textbox
    .selectAll('ul.row')
    .data(row.timestamps)
    .enter()
    .append('li')
    .classed('row', true)
    .text((d) -> d.body)

d3.json '/comment_timeline.json', (error, data) ->
  w = 1500
  h = 500
  dateCounter = {}

  markDate = (timestamp) ->
    date = new Date(timestamp).setHours(0, 0, 0, 0)
    if dateCounter[date]?
      dateCounter[date] += 1
    else
      dateCounter[date] = 1
    dateCounter[date]

  svg = d3.select('#comment_timeline')
    .append('svg')
    .attr('class', 'comment-timeline-container')
    .attr('width', w)
    .attr('height', h)

  container = svg.append('g')
    .classed('container', true)

  textbox = d3.select('#comment_timeline').append('div')
    .classed('textbox', true)

  prd = new CommentTimelinePullRequestData(data)
  minDate = prd.minDate()
  maxDate = prd.maxDate()

  xScale = d3.time.scale().domain([minDate, maxDate]).range([10, w - 5])
  yScale = d3.scale.linear().domain([0, 100]).range([400, 0])
  xAxis = d3.svg.axis().scale(xScale).orient('bottom')

  container.append('g')
    .attr('class', 'axis')
    .call(xAxis)
    .attr('transform', 'translate(0, 402)')

  rows = container.selectAll('.timeline-row')
    .data(data)
    .enter()
    .append('g')
    .classed((d, i) -> "timeline-row#{i}")
    .attr('class', (d) -> if d.merged then 'merged' else 'unmerged')
    .on('click', (d, i) ->
      d3.selectAll('.picked').classed('picked', false)
      d3.select(@).classed('picked', true)
      $('.textbox').html("<a href='#{d.html_url}' target='_blank'>#{d.title}</a>")
    )

  timelineBoxes = rows
    .selectAll('rect.timeline-row')
    .data((d) -> d.timestamps)
    .enter()
    .append('rect')
    .attr('x', (d) -> xScale(new Date(d.ts).setHours(0,0,0,0)) + 0.5)
    .attr('y', (d) ->
      dc = markDate(d.ts)
      yScale(dc) + 0.5
    )
    .classed("timeline-box", true)
    .attr('width', 5)
    .attr('height', 3.5)
