describe "form-errors", ->

  $form = null
  defaultConfig = $.errors


  beforeEach ->
    $form = $('form').clone()

  afterEach ->
    $form.clearErrors()
    $.errors = defaultConfig

  describe "after apply errors", ->
    beforeEach ->
      $form.applyErrors(email: "is invalid")

    it "should apply error message", ->
      expect($form.find(".validation-message").html()).toEqual("is invalid")

    it "should add activation class", ->
      expect($form.find("[validate~=email]")).toHaveClass($.errors.activationClass)

    it "should have validation dom", ->
      expect($form.find('.validation-block')).not.toBeEmpty()

    it "should have activation class", ->
      expect($form.find('.validation-active[validate=email]')).not.toBeEmpty()

    describe "after cleanup Errors", ->
      beforeEach ->
        $form.clearErrors()

      it "should leave validation message dom", ->
        expect($form.find(".validation-message")).toExist()

      it "should clean validation message", ->
        expect($form.find(".validation-message").html()).toEqual("")


  describe "after apply errors with multiple errors", ->
    beforeEach ->
      $form.applyErrors(email: ["is blank", "is invalid"])

    it "should pick first", ->
      expect($form.find(".validation-message").html()).toEqual("is blank")


  describe "after apply errors as array", ->
    beforeEach ->
      $form.applyErrors([['email', "is blank"], ['email', "is invalid"]])

    it "should pick first", ->
      expect($form.find(".validation-message").html()).toEqual("is blank")

  describe "after apply different server side fields to one client side field", ->
    beforeEach ->
      $form.applyErrors([['email', "is blank"], ['user', "not found"]])

    it "should pick first", ->
      expect($form.find(".validation-message").html()).toEqual("is blank")

