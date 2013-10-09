(function() {
  var TimelineChart,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  TimelineChart = (function() {
    function TimelineChart(container) {
      this.container = container;
      this.line = __bind(this.line, this);
      this.applyZoom = __bind(this.applyZoom, this);
      this.drawArcs = __bind(this.drawArcs, this);
      this.drawAxis = __bind(this.drawAxis, this);
      this._draw = __bind(this._draw, this);
      this.draw = __bind(this.draw, this);
      this._xScale = d3.scale.linear();
      this._yScale = d3.scale.linear();
      this._height = 80;
      this._width = 720;
      this._data = [];
    }

    TimelineChart.prototype.draw = function() {
      return this._draw();
    };

    TimelineChart.prototype._draw = function() {
      this.drawArcs();
      return this.drawAxis();
    };

    TimelineChart.prototype.drawAxis = function() {
      return this.container.append('g').attr('class', 'axis').call(this._xAxis).attr('transform', "translate(0," + this._height + ")");
    };

    TimelineChart.prototype.drawArcs = function() {
      var _this = this;
      return this.container.selectAll(".arc").data(this._data).enter().append('path').classed("arc", true).classed("merged", function(d) {
        return d.merged;
      }).attr('d', function(d) {
        return _this.line(d)(d.data);
      });
    };

    TimelineChart.prototype.mergedAttribute = function() {
      return '#ff0000';
    };

    TimelineChart.prototype.applyZoom = function() {
      var zoom,
        _this = this;
      zoom = d3.behavior.zoom().size([this._width, this._height]).scaleExtent([1, 8]).x(this._xScale).on("zoom", function() {
        _this.container.selectAll(".arc").attr('d', _this.line());
        return _this.container.select(".axis").call(_this._xAxis);
      });
      return this.container.call(zoom);
    };

    TimelineChart.prototype.data = function(value) {
      if (!arguments.length) {
        return this._data;
      }
      this._data = value;
      return this;
    };

    TimelineChart.prototype.xScale = function(value) {
      if (!arguments.length) {
        return this._xScale;
      }
      this._xScale = value;
      this.resetXAxis();
      return this;
    };

    TimelineChart.prototype.yScale = function(value) {
      if (!arguments.length) {
        return this._yScale;
      }
      this._yScale = value;
      return this;
    };

    TimelineChart.prototype.width = function(value) {
      if (!arguments.length) {
        return this._width;
      }
      this._width = value;
      return this;
    };

    TimelineChart.prototype.height = function(value) {
      if (!arguments.length) {
        return this._height;
      }
      this._height = value;
      return this;
    };

    TimelineChart.prototype.line = function(elem) {
      var instance;
      instance = this;
      return d3.svg.line().x(function(d) {
        return instance._xScale(d);
      }).y(function(d, i) {
        var datum;
        datum = elem.data;
        if (i === 0 || i === datum.length - 1) {
          return instance._height;
        } else {
          return instance._yScale(_.last(datum) - _.first(datum));
        }
      }).interpolate('basis');
    };

    TimelineChart.prototype.setXAxis = function() {
      return this._xAxis || (this._xAxis = d3.svg.axis().scale(this._xScale).orient('bottom'));
    };

    TimelineChart.prototype.resetXAxis = function() {
      this._xAxis = void 0;
      return this.setXAxis();
    };

    return TimelineChart;

  })();

  window.TimelineChart = TimelineChart;

}).call(this);
