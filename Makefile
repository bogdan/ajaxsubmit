
VERSION="0.1.4"

all:
	cat src/banner.js | sed s/VERSION/$(VERSION)/ > ajaxsubmit.js
	coffee -cp src/form-errors.js.coffee src/ajax-submit.js.coffee >> ajaxsubmit.js
	cp ajaxsubmit.js builds/ajaxsubmit-${VERSION}.js

