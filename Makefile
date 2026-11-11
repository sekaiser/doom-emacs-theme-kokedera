EMACS ?= emacs
DOOM_THEMES_DIR ?=
DOOM_LOAD_PATH = $(if $(DOOM_THEMES_DIR),-L "$(DOOM_THEMES_DIR)")

.PHONY: check test preview
check: test

test:
	$(EMACS) --batch -Q $(DOOM_LOAD_PATH) -l test/theme-tests.el -f ert-run-tests-batch-and-exit

preview:
	$(EMACS) --batch -Q $(DOOM_LOAD_PATH) -l tools/preview.el
