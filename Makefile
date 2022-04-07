DESTDIR =
PREFIX =
BINDIR = /usr/local/sbin
CONFDIR = /etc
RCDIR = /etc/init.d
UNITDIR = /etc/systemd/system

rootpath = $(PREFIX)$(CONFDIR)/vm
rootdest = $(DESTDIR)$(rootpath)
binpath = $(PREFIX)$(BINDIR)
bindest = $(DESTDIR)$(binpath)
rcpath = $(PREFIX)$(RCDIR)
rcdest = $(DESTDIR)$(rcpath)
unitpath = $(PREFIX)$(UNITDIR)
unitdest = $(DESTDIR)$(unitpath)
dirs = machines.d conf include
scripts = start stop launch attach


help:
	@echo "available targets:"
	@echo "  help             -- show the text you're currently reading"
	@echo "  install          -- install to system by copying"
	@echo "  symlink          -- install to system by symlinking"
	@echo "  install-openrc   -- install OpenRC script to system"
	@echo "  install-systemd  -- install systemd unit to system"
	@echo ""
	@echo "available variables:"
	@echo "  DESTDIR          -- system root (currently: $(DESTDIR))"
	@echo "  PREFIX           -- install prefix (currently: $(PREFIX))"
	@echo "  BINDIR           -- directory for scripts (currently: $(BINDIR))"
	@echo "  CONFDIR          -- directory for configuration (currently: $(CONFDIR))"
	@echo "  RCDIR            -- directory for OpenRC scripts (currently: $(RCDIR))"
	@echo "  UNITDIR          -- directory for systemd units (currently: $(UNITDIR))"


install: symlink-scripts | $(rootdest)/
	test -L "$(rootdest)" && { rm "$(rootdest)"; mkdir "$(rootdest)"; } ||:
	cp -R vm/* "$(rootdest)"

symlink: symlink-scripts | $(rootdest)/
	! test -L "$(rootdest)" && rm -rf "$(rootdest)" ||:
	ln -sf "$(shell pwd)/vm" "$(rootdest)"

symlink-scripts: | $(bindest)/
	for s in $(scripts); do \
		ln -sf "$(rootpath)/scripts/$$s" "$(bindest)/vm-$$s"; \
	done

install-openrc: vm.rc | $(rcdest)/
	install -m 0755 $< "$(rcdest)/vm"

install-systemd: vm@.service | $(unitdest)/
	install -m 0644 $< "$(unitdest)"


$(rootdest)/ $(bindest)/ $(rcdest)/ $(unitdest)/:
	mkdir -p "$@"
