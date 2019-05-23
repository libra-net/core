# Main makefile to deploy artifacts for releases
ifeq ($(LIBRA_DEBUG),)
.SILENT:
endif
.PHONY: clean all init

# Current branch name
ifneq ($(TRAVIS_BRANCH),)
CURRENT_BRANCH_NAME := $(TRAVIS_BRANCH)
else
CURRENT_BRANCH_NAME := $(shell git branch | grep \* | cut -d ' ' -f2)
endif

# Deploy directories
DEPLOY := $(CURDIR)/deploy
DEPLOY_BRANCH := $(DEPLOY)/leaf/branches/$(CURRENT_BRANCH_NAME)

# Build leaf stuff
LEAF_OUTPUT := $(CURDIR)/../leaf/out

# Default target
all: init leaf-update

# Init deploy dir with previous artifacts
init:
	git clone --depth 1 https://github.com/libra-net/libra-net.github.io.git $(DEPLOY)

# Contribute built leaf artifacts to archived tree
leaf-update:
	if test ! -e $(LEAF_OUTPUT)/index.json; then \
		echo "Missing leaf artifacts"; \
		exit 1; \
	fi
	mkdir -p $(DEPLOY_BRANCH)
	cd $(LEAF_OUTPUT) && cp -a index.json *.leaf *.leaf.info $(DEPLOY_BRANCH)

# Clean deploy dir
clean:
	rm -rf $(DEPLOY)
