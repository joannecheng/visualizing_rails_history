(function() {
  var commentText;

  commentText = function(row) {
    var textbox;
    $('.textbox').html('');
    textbox = d3.select('.textbox');
    return textbox.selectAll('ul.row').data(row.timestamps).enter().append('li').classed('row', true).text(function(d) {
      return d.body;
    });
  };

  d3.json('comment_timeline.json', function(error, data) {
    var container, dateCounter, h, markDate, maxDate, minDate, prd, rows, svg, textbox, timelineBoxes, w, xAxis, xScale, yScale;
    w = 1500;
    h = 500;
    dateCounter = {};
    markDate = function(timestamp) {
      var date;
      date = new Date(timestamp).setHours(0, 0, 0, 0);
      if (dateCounter[date] != null) {
        dateCounter[date] += 1;
      } else {
        dateCounter[date] = 1;
      }
      return dateCounter[date];
    };
    svg = d3.select('#comment_timeline').append('svg').attr('class', 'comment-timeline-container').attr('width', w).attr('height', h);
    container = svg.append('g').classed('container', true);
    textbox = d3.select('#comment_timeline').append('div').classed('textbox', true);
    prd = new CommentTimelinePullRequestData(data);
    minDate = prd.minDate();
    maxDate = prd.maxDate();
    xScale = d3.time.scale().domain([minDate, maxDate]).range([10, w - 5]);
    yScale = d3.scale.linear().domain([0, 100]).range([400, 0]);
    xAxis = d3.svg.axis().scale(xScale).orient('bottom');
    container.append('g').attr('class', 'axis').call(xAxis).attr('transform', 'translate(0, 402)');
    rows = container.selectAll('.timeline-row').data(data).enter().append('g').attr('class', function(d) {
      if (d.merged) {
        return 'merged';
      } else {
        return 'unmerged';
      }
    }).classed("timeline-row", true).on('click', function(d, i) {
      d3.selectAll('.timeline-row').classed('unpicked', true);
      d3.selectAll('.picked').classed('picked', false);
      d3.select(this).classed('picked', true).classed('unpicked', false);
      return $('.textbox').html("<a href='" + d.html_url + "' target='_blank'>" + d.title + "</a>");
    });
    timelineBoxes = rows.selectAll('rect.timeline-box').data(function(d) {
      return d.timestamps;
    }).enter().append('rect').attr('x', function(d) {
      return xScale(new Date(d.ts).setHours(0, 0, 0, 0)) + 0.5;
    }).attr('y', function(d) {
      var dc;
      dc = markDate(d.ts);
      return yScale(dc) + 0.5;
    }).classed("timeline-box", true).attr('width', 5).attr('height', 3.5);
    new CommentTimelineLegend(svg);
    return d3.csv('release_dates.cvs', function(error, data) {
      var releaseDateLabel, releaseDateLine;
      releaseDateLine = svg.selectAll('.release-date').data(data).enter().append('line').attr('x1', function(d) {
        return xScale(new Date(d.datetime)) - 2;
      }).attr('x2', function(d) {
        return xScale(new Date(d.datetime)) - 2;
      }).attr('y1', h - 10).attr('y2', 30).attr('stroke', '#F01122').attr('stroke-dasharray', '5').classed('release-date', true);
      return releaseDateLabel = svg.selectAll('.release-date-label').data(data).enter().append('text').attr('x', function(d) {
        return xScale(new Date(d.datetime)) - 2;
      }).attr('y', function(d) {
        return h - Math.random() * 50;
      }).text(function(d) {
        return d.version;
      });
    });
  });

}).call(this);
