(($) ->
  $.fn.ajaxSubmit = (options = {}) ->
    $form = $(@)
    $form.clearErrors()
    if typeof(options) == "function"
      options.success = options
    if options.redirect && !options.success
      options.success = ->
        window.location = options.redirect
    callback = options.success
    error_callback = options.error
    method = $form.attr("method") or "GET"
    url = $form.attr("action")
    $.ajax
      type: method.toUpperCase()
      url: url
      data: $form.serialize()
      success: (data) ->
        ajaxFormSuccessHandler $form, data, callback, error_callback
      
      error: (xhr, status, str) ->
        ajaxFormErrorHandler $form

  ajaxFormSuccessHandler = ($form, data, callback, error_callback) ->
    if $.isEmptyObject(data && data.errors)
      if typeof (callback) == "function"
        callback.call $form[0], data
      else if data.redirect
        window.location = data.redirect

    else
      error_callback.call $form, data  if typeof (error_callback) == "function"
      $form.applyErrors data.errors

  ajaxFormErrorHandler = ($form) ->
    #TODO: callback?

  $.fn.ajaxForm = (options = {}) ->
    $(@).bind "submit", (event) ->
      event.preventDefault()
      $(@).ajaxSubmit options
)(jQuery)
