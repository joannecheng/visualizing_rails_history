d3.csv 'data.cvs', (error, data) ->
  width = 1000
  height = 300
  paddingBottom = 20
  pullRequestData = new PullRequestData(data)
  minDate = pullRequestData.minDate()
  maxDate = pullRequestData.maxDate()

  xScale = d3.time.scale().domain([minDate, maxDate]).range([3, width-3])
  yScale = d3.scale.linear().domain([0, maxDate - minDate]).range([298, 50])

  graphData = pullRequestData.dataWithMean()

  svg = d3.select('.content')
    .append('svg')
    .attr('class', 'data-container')
    .attr('width', width + 100)
    .attr('height', height + paddingBottom)

  container = svg.append("g")
    .classed("container",true)

  t = new TimelineChart(container)
  t.xScale(xScale)
    .yScale(yScale)
    .height(height)
    .width(width)
    .data(graphData)
    .draw()
