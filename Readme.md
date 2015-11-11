# AjaxSubmit

This library is designed to submit and validate forms via Ajax

[LIVE Demo available](http://ajaxsubmit.herokuapp.com)

Originally extracted from [Mailtrap Web Service](http://mailtrap.io)

## Dependencies

* JQuery

## Download

[Ajaxsubmit latest version](https://raw.github.com/bogdan/ajaxsubmit/master/ajaxsubmit.js)

[Browse release history](https://github.com/bogdan/ajaxsubmit/tree/master/builds)

## Usage

Three step to convert any web form into ajax form:

* Specify `validate` attribute for each element to assign errors
* Change form submit behavior
* Rework backend to return json

### Validate attributes

Errors assignment to the form is done via HTML5 custom attributes:

``` diff
 <form action="/register" id="new_user" method="post">
-  <div class="field">
+  <div class="field" validate="email">
   	<label>Email</label>
     <input name="user[email]" type="text" />
   </div>
-  <div class="field">
+  <div class="field" validate="password">
     <label>Password</label>
     <input id="user_password" name="user[password]" type="password" />
   </div>
-  <div class="field">
+  <div class="field" validate="password_confirmation">
     <label>Password confirmation</label>
     <input name="user[password_confirmation]" type="password" />
   </div>
   <input name="commit" type="submit" value="Register" />
 </form>
```

You can specify multiple errors to be assigned in the same place with `validate="company company_id"`


### Change the submit behavior

With JavaScript function:

``` js
$('#new_user').ajaxForm();
```

### Rework backend

In order to interact with ajaxsubmit your controller should return JSON structure that match the given convention.

* If validation failed it should return JSON with `errors` key like: `{errors: {email: "Email is invalid"}}`
* If validation passed you can handle the flow in javascript callback or path JSON with redirection URL like: {redirect: "/home"}


Here is example with pseudocode:

``` js
post("/register", function() {
  var user = new User(this.params.user)
  if (user.save()) {
    return this.json({redirect: "/"});
  } else {
    return this.json({errors: user.errors()})
  }
});
```

Errors format example: 

``` js
// As Hash
{email: "Email is invalid", password: "Password is too short"}
// or as Array
[["email", "Email is invalid"], ["password", "Password is too short"]]

// Multiple errors can be on the same field. 
// In this case first will be picked
{email: ["Email is blank", "Email is invalid"]}
```


## API

### Form submit API

`$(...).ajaxSubmit(options = {})` - submits the form via AJAX.

`$(...).ajaxForm(options = {})` - rebinds 'submit' event on the form: prevents default and assign ajax submit instead.

Options:

* `success` - callback to be executed after form will be successfully submitted.
  * If not specified, user will be redirected by the redirect key received from backend after successful submit.
* `error` - callback to be executed when the form was not submitted successfully
* `httpError` - callback to be executed if server respond with http error status(if xhr object with error status will have correct error hash format plugin will also apply errors on the form in the same way and than run httpError callback)
* `redirect` - specify the URL where the user should be redirected after form submit(makes sense only when `success` option is not used)
* `url` - specify the url to submit a form. Defaults to url in `form[action]` attribute.
* `data` - extra data to submit along with form data. Default: none
* `type` - jQuery ajax request type(get, post, put or delete). Defaults to `form[method]` attribute

### Errors assignment API

`$(...).applyErrors(errors)` - assigns errors to the form with cleanup old ones.

`$(...).addErrors(errors)` - assigns errors to the form without cleanup old ones.

`$(...).clearErrors(errors)` - clears form from errors.

Configuration can be done via `$.errors` hash:

* `$.errors.attribute` - custom attribute HTML5 to refer error names. 
  * Default: `validate`.
* `$.errors.activationClass` - CSS class name to be assigned when error get active. 
  * Default: `validation-active`.
* `$.errors.format` - A peace of html that is rendered for each error. 
  * Default: `<div class='validation-block'><div class='validation-message'></div></div>`.
* `$.errors.messageClass` - The place in error form where the message should be assigned. 
  * Default: `validation-message`.
  * NOTE: `$.errors.format` should always contain tag with `$.errors.messageClass`

Example:

``` js
jQuery.errors.attribute="data-validate"
jQuery.errors.format="<div class='validation-popup'><span class='message'></span><img src='/images/arrow.gif'/></div>"
jQuery.errors.activationClass="active"
jQuery.errors.messageClass="message"
```

### Advanced customization: Different errors layout for different fields

You can have different DOM to display errors even in the same form.
For example:

``` diff
 <div class="field" validate="name">
   <label for="name">Name</label>
   <input id="name" name="name" type="text">
+  <div class="validation-message leftarrow validation-block"></div>
 </div>
 <div class="field" validate="gender">
   <label>Gender</label>
   <input id="gender_male" name="gender" type="radio" value="MALE"><label for="gender_male">Male</label>
   <input id="gender_female" name="gender" type="radio" value="FEMALE"><label for="gender_female">Female</label>
+  <div class="validation-message toparrow validation-block"></div>
 </div>
```

Now ajaxsubmit will simply insert error inside `.validation-message` without applying it's default format.
[Form with different errors layout DEMO](http://ajaxsubmit.herokuapp.com/subscriptions)

Make sure you include something like this in your CSS, so that validation block doesn't appear when inactive:


``` css
.validation-block {
  display: none;
}
.validation-active .validation-block {
  display: block;
}
```

## Test suite

Open `spec.html` in your browser.

Google Chrome doesn't allow ajax requests to local files by default.

In order to launch test suite in Google Chrome, you need to open it with:

``` sh
chrome --allow-file-access-from-files spec.html
```
## Thanks to

Thanks to people that made a contribution to this library (even in case they don't know about that):

* [Leonid Shevtsov](https://github.com/leonid-shevtsov)
* [Andrey Krikunenko](https://github.com/scream3)
* [Michael Klishin](https://github.com/michaelklishin)
* [Victor Nazarenko](https://github.com/vnazarenko)
* [Sergey Iurevich](https://github.com/iurevych)
* [Alexander Chaplinskiy](https://github.com/alchapone)

## Self-Promotion

Like ajaxsubmit?

Follow the [repository on GitHub](https://github.com/bogdan/ajaxsubmit).

Read [author blog](http://gusiev.com).
