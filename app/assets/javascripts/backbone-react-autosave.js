
(function (root, factory) {
  'use strict';
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
    },
    componentWillUnmount: function() {
      this.queueAutoSave();
      this.stopAutoSave();
    },
    startAutoSave: function() {
      this.setState({autosave: setInterval(this.queueAutoSave.bind(this), 5000)});
    },
    stopAutoSave: function() {
      this.saveData();
      clearInterval(this.state.autosave);
      this.setState({autosave: null});
    },
    saveData: function() {
      this.setState({ loading: true }, function() {
        self = this
        if (this.props.model.hasChanged()) {
          this.props.model.save(this.props.model.attributes, {patch: true}).always(function () {
           self.setState({loading: false})
         });
        }
      });
    },
    queueAutoSave: function() {
      this.saveData();
    }
  };

  return mixin;
}));