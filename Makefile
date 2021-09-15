#
# Copyright 2020 Vseal <admin@vseal.cn>
# Licensed to the public under the MIT License.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-frps-arm
PKG_VERSION:=0.37.1
PKG_RELEASE:=1

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE

PKG_MAINTAINER:=Vseal <admin@vseal.cn>

LUCI_TITLE:=LuCI Support For frps-arm
LUCI_PKGARCH:=all

define Package/$(PKG_NAME)/cp_server
$(INSTALL_DIR)$(1)/usr/bin/
$(INSTALL_BIN)./usr/bin/frps-arm $(1)/usr/bin/
endef

define Package/$(PKG_NAME)/conffiles
/etc/config/frps-arm
endef

include $(TOPDIR)/feeds/luci/luci.mk

define Package/$(PKG_NAME)/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	( . /etc/uci-defaults/40_luci-frps-arm ) && rm -f /etc/uci-defaults/40_luci-frps-arm
fi

chmod 755 "$${IPKG_INSTROOT}/etc/init.d/frps-arm" >/dev/null 2>&1
ln -sf "../init.d/frps-arm" \
	"$${IPKG_INSTROOT}/etc/rc.d/S99frps-arm" >/dev/null 2>&1
exit 0
endef

# call BuildPackage - OpenWrt buildroot signature
