DESCRIPTION = "Custom image for driver seat auto-positioning"
LICENSE = "MIT"

# Define qt packages
QT_DEPENDS = " \
    qtbase \
    qtbase-plugins \
    qtbase-tools \
    qtdeclarative \
    qtdeclarative-plugins \
    qtgraphicaleffects \
    qtmultimedia \
    qtsvg \
    qtquickcontrols \
    qtquickcontrols2 \
    qtwayland \
"

inherit core-image
inherit populate_sdk_qt5

# Include necessary packages
IMAGE_INSTALL += "\
    wayland \
    weston \
    ${QT_DEPENDS} \
"
IMAGE_INSTALL += "\
	qt-vsomeip \
	vsomeip \
"
IMAGE_FEATURES += "ssh-server-openssh"
SYSTEMD_DEFAULT_TARGET = "graphical.target"

# Adjust the size according to your requirements
IMAGE_ROOTFS_SIZE = "4096000"  

# define time, and language configuration settings
TIMEZONE = "UTC"
IMAGE_LINGUAS = "en-us"
