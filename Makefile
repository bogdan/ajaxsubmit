SRC = $(shell find src -name "*" -type f)
VERSION="0.1.0"

all: ajaxsubmit.js

ajaxsubmit.js: $(SRC)
	cat src/banner.js | sed s/VERSION/$(VERSION)/ > ajaxsubmit.js
	coffee -cp src/form-errors.js.coffee src/ajax-submit.js.coffee >> ajaxsubmit.js
	cp ajaxsubmit.js builds/ajaxsubmit-${VERSION}.js

