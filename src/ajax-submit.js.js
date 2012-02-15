(function() {
  (function($) {
    var ajaxFormErrorHandler, ajaxFormSuccessHandler;
    $.fn.ajaxSubmit = function(options) {
      var $form, callback, error_callback, method, url;
      if (options == null) {
        options = {};
      }
      $form = $(this);
      $form.clearErrors();
      if (typeof options === "function") {
        options.success = options;
      }
      if (options.redirect && !options.success) {
        options.success = function() {
          return window.location = options.redirect;
        };
      }
      callback = options.success;
      error_callback = options.error;
      method = $form.attr("method") || "GET";
      url = $form.attr("action");
      return $.ajax({
        type: method.toUpperCase(),
        url: url,
        data: $form.serialize(),
        success: function(data) {
          return ajaxFormSuccessHandler($form, data, callback, error_callback);
        },
        error: function(xhr, status, str) {
          return ajaxFormErrorHandler($form);
        }
      });
    };
    ajaxFormSuccessHandler = function($form, data, callback, error_callback) {
      if ($.isEmptyObject(data && data.errors)) {
        if (typeof callback === "function") {
          return callback.call($form[0], data);
        } else if (data.redirect) {
          return window.location = data.redirect;
        }
      } else {
        if (typeof error_callback === "function") {
          error_callback.call($form, data);
        }
        return $form.applyErrors(data.errors);
      }
    };
    ajaxFormErrorHandler = function($form) {};
    return $.fn.ajaxForm = function(options) {
      if (options == null) {
        options = {};
      }
      return $(this).bind("submit", function(event) {
        event.preventDefault();
        return $(this).ajaxSubmit(options);
      });
    };
  })(jQuery);
}).call(this);
