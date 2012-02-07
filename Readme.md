# AjaxSubmit

This library is designed to make Ajaxy web forms as easy as regular web forms.

## Dependencies

* JQuery

## Usage


Three step to convert any web form into ajax form:

* Specify `validate` attribute for each element to assign errors
* Change form submit behavior
* Rework backend to return json

### validate attributes

Errors assignment to the form is done via HTML5 custom attributes:

``` html
<form action="/register" id="new_user" method="post">
  <div class="field" validate="email">
  	<label>Email</label>
    <input name="user[email]" type="text" />
  </div>
  <div class="field" validate="password">
    <label>Password</label>
    <input id="user_password" name="user[password]" type="password" />
  </div>
  <div class="field" validate="password_confirmation">
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


Here is example with pseudocode:

``` js
post("/register", function() {
  user = new User(params["user"])
  if (user.save()) {
    return json({redirect: "/"});
  } else {
    return json({errors: user.errors()})
  }
});
```

Errors format example: 

``` js
// As Hash
{email: "Email is invalid", password_confirmation: "Confirmation should match password"}
// or as Array
{["email", "Email is invalid"], ["password_confirmation", "Confirmation should match password"]}
```


## API

### Form submit API

`$(...).ajaxSubmit(options = {})` - submits the form via AJAX.

`$(...).ajaxForm(options = {})` - rebinds 'submit' event on the form: prevents default and assign ajax submit instead.

Options:

* `success` - callback to be executed after form will be successfully submitted
* `redirect` - specify the URL where the user should be redirected after form submit(makes sense only when `success` option is not used)
* `error` - callback to be executed when the form was not submitted successfully

### Errors assignment API

`$(...).applyErrors(errors)` - assigns errors to the form.

`$(...).clearErrors(errors)` - clears form from errors.

Configuration can be done via `$.errors` hash:

* `$.errors.attribute` - custom attribute to refer error names. 
  * Default: `validate`.
* `$.errors.activationClass` - CSS class name to be assigned when error get active. 
  * Default: `error`.
* `$.errors.format` - A peace of html that is rendered for each error. 
  * Default: `<div class='validation'><div class='validation-message'></div><div class='arrow'></div></div>`.
* `$.errors.messageClass` - The place in error form where the message should be assigned. 
  * Default: `validation-message`.
  * NOTE: `$.errors.format` should always contain `$.errors.messageClass`

## Test suite

Open `spec.html` in your browser.

Google Chrome doesn't allow ajax requests to local files by default.

In order to launch test suite in Google Chrome, you need to open it with:

``` sh
chrome --allow-file-access-from-files
```
