(function() {
  var CommentTimelineChart,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  CommentTimelineChart = (function() {
    function CommentTimelineChart(container) {
      this.container = container;
      this.draw = __bind(this.draw, this);
      this._xScale = d3.time.scale();
      this._yScale = d3.scale.linear();
    }

    CommentTimelineChart.prototype.draw = function() {};

    return CommentTimelineChart;

  })();

  window.CommentTimelineChart = CommentTimelineChart;

}).call(this);
