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

d3.json 'comment_timeline.json', (error, data) ->
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
    .attr('class', (d) -> if d.merged then 'merged' else 'unmerged')
    .classed("timeline-row", true)
    .on('click', (d, i) ->
      d3.selectAll('.timeline-row').classed('unpicked', true)
      d3.selectAll('.picked').classed('picked', false)
      d3.select(@).classed('picked', true).classed('unpicked', false)
      $('.textbox').html("<a href='#{d.html_url}' target='_blank'>#{d.title}</a>")
    )

  timelineBoxes = rows
    .selectAll('rect.timeline-box')
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

  new CommentTimelineLegend(svg)

  d3.csv 'release_dates.cvs', (error, data) ->
    releaseDateLine = svg.selectAll('.release-date')
      .data(data).enter()
      .append('line')
      .attr('x1', (d) -> xScale(new Date(d.datetime)) - 2)
      .attr('x2', (d) -> xScale(new Date(d.datetime)) - 2)
      .attr('y1', h-10)
      .attr('y2', 30)
      .attr('stroke', '#F01122')
      .attr('stroke-dasharray', '5')
      .classed('release-date', true)

    releaseDateLabel = svg.selectAll('.release-date-label')
      .data(data).enter()
      .append('text')
      .attr('x', (d) -> xScale(new Date(d.datetime)) - 2)
      .attr('y', h-10)
      .text((d) -> d.version)
