SRC = $(shell find src -name "*" -type f)

all: ajaxsubmit.js

ajaxsubmit.js: $(SRC)
	@node compile.js
