THEME_VERSION := v0.8.2
THEME := geekdoc
THEMEDIR := themes

.PHONY: all
all: doc-assets

.PHONY: doc-assets
doc-assets:
	mkdir -p $(THEMEDIR)/$(THEME)/
	cd $(THEMEDIR)/$(THEME); npm install && npx gulp default
	$(MAKE) doc-build

.PHONY: doc-build
doc-build:
	hugo

.PHONY: clean
clean:
	rm -rf public
