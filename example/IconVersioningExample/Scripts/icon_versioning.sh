#!/usr/bin/env bash

# optional, to prevent versioning for release builds
if [[ $CONFIGURATION == "Release" ]]; then
    exit 0
fi

# optional, to fix fastlane warnings that show up in the Report navigator
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# make sure Bundler is found
export GEM_HOME=~/.gems
export PATH=$PATH:$GEM_HOME/bin

export FASTLANE_DISABLE_COLORS=1 # optional, to remove from the build log the ANSI escape sequences that enables colors in terminal
export FASTLANE_SKIP_UPDATE_CHECK=1 # optional, to make sure that the versioning finishes as fast as possible in case there is an available update
export FASTLANE_HIDE_GITHUB_ISSUES=1 # optional, to make sure that the versioning finishes as fast as possible in case the plugin crashes

bundle exec fastlane version_icon configuration:$CONFIGURATION
