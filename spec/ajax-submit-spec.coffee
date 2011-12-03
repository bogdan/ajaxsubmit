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
