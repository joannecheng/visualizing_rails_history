(function() {
  var CommentTimelineLegend,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  CommentTimelineLegend = (function() {
    function CommentTimelineLegend(svg) {
      this.drawLegendBoxes = __bind(this.drawLegendBoxes, this);
      this.data = ['merged', 'unmerged'];
      this.drawLegendBoxes();
      this.drawLegendLabels();
    }

    CommentTimelineLegend.prototype.drawLegendBoxes = function() {
      return d3.selectAll('.legend-box').data(this.data).enter().append('rect').attr('width', 5).attr('height', 5).classed(function(d) {
        return d;
      }).classed('.legend-box', true);
    };

    CommentTimelineLegend.prototype.drawLegendLabels = function() {
      return d3.selectAll('.legend-label');
    };

    return CommentTimelineLegend;

  })();

  window.CommentTimelineLegend = CommentTimelineLegend;

}).call(this);
