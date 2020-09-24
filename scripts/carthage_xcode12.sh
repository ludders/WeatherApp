#!/bin/zsh

### Usage ###
#
# Usage example: ./carthage_xcode12.sh update --platform iOS
# 
# This is to work around an issue with Xcode 12 beta 3
#
# https://github.com/Carthage/Carthage/issues/3019 
#
###

set -euo pipefail

xcconfig=$(mktemp /tmp/static.xcconfig.XXXXXX) # create temp xcconfig for carthage
trap 'rm -f "$xcconfig"' INT TERM HUP EXIT # delete temp xcconfig at end of script

# For Xcode 12 make sure EXCLUDED_ARCHS is set to arm architectures otherwise
# the build will fail on lipo due to duplicate architectures.
# Beta 5:
echo 'EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_simulator__NATIVE_ARCH_64_BIT_x86_64__XCODE_1200__BUILD_12A7209 = arm64 arm64e armv7 armv7s armv6 armv8' >> $xcconfig
echo 'EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_simulator__NATIVE_ARCH_64_BIT_x86_64__XCODE_1200 = $(EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_simulator__NATIVE_ARCH_64_BIT_x86_64__XCODE_1200__BUILD_$(XCODE_PRODUCT_BUILD_VERSION))' >> $xcconfig
echo 'EXCLUDED_ARCHS = $(inherited) $(EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_$(EFFECTIVE_PLATFORM_SUFFIX)__NATIVE_ARCH_64_BIT_$(NATIVE_ARCH_64_BIT)__XCODE_$(XCODE_VERSION_MAJOR))' >> $xcconfig

export XCODE_XCCONFIG_FILE="$xcconfig"
carthage "$@"
