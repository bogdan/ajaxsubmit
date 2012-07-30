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

  describe "after apply null errors", ->
    beforeEach ->
      $form.applyErrors(email: null)

    it "should not add activation class", ->
      expect($form.find("[validate~=email]")).not.toHaveClass($.errors.activationClass)

  describe "after apply empty errors", ->
    beforeEach ->
      $form.applyErrors(email: [])

    it "should not add activation class", ->
      expect($form.find("[validate~=email]")).not.toHaveClass($.errors.activationClass)

  describe "after apply errors with multiple errors", ->
    beforeEach ->
      $form.applyErrors(email: ["is blank", "is invalid"])

    it "should pick first", ->
      expect($form.find("[validate~=email] .validation-message").html()).toEqual("is blank")

    describe "after add errors", ->
      beforeEach ->
        $form.addErrors(name: "is too short")

      it "should add new error", ->
        expect($form.find("[validate~=name] .validation-message").html()).toEqual("is too short")

      it "should not remove old error", ->
        expect($form.find("[validate~=email] .validation-message").html()).toEqual("is blank")

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

  describe "after apply on field that is not presence in any validate attribute", ->
    beforeEach ->
      $form.applyErrors([["terms", "is not accepted"]])

    it "should add error to top of the form with notice", ->
      expect($form.find("[validate~='terms']").html()).toEqual(
        "Unassigned error: Add validate=\"terms\" attribute somewhere in a form." +
        "<div class=\"validation-block\"><div class=\"validation-message\">is not accepted</div></div>"
      )

  describe "after apply on filed with dot in name", ->
    beforeEach ->
      $form.applyErrors([["user.email", "is blank"]])
    it "should add error on field", ->
      expect($form.find('.validation-message').html()).toEqual("is blank")

