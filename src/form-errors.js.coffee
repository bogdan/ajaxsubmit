(($) ->

  $.errors =
    attribute: "validate"
    activationClass: "validation-active"
    format: "<div class='validation-block'><div class='validation-message'></div></div>"
    messageClass: "validation-message"

  applyValidationMessage = (div, message) ->
    unless div.hasClass($.errors.activationClass)
      div.addClass $.errors.activationClass
      message_div = div.find(".#{$.errors.messageClass}")
      if message_div.size() == 0
        div.append($.errors.format)
      message_div = div.find(".#{$.errors.messageClass}")
      if message_div.size() > 0
        message_div.html(message)
      else
        throw new Error(
          "configuration error: $.errors.format must have elment with class #{$.errors.messageClass}"
        )

  applyValidation = (form, field, message) ->
    div = form.find("[#{$.errors.attribute}~='#{field}']")
    if div.size() == 0
      div = $(
        "<div #{$.errors.attribute}='#{field}'>" +
          "Unassigned error: Add validate=\"#{field}\" attribute somewhere in a form.</div>"
      )
      form.prepend(div)
    applyValidationMessage(div, message)

  $.fn.applyErrors = (errors) ->
    $(@).clearErrors()
    $(@).addErrors(errors)

  $.fn.addErrors = (errors) ->
    form = $(@)
    if $.type(errors) == "object"
      old_errors = errors
      errors = []
      $.each old_errors, (key, value) ->
        if value && !($.isArray(value) && value.length == 0)
          errors.push [key,value]
       
    $(errors).each (key, error) ->
      field = error[0]
      message = error[1]
      message = message[0] if $.isArray(message)
      applyValidation(form, field, message)

  $.fn.clearErrors = ->
    validators = $(@).find("[#{$.errors.attribute}]")
    validators.find(".#{$.errors.messageClass}").html("")
    validators.removeClass $.errors.activationClass

)(jQuery)
