describe "ajax-submit", ->

  $form = null

  afterEach ->
    $form.clearErrors()

  beforeEach ->
    $form = $("form").clone()

  describe "after submit", ->
    beforeEach ->
      spyOnUrl '/': (params) ->
        expect(params.data).toMatch("email")
        {errors: {email: "is invalid"}}
      $form.ajaxSubmit()

    it "should apply error message", ->
      expect($form.find(".validation-message").html()).toEqual("is invalid")

  describe "after submit with custom url", ->
    beforeEach ->
      spyOnUrl( '/hello': {errors: {email: "is blank"}})
      $form.ajaxSubmit(url: '/hello')

    it "should apply error message", ->
      expect($form.find(".validation-message").html()).toEqual("is blank")

  describe "after submit with extra data", ->
    beforeEach ->
      spyOnUrl '/': (params) ->
        expect(params.data).toMatch("abcd")
        expect(params.data).toMatch("email")
        {errors: {email: "is blank"}}

      $form.ajaxSubmit(data: {identifier: "abcd"})

    it "should apply error message", ->
      expect($form.find(".validation-message").html()).toEqual("is blank")

  describe "after submit with custom type", ->
    beforeEach ->
      spyOnUrl '/': (params) ->
        expect(params.type).toEqual("put")
        {errors: {email: "is blank"}}

      $form.ajaxSubmit(type: "put")

    it "should apply error message", ->
      expect($form.find(".validation-message").html()).toEqual("is blank")
