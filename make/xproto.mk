###########################################################
#
# xproto
#
###########################################################

#
# XPROTO_VERSION, XPROTO_SITE and XPROTO_SOURCE define
# the upstream location of the source code for the package.
# XPROTO_DIR is the directory which is created when the source
# archive is unpacked.
# XPROTO_UNZIP is the command used to unzip the source.
# It is usually "zcat" (for .gz) or "bzcat" (for .bz2)
#
# You should change all these variables to suit your package.
#
XPROTO_SITE=http://xorg.freedesktop.org/releases/individual/proto
XPROTO_SOURCE=xproto-$(XPROTO_VERSION).tar.gz
XPROTO_VERSION=7.0.27
XPROTO_DIR=xproto-$(XPROTO_VERSION)
XPROTO_MAINTAINER=NSLU2 Linux <nslu2-linux@yahoogroups.com>
XPROTO_DESCRIPTION=X protocol headers
XPROTO_SECTION=lib
XPROTO_PRIORITY=optional

#
# XPROTO_IPK_VERSION should be incremented when the ipk changes.
#
XPROTO_IPK_VERSION=1

#
# XPROTO_CONFFILES should be a list of user-editable files
XPROTO_CONFFILES=

#
# XPROTO_PATCHES should list any patches, in the the order in
# which they should be applied to the source code.
#
#XPROTO_PATCHES=$(XPROTO_SOURCE_DIR)/autogen.sh.patch

#
# If the compilation of the package requires additional
# compilation or linking flags, then list them here.
#
XPROTO_CPPFLAGS=
XPROTO_LDFLAGS=

#
# XPROTO_BUILD_DIR is the directory in which the build is done.
# XPROTO_SOURCE_DIR is the directory which holds all the
# patches and ipkg control files.
# XPROTO_IPK_DIR is the directory in which the ipk is built.
# XPROTO_IPK is the name of the resulting ipk files.
#
# You should not change any of these variables.
#
XPROTO_BUILD_DIR=$(BUILD_DIR)/xproto
XPROTO_SOURCE_DIR=$(SOURCE_DIR)/xproto
XPROTO_IPK_DIR=$(BUILD_DIR)/xproto-$(XPROTO_VERSION)-ipk
XPROTO_IPK=$(BUILD_DIR)/xproto_$(XPROTO_VERSION)-$(XPROTO_IPK_VERSION)_$(TARGET_ARCH).ipk

#
# Automatically create a ipkg control file
#
$(XPROTO_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(XPROTO_IPK_DIR)/CONTROL
	@rm -f $@
	@echo "Package: xproto" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(XPROTO_PRIORITY)" >>$@
	@echo "Section: $(XPROTO_SECTION)" >>$@
	@echo "Version: $(XPROTO_VERSION)-$(XPROTO_IPK_VERSION)" >>$@
	@echo "Maintainer: $(XPROTO_MAINTAINER)" >>$@
	@echo "Source: $(XPROTO_SITE)/$(XPROTO_SOURCE)" >>$@
	@echo "Description: $(XPROTO_DESCRIPTION)" >>$@

#
# This is the dependency on the source code.  If the source is missing,
# then it will be fetched from the site using wget.
#
$(DL_DIR)/$(XPROTO_SOURCE):
	$(WGET) -P $(@D) $(XPROTO_SITE)/$(@F) || \
	$(WGET) -P $(@D) $(SOURCES_NLO_SITE)/$(@F)

xproto-source: $(DL_DIR)/$(XPROTO_SOURCE) $(XPROTO_PATCHES)

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
$(XPROTO_BUILD_DIR)/.configured: $(DL_DIR)/$(XPROTO_SOURCE) $(XPROTO_PATCHES) make/xproto.mk
	rm -rf $(BUILD_DIR)/$(XPROTO_DIR) $(@D)
	tar -C $(BUILD_DIR) -xzf $(DL_DIR)/$(XPROTO_SOURCE)
	if test -n "$(XPROTO_PATCHES)" ; \
		then cat $(XPROTO_PATCHES) | \
		$(PATCH) -d $(BUILD_DIR)/$(XPROTO_DIR) -p1 ; \
	fi
	if test "$(BUILD_DIR)/$(XPROTO_DIR)" != "$(@D)" ; \
		then mv $(BUILD_DIR)/$(XPROTO_DIR) $(@D) ; \
	fi
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) \
		CPPFLAGS="$(STAGING_CPPFLAGS) $(XPROTO_CPPFLAGS)" \
		LDFLAGS="$(STAGING_LDFLAGS) $(XPROTO_LDFLAGS)" \
		PKG_CONFIG_PATH="$(STAGING_LIB_DIR)/pkgconfig" \
		PKG_CONFIG_LIBDIR="$(STAGING_LIB_DIR)/pkgconfig" \
		./configure \
		--build=$(GNU_HOST_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--target=$(GNU_TARGET_NAME) \
		--prefix=$(TARGET_PREFIX) \
		--disable-static \
	)
	touch $@

