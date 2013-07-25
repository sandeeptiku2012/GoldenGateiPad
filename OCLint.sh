#!/bin/sh

#  OCLint.sh
#  GoldenGate
#
#  Created by Andreas Petrov on 9/19/12.
#  Copyright (c) 2012 Knowit. All rights reserved.

#! /bin/bash

LANGUAGE=objective-c
ARCH=armv7
SYSROOT=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS5.1.sdk
CLANG_INCLUDE=/usr/lib/clang/3.1/include
OTHER_INCLUDE=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator5.1.sdk/usr/include
PCH_PATH=./GoldenGate/GoldenGate-Prefix.pch
FRAMEWORKS='UIKit'


INCLUDES=''
for folder in `find . -type d`
do
INCLUDES="$INCLUDES -I $folder"
done

FILES=''
for file in `find . -name "*.m"`
do
FILES="$FILES $file"
done

oclint  -stats  -x $LANGUAGE -arch $ARCH -isysroot=$SYSROOT -I $CLANG_INCLUDE $INCLUDES -I $OTHER_INCLUDE -include $PCH_PATH $FILES