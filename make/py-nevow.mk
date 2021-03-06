###########################################################
#
# py-nevow
#
###########################################################

#
# PY-NEVOW_VERSION, PY-NEVOW_SITE and PY-NEVOW_SOURCE define
# the upstream location of the source code for the package.
# PY-NEVOW_DIR is the directory which is created when the source
# archive is unpacked.
# PY-NEVOW_UNZIP is the command used to unzip the source.
# It is usually "zcat" (for .gz) or "bzcat" (for .bz2)
#
# You should change all these variables to suit your package.
# Please make sure that you add a description, and that you
# list all your packages' dependencies, seperated by commas.
# 
# If you list yourself as MAINTAINER, please give a valid email
# address, and indicate your irc nick if it cannot be easily deduced
# from your name or email address.  If you leave MAINTAINER set to
# "NSLU2 Linux" other developers will feel free to edit.
#
PY-NEVOW_VERSION=0.11.1
PY-NEVOW_SOURCE=Nevow-$(PY-NEVOW_VERSION).tar.gz
PY-NEVOW_SITE=https://pypi.python.org/packages/source/N/Nevow
PY-NEVOW_DIR=Nevow-$(PY-NEVOW_VERSION)
PY-NEVOW_UNZIP=zcat
PY-NEVOW_MAINTAINER=NSLU2 Linux <nslu2-linux@yahoogroups.com>
PY-NEVOW_DESCRIPTION=A web application construction kit written in Python.
PY-NEVOW_SECTION=misc
PY-NEVOW_PRIORITY=optional
PY25-NEVOW_DEPENDS=python25
PY26-NEVOW_DEPENDS=python26
PY27-NEVOW_DEPENDS=python27
PY-NEVOW_CONFLICTS=

#
# PY-NEVOW_IPK_VERSION should be incremented when the ipk changes.
#
PY-NEVOW_IPK_VERSION=1

#
# PY-NEVOW_CONFFILES should be a list of user-editable files
#PY-NEVOW_CONFFILES=$(TARGET_PREFIX)/etc/py-nevow.conf $(TARGET_PREFIX)/etc/init.d/SXXpy-nevow

#
# PY-NEVOW_PATCHES should list any patches, in the the order in
# which they should be applied to the source code.
#
#PY-NEVOW_PATCHES=$(PY-NEVOW_SOURCE_DIR)/configure.patch

#
# If the compilation of the package requires additional
# compilation or linking flags, then list them here.
#
PY-NEVOW_CPPFLAGS=
PY-NEVOW_LDFLAGS=

#
# PY-NEVOW_BUILD_DIR is the directory in which the build is done.
# PY-NEVOW_SOURCE_DIR is the directory which holds all the
# patches and ipkg control files.
# PY-NEVOW_IPK_DIR is the directory in which the ipk is built.
# PY-NEVOW_IPK is the name of the resulting ipk files.
#
# You should not change any of these variables.
#
PY-NEVOW_BUILD_DIR=$(BUILD_DIR)/py-nevow
PY-NEVOW_SOURCE_DIR=$(SOURCE_DIR)/py-nevow

PY-NEVOW-COMMON_IPK_DIR=$(BUILD_DIR)/py-nevow-common-$(PY-NEVOW_VERSION)-ipk
PY-NEVOW-COMMON_IPK=$(BUILD_DIR)/py-nevow-common_$(PY-NEVOW_VERSION)-$(PY-NEVOW_IPK_VERSION)_$(TARGET_ARCH).ipk

PY25-NEVOW_IPK_DIR=$(BUILD_DIR)/py25-nevow-$(PY-NEVOW_VERSION)-ipk
PY25-NEVOW_IPK=$(BUILD_DIR)/py25-nevow_$(PY-NEVOW_VERSION)-$(PY-NEVOW_IPK_VERSION)_$(TARGET_ARCH).ipk

