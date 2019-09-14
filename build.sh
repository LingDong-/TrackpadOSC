#!/bin/bash
clang -F/System/Library/PrivateFrameworks -framework MultitouchSupport -Werror -O0 -g trackpadOSC.m include/tinyosc/tinyosc.c -o TrackpadOSC