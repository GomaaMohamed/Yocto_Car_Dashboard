SUMMARY = "Implementation of SOME/IP protocol"
DESCRIPTION = "A C++ implementation of the SOME/IP (Scalable service-Oriented MiddlewarE over IP) protocol"
SECTION = "base"
LICENSE = "MPL-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=9741c346eef56131163e13b9db1241b3"

DEPENDS = "boost"

SRC_URI = "git://github.com/COVESA/vsomeip.git;protocol=https;branch=master"

SRCREV = "cf497232adf84f55947f7a24e1b64e04b49f1f38"

S = "${WORKDIR}/git"

inherit cmake lib_package gitpkgv

CMAKE_ARGS += "-DENABLE_SIGNAL_HANDLING=1"

FILES:${PN} = "/usr/lib/* /usr/include/* /usr/etc/vsomeip/*"

