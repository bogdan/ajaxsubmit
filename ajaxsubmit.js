/**
* Ajax Submit v0.0.1
* http://github.com/bogdan/ajaxsubmit
* 
* Copyright 2011, Bogdan Gusiev
* Released under the MIT License
*/

  (function($) {
    if (!($().jquery >= '1.6')) throw 'ajaxsubmit.js require jQuery >= 1.6.0';
    $.errors = {
      attribute: "validate",
      activation_class: "error",
      message_class: "validation-message",
      apply_validation_error: function(div, message) {
        var message_div;
        if (!div.hasClass($.errors.activation_class)) {
          div.addClass($.errors.activation_class);
          message_div = div.find("." + $.errors.message_class);
          if (message_div.size() === 0) {
            return div.append($.errors.format(message));
          } else {
            return message_div.html(message);
          }
        }
      },
      format: function(message) {
        return "<div class='validation'><div class='" + $.errors.message_class + "'>" + message + "</div><div class='arrow'></div></div>";
      }
    };
    $.fn.applyErrors = function(errors) {
      var form;
      form = $(this);
      $(this).clearErrors();
      if ($.type(errors) === "object") {
        errors = $.map(errors, function(v, k) {
          return [[k, v]];
        });
      }
      return $(errors).each(function(key, error) {
        var field, message, validation_div;
        field = error[0];
        message = error[1];
        if ($.isArray(message)) message = message[0];
        validation_div = form.find("[" + $.errors.attribute + "~='" + field + "']");
        if (validation_div.size() === 0) {
          validation_div = $("<div " + $.errors.attribute + "='" + field + "'></div>");
          form.prepend(validation_div);
        }
        return $.errors.apply_validation_error(validation_div, message);
      });
    };
    return $.fn.clearErrors = function() {
      var validators;
      validators = $(this).find("[" + $.errors.attribute + "]");
      return validators.removeClass($.errors.activation_class);
    };
  })(jQuery);

  (function($) {
    var ajaxFormErrorHandler, ajaxFormSuccessHandler;
    $.fn.ajaxSubmit = function(options) {
      var $form, callback, error_callback, method, url;
      if (options == null) options = {};
      $form = $(this);
      $form.clearErrors();
      if (typeof options === "function") options.success = options;
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
      if ($.isEmptyObject(data.errors)) {
        if (typeof callback === "function") return callback.call($form, data);
      } else {
        if (typeof error_callback === "function") error_callback.call($form, data);
        return $form.applyErrors(data.errors);
      }
    };
    ajaxFormErrorHandler = function($form) {};
    return $.fn.ajaxForm = function(options) {
      if (options == null) options = {};
      return $(this).bind("submit", function(event) {
        event.preventDefault();
        return $(this).ajaxSubmit(options);
      });
    };
  })(jQuery);
