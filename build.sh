#!/bin/bash
# TRIMCheck build script
# Copyright Doug Richardson 2015
# Usage: build.sh 
#
# The result is a disk image that contains the TRIMCheck installer.
#

DSTROOT=/tmp/trimcheck.dst
SRCROOT=/tmp/trimcheck.src

INSTALLER_PATH=/tmp/trimcheck
INSTALLER_PKG="TRIMCheck.pkg"
INSTALLER="$INSTALLER_PATH/$INSTALLER_PKG"

#
# Clean out anything that doesn't belong.
#
echo Going to clean out build directories
rm -rf build $DSTROOT $SRCROOT $INSTALLER_PATH 
echo Build directories cleaned out


#
# Build
#
echo ------------------
echo Installing Sources
echo ------------------
xcodebuild -project TRIMCheck.xcodeproj installsrc SRCROOT=$SRCROOT || exit 1

echo ----------------
echo Building Project
echo ----------------
pushd $SRCROOT
xcodebuild -project TRIMCheck.xcodeproj -target all -configuration Release install || exit 1
popd

#
# Make installer
#
echo ----------
echo Fixup Root
echo ----------

# Get rid of everything in /usr/local like. Don't do everything automatically, otherwise
# you might slightly delete something you need.
DSTLOCAL="$DSTROOT/usr/local/bin"
rm "$DSTLOCAL/trimcheck" || exit 1
rmdir "$DSTROOT/usr/local/bin/" || exit 1
rmdir "$DSTROOT/usr/local" || exit 1
rmdir "$DSTROOT/usr" || exit 1


echo ------------------
echo Building Installer
echo ------------------
mkdir -p "$INSTALLER_PATH" || exit 1
pushd installer

echo "Runing pkgbuild. Note you must be connected to Internet for this to work as it"
echo "has to contact a time server in order to generate a trusted timestamp. See"
echo "man pkgbuild for more info under SIGNED PACKAGES."
pkgbuild --identifier "com.delicioussafari.TRIMCheck" \
    --scripts "$SRCROOT/installer/scripts" \
    --sign "Developer ID Installer: Douglas Richardson (4L84QT8KA9)" \
    --root "$DSTROOT" \
    "$INSTALLER" || exit 1


echo Successfully built TRIMCheck
open .
popd

exit 0
