(function() {
  var CommentTimelinePullRequestData, PullRequestData,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  PullRequestData = (function() {
    function PullRequestData(data) {
      this.data = data;
      this.dataWithMean = __bind(this.dataWithMean, this);
    }

    PullRequestData.prototype.insertMeanIntoDataRow = function() {
      var dataWithMean;
      dataWithMean = _.map(this.data, function(d) {
        var closed_at, created_at;
        created_at = Date.parse(d.created_at);
        closed_at = Date.parse(d.closed_at);
        return {
          merged: !(d.merged_at === ''),
          data: [created_at, created_at + 10, closed_at - 10, closed_at]
        };
      });
      return this.meanData = dataWithMean;
    };

    PullRequestData.prototype.dataWithMean = function() {
      return this.meanData || (this.meanData = this.insertMeanIntoDataRow());
    };

    PullRequestData.prototype.minDate = function() {
      return Date.parse(d3.min(_.pluck(this.data, 'created_at')));
    };

    PullRequestData.prototype.maxDate = function() {
      return Date.parse(d3.max(_.pluck(this.data, 'closed_at')));
    };

    return PullRequestData;

  })();

  CommentTimelinePullRequestData = (function() {
    function CommentTimelinePullRequestData(data) {
      this.data = data;
      this.minDate = __bind(this.minDate, this);
    }

    CommentTimelinePullRequestData.prototype.minDate = function() {
      return _.min(this.allDates(), function(date) {
        return date.ts;
      }).ts;
    };

    CommentTimelinePullRequestData.prototype.maxDate = function() {
      return _.max(this.allDates(), function(date) {
        return date.ts;
      }).ts;
    };

    CommentTimelinePullRequestData.prototype.allDates = function() {
      return _.flatten(_.pluck(this.data, 'timestamps'));
    };

    return CommentTimelinePullRequestData;

  })();

  window.PullRequestData = PullRequestData;

  window.CommentTimelinePullRequestData = CommentTimelinePullRequestData;

}).call(this);
