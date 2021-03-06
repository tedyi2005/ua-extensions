#!/bin/bash -ex

# Copyright 2009-2015 Urban Airship Inc. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE URBAN AIRSHIP INC ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
# EVENT SHALL URBAN AIRSHIP INC OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

SCRIPT_DIRECTORY=`dirname "${0}"`
OUTPUT_PATH="${SCRIPT_DIRECTORY}/output"
PROJECT_DIRECTORY="${SCRIPT_DIRECTORY}/UAEventTemplates"

# Clean up output directory
rm -rf $OUTPUT_PATH
mkdir -p $OUTPUT_PATH

# Grab the release version
VERSION=$(awk <$SCRIPT_DIRECTORY/UAEventTemplates/Config.xcconfig "\$1 == \"CURRENT_PROJECT_VERSION\" { print \$3 }")
echo "VERSION: ${VERSION}"

# Update CFBundleShortVersionString of UAEventTemplates and UAEventTemplatesTests Info.plist with the release version
cd $PROJECT_DIRECTORY
agvtool new-marketing-version ${VERSION}
cd -
pwd

# Copy README
echo "cp -R \"${SCRIPT_DIRECTORY}/README.rst\" \"${OUTPUT_PATH}\""
cp -R "${SCRIPT_DIRECTORY}/README.rst" "${OUTPUT_PATH}"

# Copy UAEventTemplates
echo "cp -R \"${SCRIPT_DIRECTORY}/UAEventTemplates\" \"${OUTPUT_PATH}\""
cp -R "${SCRIPT_DIRECTORY}/UAEventTemplates" "${OUTPUT_PATH}"


# Remove project.xcworkspace
rm -rf "${OUTPUT_PATH}/UAEventTemplates/UAEventTemplates.xcodeproj/project.xcworkspace"

cd $OUTPUT_PATH
for PACKAGE in UAEventTemplates; do
    zip -r uaEventTemplates-$VERSION.zip $PACKAGE --exclude=*.DS_Store*
done
cd -
