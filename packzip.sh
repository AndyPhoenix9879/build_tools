#!/bin/bash
set -e
LGREEN='\033[1;32m'

KERNEL_UNSIGNED=destiny_r3-unsigned.zip
KERNEL_FALSE_SIGNED=destiny_r3-false_signed.zip
KERNEL_ADJUSTED_UNSIGNED=destiny_r3-adjusted_unsigned.zip
KERNEL_NAME=destiny_r3.zip
cd zipme
zip -r ../$KERNEL_UNSIGNED .
cd ..

java -Xmx2048m -jar signing/signapk.jar -w signing/testkey.x509.pem signing/testkey.pk8 $KERNEL_UNSIGNED $KERNEL_FALSE_SIGNED
rm -f $KERNEL_UNSIGNED
signing/zipadjust $KERNEL_FALSE_SIGNED $KERNEL_ADJUSTED_UNSIGNED
rm -f $KERNEL_FALSE_SIGNED
java -Xmx2048m -jar signing/minsignapk.jar signing/testkey.x509.pem signing/testkey.pk8 $KERNEL_ADJUSTED_UNSIGNED RELEASE/$KERNEL_NAME
rm -f $KERNEL_ADJUSTED_UNSIGNED

echo -e "${LGREEN}Destiny kernel sucessfully packed and signed as ${KERNEL_NAME}!${NCOLOR}"

