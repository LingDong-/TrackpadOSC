#!/bin/bash
clang -F/System/Library/PrivateFrameworks -framework MultitouchSupport -framework CoreFoundation -Werror -O0 -g trackpadOSC.m include/tinyosc/tinyosc.c -o TrackpadOSC