PY26-NEVOW_IPK_DIR=$(BUILD_DIR)/py26-nevow-$(PY-NEVOW_VERSION)-ipk
PY26-NEVOW_IPK=$(BUILD_DIR)/py26-nevow_$(PY-NEVOW_VERSION)-$(PY-NEVOW_IPK_VERSION)_$(TARGET_ARCH).ipk

PY27-NEVOW_IPK_DIR=$(BUILD_DIR)/py27-nevow-$(PY-NEVOW_VERSION)-ipk
PY27-NEVOW_IPK=$(BUILD_DIR)/py27-nevow_$(PY-NEVOW_VERSION)-$(PY-NEVOW_IPK_VERSION)_$(TARGET_ARCH).ipk

.PHONY: py-nevow-source py-nevow-unpack py-nevow py-nevow-stage py-nevow-ipk py-nevow-clean py-nevow-dirclean py-nevow-check

#
# This is the dependency on the source code.  If the source is missing,
# then it will be fetched from the site using wget.
#
$(DL_DIR)/$(PY-NEVOW_SOURCE):
	$(WGET) -P $(@D) $(PY-NEVOW_SITE)/$(@F) || \
	$(WGET) -P $(@D) $(SOURCES_NLO_SITE)/$(@F)

#
# The source code depends on it existing within the download directory.
# This target will be called by the top level Makefile to download the
# source code's archive (.tar.gz, .bz2, etc.)
#
py-nevow-source: $(DL_DIR)/$(PY-NEVOW_SOURCE) $(PY-NEVOW_PATCHES)

#
# This target unpacks the source code in the build directory.
# If the source archive is not .tar.gz or .tar.bz2, then you will need
# to change the commands here.  Patches to the source code are also
# applied in this target as required.
#
# This target also configures the build within the build directory.
# Flags such as LDFLAGS and CPPFLAGS should be passed into configure
# and NOT $(MAKE) below.  Passing it to configure causes configure to
# correctly BUILD the Makefile with the right paths, where passing it
# to Make causes it to override the default search paths of the compiler.
#
# If the compilation of the package requires other packages to be staged
# first, then do that first (e.g. "$(MAKE) <bar>-stage <baz>-stage").
#
$(PY-NEVOW_BUILD_DIR)/.configured: $(DL_DIR)/$(PY-NEVOW_SOURCE) $(PY-NEVOW_PATCHES) make/py-nevow.mk
	$(MAKE) py-epsilon-stage
	rm -rf $(@D)
	mkdir -p $(@D)
	# 2.5
	rm -rf $(BUILD_DIR)/$(PY-NEVOW_DIR)
	$(PY-NEVOW_UNZIP) $(DL_DIR)/$(PY-NEVOW_SOURCE) | tar -C $(BUILD_DIR) -xvf -
#	cat $(PY-NEVOW_PATCHES) | $(PATCH) -d $(BUILD_DIR)/$(PY-NEVOW_DIR) -p1
	mv $(BUILD_DIR)/$(PY-NEVOW_DIR) $(@D)/2.5
	(cd $(@D)/2.5; \
	    ( \
	    echo "[build_scripts]"; \
	    echo "executable=$(TARGET_PREFIX)/bin/python2.5"; \
	    echo "[install]"; \
	    echo "install_scripts=$(TARGET_PREFIX)/bin"; \
	    ) >> setup.cfg \
	)
	# 2.6
	rm -rf $(BUILD_DIR)/$(PY-NEVOW_DIR)
	$(PY-NEVOW_UNZIP) $(DL_DIR)/$(PY-NEVOW_SOURCE) | tar -C $(BUILD_DIR) -xvf -
