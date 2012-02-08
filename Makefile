SRC = $(shell find src -name "*" -type f)

all: ajaxsubmit.js

ajaxsubmit.js: $(SRC)
	cat src/banner.js | sed s/VERSION/`cat VERSION`/ > ajaxsubmit.js
	coffee -cp src/form-errors.js.coffee src/ajax-submit.js.coffee >> ajaxsubmit.js
