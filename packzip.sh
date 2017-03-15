#!/bin/bash
set -e
LGREEN='\033[1;32m'

KERNEL_UNSIGNED=v6-unsigned.zip
KERNEL_FALSE_SIGNED=v6-false_signed.zip
KERNEL_ADJUSTED_UNSIGNED=v6_unsigned.zip
KERNEL_NAME=v6.zip
cd zipme
zip -r ../$KERNEL_UNSIGNED .
cd ..

java -Xmx2048m -jar signing/signapk.jar -w signing/testkey.x509.pem signing/testkey.pk8 $KERNEL_UNSIGNED $KERNEL_FALSE_SIGNED
rm -f $KERNEL_UNSIGNED
signing/zipadjust $KERNEL_FALSE_SIGNED $KERNEL_ADJUSTED_UNSIGNED
rm -f $KERNEL_FALSE_SIGNED
java -Xmx2048m -jar signing/minsignapk.jar signing/testkey.x509.pem signing/testkey.pk8 $KERNEL_ADJUSTED_UNSIGNED $KERNEL_NAME
rm -f $KERNEL_ADJUSTED_UNSIGNED

echo -e "${LGREEN}Destiny kernel sucessfully packed and signed as ${KERNEL_NAME}!${NCOLOR}"