xproto-unpack: $(XPROTO_BUILD_DIR)/.configured

#
# This builds the actual binary.
#
$(XPROTO_BUILD_DIR)/.built: $(XPROTO_BUILD_DIR)/.configured
	rm -f $@
	$(MAKE) -C $(@D)
	touch $@

#
# This is the build convenience target.
#
xproto: $(XPROTO_BUILD_DIR)/.built

#
# If you are building a library, then you need to stage it too.
#
$(XPROTO_BUILD_DIR)/.staged: $(XPROTO_BUILD_DIR)/.built
	rm -f $@
#	rm -rf $(STAGING_INCLUDE_DIR)/X11
	$(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
	sed -ie 's|^prefix=.*|prefix=$(STAGING_PREFIX)|' $(STAGING_LIB_DIR)/pkgconfig/xproto.pc
	touch $@

xproto-stage: $(XPROTO_BUILD_DIR)/.staged

#
# This builds the IPK file.
#
# Binaries should be installed into $(XPROTO_IPK_DIR)$(TARGET_PREFIX)/sbin or $(XPROTO_IPK_DIR)$(TARGET_PREFIX)/bin
# (use the location in a well-known Linux distro as a guide for choosing sbin or bin).
# Libraries and include files should be installed into $(XPROTO_IPK_DIR)$(TARGET_PREFIX)/{lib,include}
# Configuration files should be installed in $(XPROTO_IPK_DIR)$(TARGET_PREFIX)/etc/xproto/...
# Documentation files should be installed in $(XPROTO_IPK_DIR)$(TARGET_PREFIX)/doc/xproto/...
# Daemon startup scripts should be installed in $(XPROTO_IPK_DIR)$(TARGET_PREFIX)/etc/init.d/S??xproto
#
# You may need to patch your application to make it use these locations.
#
$(XPROTO_IPK): $(XPROTO_BUILD_DIR)/.built
	rm -rf $(XPROTO_IPK_DIR) $(BUILD_DIR)/xproto_*_$(TARGET_ARCH).ipk
	$(MAKE) -C $(XPROTO_BUILD_DIR) DESTDIR=$(XPROTO_IPK_DIR) install
	$(MAKE) $(XPROTO_IPK_DIR)/CONTROL/control
	cd $(BUILD_DIR); $(IPKG_BUILD) $(XPROTO_IPK_DIR)

#
# This is called from the top level makefile to create the IPK file.
#
xproto-ipk: $(XPROTO_IPK)

#
# This is called from the top level makefile to clean all of the built files.
#
xproto-clean:
	-$(MAKE) -C $(XPROTO_BUILD_DIR) clean

#
# This is called from the top level makefile to clean all dynamically created
# directories.
#
xproto-dirclean:
	rm -rf $(BUILD_DIR)/$(XPROTO_DIR) $(XPROTO_BUILD_DIR) $(XPROTO_IPK_DIR) $(XPROTO_IPK)
