# Global makefile for Libra Network system core components
ifeq ($(LIBRA_DEBUG),)
.SILENT:
endif

# Components list
COMPONENTS := leaf

# Global usual targets
.PHONY: clean all ci $(COMPONENTS)

all: $(COMPONENTS)

$(COMPONENTS):
	make -C $@

clean:
	$(foreach COMPONENT,$(COMPONENTS),make -C $(COMPONENT) $@ && ) true

# CI management
CI_IMAGE := libranet/linux-box:ubuntu-latest
TMP_BUILD := $(shell mktemp -d /tmp/libra-build.XXX)

# Target used in CI environment (Docker wrapper to "all" target)
ci:
	docker pull $(CI_IMAGE)
	rm -Rf $(TMP_BUILD)
	cp -aL $(CURDIR) $(TMP_BUILD)
	docker run --rm --entrypoint /bin/bash -v $(TMP_BUILD):/build -e LIBRA_DEBUG \
		$(CI_IMAGE) -c \
		"sudo /etc/init.sh; sudo chown -R user.user /build; cd /build; sudo apt install -y make git-core; make all"
