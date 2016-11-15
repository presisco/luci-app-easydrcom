#
# Copyright (c) 2015 Presisco
# Author: presisco <internight@sina.com>
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-easydrcom
PKG_VERSION:=1.7
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-easydrcom
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=LuCI Configure interface for EasyDrcom
  MAINTAINER:=presisco <internight@sina.com>
  DEPENDS:=+easydrcom +luci
endef

define Package/luci-app-easydrcom/conffiles
/etc/config/easydrcom
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Compile/Default

endef
Build/Compile = $(Build/Compile/Default)

define Package/luci-app-easydrcom/install
	$(RM) $(1)/etc/init.d/easydrcom
	$(RM) $(1)/etc/config/easydrcom.conf
	$(CP) -a root/* $(1)
endef

define Package/luci-app-easydrcom/postinst

chmod 755 $(1)/usr/bin/easydrcom-daemon.sh
chmod 755 $(1)/etc/init.d/easydrcom-conf
	
endef

$(eval $(call BuildPackage,luci-app-easydrcom))