#	cat $(PY-NEVOW_PATCHES) | $(PATCH) -d $(BUILD_DIR)/$(PY-NEVOW_DIR) -p1
	mv $(BUILD_DIR)/$(PY-NEVOW_DIR) $(@D)/2.6
	(cd $(@D)/2.6; \
	    ( \
	    echo "[build_scripts]"; \
	    echo "executable=$(TARGET_PREFIX)/bin/python2.6"; \
	    echo "[install]"; \
	    echo "install_scripts=$(TARGET_PREFIX)/bin"; \
	    ) >> setup.cfg \
	)
	# 2.7
	rm -rf $(BUILD_DIR)/$(PY-NEVOW_DIR)
	$(PY-NEVOW_UNZIP) $(DL_DIR)/$(PY-NEVOW_SOURCE) | tar -C $(BUILD_DIR) -xvf -
#	cat $(PY-NEVOW_PATCHES) | $(PATCH) -d $(BUILD_DIR)/$(PY-NEVOW_DIR) -p1
	mv $(BUILD_DIR)/$(PY-NEVOW_DIR) $(@D)/2.7
	(cd $(@D)/2.7; \
	    ( \
	    echo "[build_scripts]"; \
	    echo "executable=$(TARGET_PREFIX)/bin/python2.7"; \
	    echo "[install]"; \
	    echo "install_scripts=$(TARGET_PREFIX)/bin"; \
	    ) >> setup.cfg \
	)
	touch $@

py-nevow-unpack: $(PY-NEVOW_BUILD_DIR)/.configured

#
# This builds the actual binary.
#
$(PY-NEVOW_BUILD_DIR)/.built: $(PY-NEVOW_BUILD_DIR)/.configured
	rm -f $@
	cd $(@D)/2.5; \
		PYTHONPATH=$(STAGING_LIB_DIR)/python2.5/site-packages \
		$(HOST_STAGING_PREFIX)/bin/python2.5 setup.py build
	cd $(@D)/2.6; \
		PYTHONPATH=$(STAGING_LIB_DIR)/python2.6/site-packages \
		$(HOST_STAGING_PREFIX)/bin/python2.6 setup.py build
	cd $(@D)/2.7; \
		PYTHONPATH=$(STAGING_LIB_DIR)/python2.7/site-packages \
		$(HOST_STAGING_PREFIX)/bin/python2.7 setup.py build
	touch $@

#
# This is the build convenience target.
#
py-nevow: $(PY-NEVOW_BUILD_DIR)/.built

#
# If you are building a library, then you need to stage it too.
#
$(PY-NEVOW_BUILD_DIR)/.staged: $(PY-NEVOW_BUILD_DIR)/.built
	rm -f $@
#	$(MAKE) -C $(PY-NEVOW_BUILD_DIR) DESTDIR=$(STAGING_DIR) install
	touch $@

py-nevow-stage: $(PY-NEVOW_BUILD_DIR)/.staged

