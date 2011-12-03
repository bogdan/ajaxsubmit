describe "form-errors", ->

  $form = null


  beforeEach ->
    $form = $('form').clone()

  afterEach ->
    $form.clearErrors()

  describe "after apply errors", ->
    beforeEach ->
      $form.applyErrors(email: "is invalid")

    it "should apply error message", ->
      expect($form.find(".validation-message").html()).toEqual("is invalid")

    it "should add activation class", ->
      expect($form.find("[validate~=email]")).toHaveClass($.errors.activation_class)

    it "should have validation dom", ->
      expect($form.find('.validation')).not.toBeEmpty()

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
