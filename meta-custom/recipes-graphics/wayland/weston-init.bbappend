FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://background.jpg"

# Remove weston tool bar and set background 
do_install:append() {
    # Copy the background photo
    install -d ${D}/usr/share/backgrounds
    install -m 0644 ${WORKDIR}/background.jpg ${D}/usr/share/backgrounds
    # Configure weston
    sed -i -e "s/^#\\[shell\\]/[shell]/g" ${D}${sysconfdir}/xdg/weston/weston.ini
    sed -i -e "/panel-position=/d" ${D}${sysconfdir}/xdg/weston/weston.ini
    sed -i -e "/^\[shell\]/a panel-position=none" ${D}${sysconfdir}/xdg/weston/weston.ini
    sed -i -e "/background-image=/d" ${D}${sysconfdir}/xdg/weston/weston.ini
    sed -i -e "/^\[shell\]/a background-image=/usr/share/backgrounds/background.jpg" ${D}${sysconfdir}/xdg/weston/weston.ini
}
FILES:${PN} += "/usr/share/backgrounds/background.jpg"
