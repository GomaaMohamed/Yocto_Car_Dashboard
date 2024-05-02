DESCRIPTION = "Initscripts for mounting filesystems"
LICENSE = "CLOSED"

SRC_URI += "file://initapps.sh"
INITSCRIPT_NAME = "initapps.sh"
INITSCRIPT_PARAMS = "start 09 S ."

inherit update-rc.d

S = "${WORKDIR}"

do_install () {
    install -d ${D}${sysconfdir}/init.d/
    install -c -m 755 ${WORKDIR}/${INITSCRIPT_NAME} ${D}${sysconfdir}/init.d/${INITSCRIPT_NAME}
}