#
# This rule creates a control file for ipkg.  It is no longer
# necessary to create a seperate control file under sources/py-nevow
#
$(PY-NEVOW-COMMON_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: py-nevow-common" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PY-NEVOW_PRIORITY)" >>$@
	@echo "Section: $(PY-NEVOW_SECTION)" >>$@
	@echo "Version: $(PY-NEVOW_VERSION)-$(PY-NEVOW_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PY-NEVOW_MAINTAINER)" >>$@
	@echo "Source: $(PY-NEVOW_SITE)/$(PY-NEVOW_SOURCE)" >>$@
	@echo "Description: $(PY-NEVOW_DESCRIPTION). Documents package." >>$@
	@echo "Depends:" >>$@
	@echo "Conflicts: $(PY-NEVOW_CONFLICTS)" >>$@

$(PY25-NEVOW_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: py25-nevow" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PY-NEVOW_PRIORITY)" >>$@
	@echo "Section: $(PY-NEVOW_SECTION)" >>$@
	@echo "Version: $(PY-NEVOW_VERSION)-$(PY-NEVOW_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PY-NEVOW_MAINTAINER)" >>$@
	@echo "Source: $(PY-NEVOW_SITE)/$(PY-NEVOW_SOURCE)" >>$@
	@echo "Description: $(PY-NEVOW_DESCRIPTION)" >>$@
	@echo "Depends: $(PY25-NEVOW_DEPENDS)" >>$@
	@echo "Conflicts: $(PY-NEVOW_CONFLICTS)" >>$@

$(PY26-NEVOW_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: py26-nevow" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PY-NEVOW_PRIORITY)" >>$@
	@echo "Section: $(PY-NEVOW_SECTION)" >>$@
	@echo "Version: $(PY-NEVOW_VERSION)-$(PY-NEVOW_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PY-NEVOW_MAINTAINER)" >>$@
	@echo "Source: $(PY-NEVOW_SITE)/$(PY-NEVOW_SOURCE)" >>$@
	@echo "Description: $(PY-NEVOW_DESCRIPTION)" >>$@
	@echo "Depends: $(PY26-NEVOW_DEPENDS)" >>$@
	@echo "Conflicts: $(PY-NEVOW_CONFLICTS)" >>$@

$(PY27-NEVOW_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: py27-nevow" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PY-NEVOW_PRIORITY)" >>$@
	@echo "Section: $(PY-NEVOW_SECTION)" >>$@
	@echo "Version: $(PY-NEVOW_VERSION)-$(PY-NEVOW_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PY-NEVOW_MAINTAINER)" >>$@
	@echo "Source: $(PY-NEVOW_SITE)/$(PY-NEVOW_SOURCE)" >>$@
	@echo "Description: $(PY-NEVOW_DESCRIPTION)" >>$@
	@echo "Depends: $(PY27-NEVOW_DEPENDS)" >>$@
	@echo "Conflicts: $(PY-NEVOW_CONFLICTS)" >>$@

#
# This builds the IPK file.
#
# Binaries should be installed into $(PY-NEVOW_IPK_DIR)$(TARGET_PREFIX)/sbin or $(PY-NEVOW_IPK_DIR)$(TARGET_PREFIX)/bin
# (use the location in a well-known Linux distro as a guide for choosing sbin or bin).
# Libraries and include files should be installed into $(PY-NEVOW_IPK_DIR)$(TARGET_PREFIX)/{lib,include}
# Configuration files should be installed in $(PY-NEVOW_IPK_DIR)$(TARGET_PREFIX)/etc/py-nevow/...
# Documentation files should be installed in $(PY-NEVOW_IPK_DIR)$(TARGET_PREFIX)/doc/py-nevow/...
# Daemon startup scripts should be installed in $(PY-NEVOW_IPK_DIR)$(TARGET_PREFIX)/etc/init.d/S??py-nevow
#
# You may need to patch your application to make it use these locations.
#
$(PY25-NEVOW_IPK): $(PY-NEVOW_BUILD_DIR)/.built
	rm -rf $(PY25-NEVOW_IPK_DIR) $(BUILD_DIR)/py25-nevow_*_$(TARGET_ARCH).ipk
	(cd $(PY-NEVOW_BUILD_DIR)/2.5; \
		PYTHONPATH=$(STAGING_LIB_DIR)/python2.5/site-packages \
		$(HOST_STAGING_PREFIX)/bin/python2.5 setup.py install \
		--root=$(PY25-NEVOW_IPK_DIR) --prefix=$(TARGET_PREFIX))
	rm -rf $(PY25-NEVOW_IPK_DIR)$(TARGET_PREFIX)/doc
	$(MAKE) $(PY25-NEVOW_IPK_DIR)/CONTROL/control
	echo $(PY-NEVOW_CONFFILES) | sed -e 's/ /\n/g' > $(PY25-NEVOW_IPK_DIR)/CONTROL/conffiles
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PY25-NEVOW_IPK_DIR)

$(PY26-NEVOW_IPK): $(PY-NEVOW_BUILD_DIR)/.built
	rm -rf $(PY26-NEVOW_IPK_DIR) $(BUILD_DIR)/py26-nevow_*_$(TARGET_ARCH).ipk
	(cd $(PY-NEVOW_BUILD_DIR)/2.6; \
		PYTHONPATH=$(STAGING_LIB_DIR)/python2.6/site-packages \
		$(HOST_STAGING_PREFIX)/bin/python2.6 setup.py install \
		--root=$(PY26-NEVOW_IPK_DIR) --prefix=$(TARGET_PREFIX))
	rm -rf $(PY26-NEVOW_IPK_DIR)$(TARGET_PREFIX)/doc
	$(MAKE) $(PY26-NEVOW_IPK_DIR)/CONTROL/control
	echo $(PY-NEVOW_CONFFILES) | sed -e 's/ /\n/g' > $(PY26-NEVOW_IPK_DIR)/CONTROL/conffiles
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PY26-NEVOW_IPK_DIR)

$(PY27-NEVOW_IPK) $(PY-NEVOW-COMMON_IPK): $(PY-NEVOW_BUILD_DIR)/.built
	rm -rf $(PY27-NEVOW_IPK_DIR) $(BUILD_DIR)/py27-nevow_*_$(TARGET_ARCH).ipk
	rm -rf $(PY-NEVOW-COMMON_IPK_DIR) $(BUILD_DIR)/py-nevow-common_*_$(TARGET_ARCH).ipk
	(cd $(PY-NEVOW_BUILD_DIR)/2.7; \
		PYTHONPATH=$(STAGING_LIB_DIR)/python2.7/site-packages \
		$(HOST_STAGING_PREFIX)/bin/python2.7 setup.py install \
		--root=$(PY27-NEVOW_IPK_DIR) --prefix=$(TARGET_PREFIX))
	for f in $(PY27-NEVOW_IPK_DIR)$(TARGET_PREFIX)/bin/*; \
		do mv $$f `echo $$f | sed 's|$$|-2.7|'`; done
	$(INSTALL) -d $(PY-NEVOW-COMMON_IPK_DIR)$(TARGET_PREFIX)/share
	mv $(PY27-NEVOW_IPK_DIR)$(TARGET_PREFIX)/doc $(PY-NEVOW-COMMON_IPK_DIR)$(TARGET_PREFIX)/share
	$(MAKE) $(PY27-NEVOW_IPK_DIR)/CONTROL/control
	$(MAKE) $(PY-NEVOW-COMMON_IPK_DIR)/CONTROL/control
	echo $(PY-NEVOW_CONFFILES) | sed -e 's/ /\n/g' > $(PY27-NEVOW_IPK_DIR)/CONTROL/conffiles
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PY27-NEVOW_IPK_DIR)
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PY-NEVOW-COMMON_IPK_DIR)

#
# This is called from the top level makefile to create the IPK file.
#
py-nevow-ipk: $(PY25-NEVOW_IPK) $(PY26-NEVOW_IPK) $(PY27-NEVOW_IPK)

#
# This is called from the top level makefile to clean all of the built files.
#
py-nevow-clean:
	-$(MAKE) -C $(PY-NEVOW_BUILD_DIR) clean

#
# This is called from the top level makefile to clean all dynamically created
# directories.
#
py-nevow-dirclean:
	rm -rf $(BUILD_DIR)/$(PY-NEVOW_DIR) $(PY-NEVOW_BUILD_DIR)
	rm -rf $(PY25-NEVOW_IPK_DIR) $(PY25-NEVOW_IPK)
	rm -rf $(PY26-NEVOW_IPK_DIR) $(PY26-NEVOW_IPK)
	rm -rf $(PY27-NEVOW_IPK_DIR) $(PY27-NEVOW_IPK)

#
# Some sanity check for the package.
#
py-nevow-check: $(PY25-NEVOW_IPK) $(PY26-NEVOW_IPK) $(PY27-NEVOW_IPK)
	perl scripts/optware-check-package.pl --target=$(OPTWARE_TARGET) $^
