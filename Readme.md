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
  	<label>Email</label><br />
    <input name="user[email]" type="text" />
  </div>
  <div class="field" validate="password">
    <label>Password</label><br />
    <input id="user_password" name="user[password]" type="password" />
  </div>
  <div class="field" validate="password_confirmation">
    <label>Password confirmation</label><br />
    <input name="user[password_confirmation]" type="password" />
  </div>
  <input name="commit" type="submit" value="Register" />
</form>
```


### Change the submit behavior

And JavaScript function:

``` js
$('form').ajaxForm();
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



## Test suite

Open `spec.html` in your browser.

Google Chrome doesn't allow ajax requests to local files by default.

In order to launch test suite in Google Chrome, you need to open it with:

``` sh
chrome --allow-file-access-from-files
```
