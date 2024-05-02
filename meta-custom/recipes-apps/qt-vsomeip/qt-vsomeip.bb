SUMMARY = "QT Example Recipe"
LICENSE = "CLOSED"

SRC_URI = "file://CMakeLists.txt \
           file://DashboardClient \
           file://Configurations \
           file://dashboard.service \
           "

DEPENDS += "qtbase \
            wayland \
            qtdeclarative \
            qtgraphicaleffects \
            qtmultimedia \
            qtsvg \
            qtquickcontrols \
            qtquickcontrols2 \
            qtwayland \
            vsomeip \
            systemd"
RDEPENDS:${PN} += "qtbase \
                    wayland \
                    qtdeclarative \
                    qtgraphicaleffects \
                    qtmultimedia \
                    qtsvg \
                    qtquickcontrols \
                    qtquickcontrols2 \
                    qtwayland \
                    vsomeip \
                    systemd"

S = "${WORKDIR}"

OECMAKE_GENERATOR = "Unix Makefiles"

inherit pkgconfig cmake cmake_qt5 systemd

SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE:${PN} = "dashboard.service"

FILES:${PN} += "/usr/bin/dashboard_app"
FILES:${PN} += "/usr/etc/vsomeip/Configurations"
FILES:${PN} += "/usr/etc/vsomeip/Configurations/*.json"
FILES:${PN} += "/lib/systemd/system"
FILES:${PN} += "/system/dashboard.service"

