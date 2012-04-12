describe "ajax-submit", ->

  $form = null

  afterEach ->
    $form.clearErrors()

  beforeEach ->
    $form = $("form").clone()

  describe "after submit", ->
    beforeEach ->
      spyOnUrl( '/': {errors: {email: "is invalid"}})
      $form.ajaxSubmit()

    it "should apply error message", ->
      expect($form.find(".validation-message").html()).toEqual("is invalid")

  describe "after submit with custom url", ->
    beforeEach ->
      spyOnUrl( '/hello': {errors: {email: "is blank"}})
      $form.ajaxSubmit(url: '/hello')

    it "should apply error message", ->
      expect($form.find(".validation-message").html()).toEqual("is blank")
