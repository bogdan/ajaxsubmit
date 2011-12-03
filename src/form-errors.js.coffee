(($) ->

  unless $().jquery >= '1.6'
    throw 'ajaxsubmit.js require jQuery >= 1.6.0'

  $.errors =
    attribute: "validate"
    activation_class: "error"
    message_class: "validation-message"

    apply_validation_error: (div, message) ->
      unless div.hasClass($.errors.activation_class)
        div.addClass $.errors.activation_class
        message_div = div.find(".#{$.errors.message_class}")
        if message_div.size() == 0
          div.append($.errors.format(message))
        else
          message_div.html(message)

    format: (message) ->
      "<div class='validation'><div class='#{$.errors.message_class}'>#{message}</div><div class='arrow'></div></div>"

  $.fn.applyErrors = (errors) ->
    form = $(@)
    $(@).clearErrors()
    if $.type(errors) == "object"
      errors = $.map errors, (v,k) -> [[k,v]]
    $(errors).each (key, error) ->
      field = error[0]
      message = error[1]
      message = message[0] if $.isArray(message)
      validation_div = form.find("[#{$.errors.attribute}~='#{field}']")
      if validation_div.size() == 0
        validation_div = $("<div #{$.errors.attribute}='#{field}'></div>")
        form.prepend(validation_div)
      $.errors.apply_validation_error(validation_div, message)

  $.fn.clearErrors = ->
    validators = $(@).find("[#{$.errors.attribute}]")
    validators.removeClass $.errors.activation_class

)(jQuery)
