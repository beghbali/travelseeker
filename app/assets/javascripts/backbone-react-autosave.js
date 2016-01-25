
(function (root, factory) {
  // Universal module definition
  if (typeof define === 'function' && define.amd) {
    define(['react', 'react-dom', 'backbone', 'underscore'], factory);
  } else if (typeof module !== 'undefined' && module.exports) {
    module.exports = factory(require('react'), require('react-dom'), require('backbone'), require('underscore'));
  } else {
    factory(root.React, root.ReactDOM, root.Backbone, root._);
  }
}(this, function (React, ReactDOM, Backbone, _) {
  'use strict';
  if (!Backbone.React.Utils) {
      Backbone.React.Utils = {};
  }

  if (!Backbone.React.Utils.Autosave) {
      Backbone.React.Utils.Autosave = {};
  }

  var mixin = Backbone.React.Utils.Autosave.mixin = {
    componentWillMount: function() {
      // this.startAutoSave();
    },
    componentWillUnmount: function() {
      this.queueAutoSave();
      this.stopAutoSave();
    },
    startAutoSave: function() {
      this.setState({autosave: setInterval(this.queueAutoSave.bind(this), 5000)});
    },
    stopAutoSave: function() {
      clearInterval(this.state.autosave);
      this.setState({autosave: null});
    },
    saveData: function() {
      this.setState({ loading: true }, function() {
        this.props.model.save(this.props.model.attributes, {patch: true}).always(() => {
          this.setState({loading: false});
        });
      });
    },
    queueAutoSave: function() {
      this.saveData();
    }
  };

  return mixin;
}));