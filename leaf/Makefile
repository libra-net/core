# Main makefile to build leaf repository for libra project
ifeq ($(LIBRA_DEBUG),)
.SILENT:
endif
.PHONY: clean all

# Some generic definitions
OUTPUT ?= out
VERSION ?= $(shell git describe --tags)
INDEX := $(OUTPUT)/index.json
DATE := $(shell date -uR)

# Packages definition
NAMES ?= $(shell cat packages.txt)
PACKAGES := $(foreach NAME,$(NAMES),$(OUTPUT)/$(NAME)_$(VERSION).leaf)
MANIFESTS := $(foreach NAME,$(NAMES),$(OUTPUT)/$(NAME)_$(VERSION)/manifest.json)
TEMPLATES := $(foreach NAME,$(NAMES),$(NAME)/template.json)
CUROUTPUT = $(subst /manifest.json,,$(subst .leaf,,$@))
CURNAME = $(subst _$(VERSION),,$(subst $(OUTPUT)/,,$(CUROUTPUT)))

# Targets

all: $(INDEX)

clean:
	rm -rf $(OUTPUT)

$(INDEX): $(PACKAGES) Makefile
	cd $(OUTPUT) && leaf build index -o index.json --description "libra project packages" *.leaf

%.leaf: %/manifest.json Makefile
	cp -a $(CURNAME)/* $(CUROUTPUT)
	leaf build pack \
		-o $@ \
		-i $(CUROUTPUT) \
		-- \
		-J --mtime="$(DATE)" --sort name --mode='a+r,a-w,u+w' --owner=0 --group=0 --numeric-owner --exclude=template.json .

$(MANIFESTS): $(CURDIR)/Makefile $(TEMPLATES)
	mkdir -p $(CUROUTPUT)
	export VERSION=$(VERSION) && \
	leaf build manifest \
		-o $(CUROUTPUT) \
		--name $(CURNAME) \
		--version $(VERSION) \
		--date "$(DATE)" \
		--append $(CURNAME)/template.json \
		--env
