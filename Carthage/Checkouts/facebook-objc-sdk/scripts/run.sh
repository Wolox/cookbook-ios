#!/bin/sh
# Copyright (c) 2014-present, Facebook, Inc. All rights reserved.
#
# You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
# copy, modify, and distribute this software in source code or binary form for use
# in connection with the web services and APIs provided by Facebook.
#
# As with any software that integrates with the Facebook platform, your use of
# this software is subject to the Facebook Developer Principles and Policies
# [http://developers.facebook.com/policy/]. This copyright notice shall be
# included in all copies or substantial portions of the software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# shellcheck disable=SC2039
# shellcheck disable=SC2005

set -euo pipefail

# --------------
# Imports
# --------------

if [ -f "$PWD/internal/scripts/internal_globals.sh" ]; then
  # shellcheck source=../internal/scripts/internal_globals.sh
  . "$PWD/internal/scripts/internal_globals.sh"
fi

if [ -f "$PWD/internal/scripts/intern_api.sh" ]; then
  # shellcheck source=../internal/scripts/intern_api.sh
  . "$PWD/internal/scripts/intern_api.sh"
fi

# --------------
# Functions
# --------------

# Main
main() {
  if [ -z "${SDK_SCRIPTS_DIR:-}" ]; then
    # Set global variables

    SDK_SCRIPTS_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
    SDK_DIR="$(dirname "$SDK_SCRIPTS_DIR")"

    CORE_KIT="FBSDKCoreKit"
    LOGIN_KIT="FBSDKLoginKit"
    SHARE_KIT="FBSDKShareKit"

    SDK_BASE_KITS=(
      "$CORE_KIT"
      "$LOGIN_KIT"
      "$SHARE_KIT"
    )

    SDK_KITS=(
      "${SDK_BASE_KITS[@]}"
      "FBSDKPlacesKit"
      "FBSDKMarketingKit"
      "FBSDKTVOSKit"
      "AccountKit"
    )

    SDK_VERSION_FILES=(
      "Configurations/Version.xcconfig"
      "FBSDKCoreKit/FBSDKCoreKit/FBSDKCoreKit.h"
      "FBSDKCoreKit/FBSDKCoreKit/Basics/Instrument/FBSDKCrashHandler.m"
      "AccountKit/AccountKit/Internal/AKFConstants.m"
    )

    SDK_GRAPH_API_VERSION_FILES=(
      "FBSDKCoreKit/FBSDKCoreKit/FBSDKCoreKit.h"
      "FBSDKCoreKit/FBSDKCoreKitTests/FBSDKGraphRequestTests.m"
    )

    SDK_MAIN_VERSION_FILE="FBSDKCoreKit/FBSDKCoreKit/FBSDKCoreKit.h"

    SDK_FRAMEWORK_NAME="FacebookSDK"

    SDK_POD_SPECS=("${SDK_KITS[@]}" "$SDK_FRAMEWORK_NAME")
    SDK_POD_SPECS=("${SDK_POD_SPECS[@]/%/.podspec}")
    SDK_POD_SPECS[6]="AccountKit/${SDK_POD_SPECS[6]}"

    SDK_LINT_POD_SPECS=(
      "FBSDKCoreKit.podspec"
      "FBSDKLoginKit.podspec"
      "FBSDKShareKit.podspec"
      "FBSDKPlacesKit.podspec"
      "FBSDKTVOSKit.podspec"
    )

    SDK_CURRENT_VERSION=$(grep -Eo 'FBSDK_VERSION_STRING @".*"' "$SDK_DIR/$SDK_MAIN_VERSION_FILE" | awk -F'"' '{print $2}')
    SDK_CURRENT_GRAPH_API_VERSION=$(grep -Eo 'FBSDK_TARGET_PLATFORM_VERSION @".*"' "$SDK_DIR/$SDK_MAIN_VERSION_FILE" | awk -F'"' '{print $2}')

    SDK_GIT_REMOTE="https://github.com/facebook/facebook-ios-sdk"

    SWIFT_PACKAGE_SCHEMES=(
      "FacebookCore"
      "FacebookLogin"
      "FacebookShare"
    )

    if [ -f "$PWD/internal/scripts/internal_globals.sh" ]; then SDK_INTERNAL=1; else SDK_INTERNAL=0; fi
  fi

  local command_type=${1:-}
  if [ -n "$command_type" ]; then shift; fi

  case "$command_type" in
  "build") build_sdk "$@" ;;
  "bump-version") bump_version "$@" ;;
  "bump-api-version") bump_api_version "$@" ;;
  "bump-changelog") bump_changelog "$@" ;;
  "check-release-status") check_release_status "$@" ;;
  "is-valid-semver") is_valid_semver "$@" ;;
  "does-version-exist") does_version_exist "$@" ;;
  "release") release_sdk "$@" ;;
  "setup") setup_sdk "$@" ;;
  "tag-current-version") tag_current_version "$@" ;;
  "lint") lint_sdk "$@" ;;
  "verify-spm-headers") verify_spm_headers "$@" ;;
  "--help" | "help") echo "Check main() for supported commands" ;;
  esac
}

# Setup SDK
setup_sdk() {
  local sdk_test_app_id=${1:-$SDK_TEST_FB_APP_ID}
  local sdk_test_app_secret=${2:-$SDK_TEST_FB_APP_SECRET}
  local sdk_test_client_token=${3:-$SDK_TEST_FB_CLIENT_TOKEN}
  local sdk_machine_unique_user_key=${4:-}

  {
    echo "IOS_SDK_TEST_APP_ID = $sdk_test_app_id"
    echo "IOS_SDK_TEST_APP_SECRET = $sdk_test_app_secret"
    echo "IOS_SDK_TEST_CLIENT_TOKEN = $sdk_test_client_token"
    echo "IOS_SDK_MACHINE_UNIQUE_USER_KEY = $sdk_machine_unique_user_key"
  } >>"$SDK_DIR"/Configurations/TestAppIdAndSecret.xcconfig
}

# Bump Version
bump_version() {
  local new_version=${1:-}

  if [ "$new_version" == "$SDK_CURRENT_VERSION" ]; then
    echo "This version is the same as the current version"
    false
    return
  fi

  if ! is_valid_semver "$new_version"; then
    echo "This version isn't a valid semantic versioning"
    false
    return
  fi

  echo "Changing from: $SDK_CURRENT_VERSION to: $new_version"

  local version_change_files=(
    "${SDK_VERSION_FILES[@]}"
    "${SDK_POD_SPECS[@]}"
  )

  # Replace the previous version to the new version in relative files
  for file_path in "${version_change_files[@]}"; do
    local full_file_path="$SDK_DIR/$file_path"

    if [ ! -f "$full_file_path" ]; then
      echo "*** NOTE: unable to find $full_file_path."
      continue
    fi

    local temp_file="$full_file_path.tmp"
    sed -e "s/$SDK_CURRENT_VERSION/$new_version/g" "$full_file_path" >"$temp_file"
    if diff "$full_file_path" "$temp_file" >/dev/null; then
      echo "*** ERROR: unable to update $full_file_path"
      rm "$temp_file"
      continue
    fi

    mv "$temp_file" "$full_file_path"
  done

  bump_changelog "$new_version"
}

# Bump Version
bump_api_version() {
  local new_version=${1:-}

  if [ "$new_version" == "$SDK_CURRENT_GRAPH_API_VERSION" ]; then
    echo "This version is the same as the current version"
    false
    return
  fi

  echo "Changing from: $SDK_CURRENT_GRAPH_API_VERSION to: $new_version"

  # Replace the previous version to the new version in relative files
  for file_path in "${SDK_GRAPH_API_VERSION_FILES[@]}"; do
    local full_file_path="$SDK_DIR/$file_path"

    if [ ! -f "$full_file_path" ]; then
      echo "*** NOTE: unable to find $full_file_path."
      continue
    fi

    local temp_file="$full_file_path.tmp"
    sed -e "s/$SDK_CURRENT_GRAPH_API_VERSION/$new_version/g" "$full_file_path" >"$temp_file"
    if diff "$full_file_path" "$temp_file" >/dev/null; then
      echo "*** ERROR: unable to update $full_file_path"
      rm "$temp_file"
      continue
    fi

    mv "$temp_file" "$full_file_path"
  done
}

bump_changelog() {
  local new_version=${1:-}

  # Edit Changelog
  local updated_changelog=""

  while IFS= read -r line; do
    local updated_line

    case "$line" in
    "[Full Changelog]("*"$SDK_CURRENT_VERSION...HEAD)")
      local current_date
      current_date=$(date +%Y-%m-%d)

      updated_line="\n""${line/$SDK_CURRENT_VERSION/$new_version}""\n\n"
      updated_line=$updated_line"## $new_version\n\n"
      updated_line=$updated_line"[$current_date]"
      updated_line=$updated_line"($SDK_GIT_REMOTE/releases/tag/v$new_version) |\n"
      updated_line=$updated_line"[Full Changelog]($SDK_GIT_REMOTE/compare/v$SDK_CURRENT_VERSION...v$new_version)"
      ;;
    "# Changelog") updated_line=$line ;;
    *) updated_line="\n"$line ;;
    esac

    updated_changelog=$updated_changelog$updated_line
  done <"CHANGELOG.md"

  echo "$updated_changelog" >CHANGELOG.md
}

# Tag push current version
tag_current_version() {
  if ! is_valid_semver "$SDK_CURRENT_VERSION"; then
    exit 1
  fi

  if does_version_exist "$SDK_CURRENT_VERSION"; then
    echo "Version $SDK_CURRENT_VERSION already exists"
    false
    return
  fi

  git tag -a "v$SDK_CURRENT_VERSION" -m "Version $SDK_CURRENT_VERSION"

  if [ "${1:-}" == "--push" ]; then
    git push origin "v$SDK_CURRENT_VERSION"
  fi
}

# Build
build_sdk() {
  build_xcode_workspace() {
    # Redirecting to /dev/null because we only care about errors here and the full output drowns Travis
    xcodebuild build \
      -workspace "${1:-}" \
      -sdk "${2:-}" \
      -scheme "${3:-}" \
      -configuration Debug > /dev/null
  }

  # Builds all Swift dynamic frameworks.
  # Stores the output in the top level build directory
  # This should be combined with the build_carthage function
  # once we drop support for Xcode 10.2
  build_swift() {
    mkdir -p Temp
    xcodebuild clean build \
      -workspace "${1:-}" \
      -sdk "${2:-}" \
      -scheme BuildAllSwiftKits \
      -configuration Debug \
      -derivedDataPath Temp

    for kit in "${SDK_BASE_KITS[@]}"; do
      mv Temp/Build/Products/Debug-iphonesimulator/"$kit".framework build
    done

    rm -rf Temp
  }

  build_carthage() {
    carthage build --no-skip-current

    if [ "${1:-}" == "--archive" ]; then
      carthage archive --output Carthage/Release/
    fi
  }

  build_spm() {
    for scheme in "${SWIFT_PACKAGE_SCHEMES[@]}"; do
    xcodebuild clean build \
      -workspace .swiftpm/xcode/package.xcworkspace \
      -scheme "$scheme" \
      -sdk iphonesimulator \
      OTHER_SWIFT_FLAGS="-D SWIFT_PACKAGE"
    done
  }

  build_spm_integration() {
    cd "$SDK_DIR"/samples/SmoketestSPM

    /usr/libexec/PlistBuddy \
      -c "delete :objects:F4CEA53E23C29C9E0086EB16:requirement:branch" \
      SmoketestSPM.xcodeproj/project.pbxproj

    /usr/libexec/PlistBuddy \
      -c "add :objects:F4CEA53E23C29C9E0086EB16:requirement:revision string $TRAVIS_COMMIT" \
      SmoketestSPM.xcodeproj/project.pbxproj

    /usr/libexec/PlistBuddy \
      -c "set :objects:F4CEA53E23C29C9E0086EB16:requirement:kind revision" \
      SmoketestSPM.xcodeproj/project.pbxproj

    xcodebuild build -scheme SmoketestSPM \
      -sdk iphonesimulator \
      -verbose
  }

  local build_type=${1:-}
  if [ -n "$build_type" ]; then shift; fi

  case "$build_type" in
  "carthage") build_carthage "$@" ;;
  "spm") build_spm "$@" ;;
  "spm-integration") build_spm_integration ;;
  "swift") build_swift "$@" ;;
  "xcode") build_xcode_workspace "$@" ;;
  *) echo "Unsupported Build: $build_type" ;;
  esac
}

# Lint
lint_sdk() {
  # Lint Podspecs
  lint_cocoapods() {
    pod_lint_failures=()

    for spec in "${SDK_LINT_POD_SPECS[@]}"; do
      if [ ! -f "$spec" ]; then
        echo "*** ERROR: unable to lint $spec"
        continue
      fi

      local dependent_spec

      set +e

      if [ "$spec" != FBSDKCoreKit.podspec ]; then
        dependent_spec="--include-podspecs=FBSDKCoreKit.podspec"
      fi

      echo ""
      echo "Running lib lint command:"
      echo "pod lib lint" "$spec" $dependent_spec "$@"

      # We should not statically lint the FBSDKCoreKit podspec because it does not pass
      # consistently in Travis
      local should_lint_spec=true
      for arg in "$@"; do
          if [[ $arg == "--use-libraries" ]] && [ "$spec" == FBSDKCoreKit.podspec ]; then
            should_lint_spec=false
          fi
      done

      if [ $should_lint_spec == true ]; then
        if ! pod lib lint "$spec" $dependent_spec "$@"; then
          pod_lint_failures+=("$spec")
        fi
      else
        echo "Skipping linting for $spec with arguments: $*"
      fi

      set -e
    done

    if [ ${#pod_lint_failures[@]} -ne 0 ]; then
      echo "Failed lint for: ${pod_lint_failures[*]} with arguments: $*"
      exit 1
    fi
  }

  lint_swift() {
    if command -v swiftlint >/dev/null; then
      swiftlint
    else
      echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
    fi
  }

  local lint_type=${1:-}
  if [ -n "$lint_type" ]; then shift; fi

  case "$lint_type" in
  "cocoapods") lint_cocoapods --allow-warnings "$@";;
  "swift") lint_swift "$@" ;;
  *) echo "Unsupported Lint: $lint_type" ;;
  esac
}

# Release
# Builds and stores various build flavors under build/Release
# where they can be found and uploaded by a travis job
release_sdk() {
  # Release github
  release_github() {
    mkdir -p build/Release
    rm -rf build/Release/*

    # Warning: This function will move the Swift schemes and not clean up after itself.
    # This is intended to be run in CI on container jobs so this is not an issue.
    # If running locally you will need to clean the directory after running.
    include_swift_schemes() {
      for kit in "${SDK_KITS[@]}"; do
        rm "$kit/$kit".xcodeproj/xcshareddata/xcschemes/* || continue
      done

      for kit in "${SDK_BASE_KITS[@]}"; do
        mv "$kit/$kit/Swift/"*.xcscheme "$kit/$kit.xcodeproj/xcshareddata/xcschemes/"
      done
    }

    release_swift_dynamic() {
      carthage build --no-skip-current
      carthage archive --output build/Release/
      # This is a little unintuitive. Carthage outputs are based on module name instead of
      # target/scheme name. So FBSDKCoreKit.framework.zip IS actually the Swift enabled kits.
      mv build/Release/FBSDKCoreKit.framework.zip build/Release/SwiftDynamic.zip
    }

    release_swift_static() {
      mkdir -p Temp

      for kit in "${SDK_BASE_KITS[@]}"; do
        xcodebuild build \
        -workspace FacebookSDK.xcworkspace \
        -scheme "$kit"Swift \
        -configuration Release \
        -derivedDataPath Temp

        mv Temp/Build/Products/Release-iphoneos/"$kit".framework build/Release

        cd build/Release || exit
        zip -r -m "$kit"-Swift.zip "$kit".framework
        cd ..

        cd ..
      done

      rm -rf Temp
    }

    # Release frameworks in dynamic (mostly for Carthage)
    release_dynamic() {
      carthage build --no-skip-current
      carthage archive --output build/Release/
      mv build/Release/FBSDKCoreKit.framework.zip build/Release/FacebookSDK_Dynamic.framework.zip
    }

    # Release frameworks in static
    release_static() {
      release_basics() {
        xcodebuild build \
         -workspace FacebookSDK.xcworkspace \
         -scheme BuildCoreKitBasics \
         -configuration Release

        kit="FBSDKCoreKit_Basics"
        cd build || exit

        mkdir -p Release/"$kit"/iOS
        mv FBSDKCoreKit.framework Release/"$kit"/iOS
        mkdir -p Release/"$kit"/tvOS
        mv tv/FBSDKCoreKit.framework Release/"$kit"/tvOS
        cd Release || exit
        zip -r -m "$kit".zip "$kit"
        cd ..

        cd ..
      }

      xcodebuild build \
       -workspace FacebookSDK.xcworkspace \
       -scheme BuildAllKits \
       -configuration Release

      xcodebuild build \
       -workspace FacebookSDK.xcworkspace \
       -scheme BuildAllKits_TV \
       -configuration Release

      cd build || exit
      zip -r FacebookSDK_static.zip ./*.framework ./*/*.framework
      mv FacebookSDK_Static.zip Release/
      for kit in "${SDK_KITS[@]}"; do
        if [ ! -d "$kit".framework ] \
          && [ ! -d tv/"$kit".framework ]; then
          continue
        fi

        mkdir -p Release/"$kit"
        if [ -d "$kit".framework ]; then
          mkdir -p Release/"$kit"/iOS
          mv "$kit".framework Release/"$kit"/iOS
        fi
        if [ -d tv/"$kit".framework ]; then
          mkdir -p Release/"$kit"/tvOS
          mv tv/"$kit".framework Release/"$kit"/tvOS
        fi
        cd Release || exit
        zip -r -m "$kit".zip "$kit"
        cd ..
      done
      cd ..

      release_basics
    }

    # TODO: Remove conditional when we drop support for Xcode 10.2
    if [ "${1:-}" == "swift" ]; then
      include_swift_schemes
      release_swift_dynamic
      release_swift_static
    else
      release_dynamic
      release_static
    fi
  }

  # Release Cocoapods
  release_cocoapods() {
    for spec in "${SDK_POD_SPECS[@]}"; do
      if [ ! -f "$spec" ]; then
        echo "*** ERROR: unable to release $spec"
        continue
      fi

      set +e

      pod trunk push --allow-warnings "$spec" "$@"

      set -e
    done
  }

  release_docs() {
    for kit in "${SDK_KITS[@]}"; do
      ruby "$SDK_SCRIPTS_DIR"/genDocs.rb "$kit"

      # Zip the result so it can be uploaded easily
      pushd docs/ || continue
      zip -r "$kit".zip "$kit"
      if [[ $SDK_INTERNAL == 1 ]] && [ "${1:-}" == "--publish" ]; then
        api_update_reference_doc "$kit"
      fi
      popd || continue
    done
  }

  # Generate External Docs Changelog
  release_external_changelog() {
    echo "Releasing Changelog"

    local current_version_underscore=${SDK_CURRENT_VERSION//./_}
    local current_date
    current_date=$(date +%Y-%m-%d)
    local external_changelog="## $SDK_CURRENT_VERSION - $current_date {#$current_version_underscore}"
    local start_logging=0
    local tfile
    tfile=$(mktemp)

    while IFS= read -r line; do
      case "$line" in
      "## $SDK_CURRENT_VERSION")
        start_logging=1
        ;;
      "## "*)
        if [[ $start_logging == 1 ]]; then
          start_logging=0
        fi
        ;;
      *)
        if [[ $start_logging == 1 ]]; then
          external_changelog=$external_changelog"\n"$line
        fi
        ;;
      esac
    done <"CHANGELOG.md"

    echo "$external_changelog" >"$tfile"
    api_update_guide_doc "$tfile"
  }

  local release_type=${1:-}
  if [ -n "$release_type" ]; then shift; fi

  case "$release_type" in
  "github") release_github "$@" ;;
  "cocoapods") release_cocoapods "$@" ;;
  "docs" | "documentation") release_docs "$@" ;;
  "changelog") release_external_changelog "$@" ;;
  *) echo "Unsupported Release: $release_type" ;;
  esac
}

# Check Release Status
check_release_status() {
  local version_to_check=${1:-}
  local release_success=0

  if ! is_valid_semver "$version_to_check"; then
    echo "$version_to_check isn't a valid semantic versioning"
    ((release_success += 1))
  fi

  if ! does_version_exist "$version_to_check"; then
    echo "$version_to_check isn't tagged in GitHub"
    ((release_success += 1))
  fi

  local pod_info

  for spec in "${SDK_POD_SPECS[@]}"; do
    if [ ! -f "$spec" ]; then
      echo "*** ERROR: unable to release $spec"
      continue
    fi

    pod_info=$(pod trunk info "${spec/.podspec/}")

    if [[ $pod_info != *"$version_to_check"* ]]; then
      echo "$spec hasn't been released yet"
      ((release_success += 1))
    fi
  done

  case $release_success in
  0) return ;;
  *) false ;;
  esac
}

# Proper Semantic Version
is_valid_semver() {
  if ! [[ ${1:-} =~ ^([0-9]{1}|[1-9][0-9]+)\.([0-9]{1}|[1-9][0-9]+)\.([0-9]{1}|[1-9][0-9]+)($|[-+][0-9A-Za-z+.-]+$) ]]; then
    false
    return
  fi
}

# Check Version Tag Exists
does_version_exist() {
  local version_to_check=${1:-}

  if [ "$version_to_check" == "" ]; then
    version_to_check=$SDK_CURRENT_VERSION
  fi

  if [ ! -d "$SDK_DIR"/.git ]; then
    echo "Not a Git Repository"
    return
  fi

  if git rev-parse "v$version_to_check" >/dev/null 2>&1; then
    return
  fi

  if git rev-parse "sdk-version-$version_to_check" >/dev/null 2>&1; then
    return
  fi

  false
}

verify_spm_headers() {
  # Verifies that all public headers exist as symlinks in the 'include' dir
  # of the SDK they belong to.
  verify_inclusion() {
    for kit in "${SDK_BASE_KITS[@]}"; do
      cd "$kit/$kit"

      echo "Verifying the following public headers are exposed to SPM for $kit:"

      headers=$(find . -name "*.h" -type f -not -path "./include/*" -not -path "**/Internal/*" -not -path "**/Basics/*")
      echo "$(basename ${headers} )" | sort >| headers.txt

      cat headers.txt

      symlinks=$(find ./include -name "*.h")
      echo "$(basename ${symlinks} )" | sort >| symlinks.txt

      comm -23 headers.txt symlinks.txt >| missingHeaders.txt

      if [ -s missingHeaders.txt ] ; then
        echo ""
        echo "Verification failed:"
        echo "Please symlink the following public headers to the 'include' directory in $kit"
        echo "so that they can be found by projects using Swift Package Manager."
        cat missingHeaders.txt

        rm headers.txt
        rm symlinks.txt
        rm missingHeaders.txt

        exit 1;
      fi
      rm headers.txt
      rm symlinks.txt
      rm missingHeaders.txt

      echo ""
      cd .. || exit
      cd .. || exit
    done

    echo "Success! All of your public headers are visible to users of SPM!"
  }

  # Verifies that existing symlinks are valid since it is easy to break them by moving the
  # original file
  verify_validity() {
    echo ""
    echo "Verifying that the symlinks used for exposing public headers to SPM are pointing to valid source files."

    for kit in "${SDK_BASE_KITS[@]}"; do
      cd "$kit"

      find . -type l ! -exec test -e {} \; -print >| ../BadSymlinks.txt
      cd .. || exit
    done

    if [ -s BadSymlinks.txt ] ; then
      echo ""
      echo "Bad symlinks found: "
      cat BadSymlinks.txt
      echo "Please fix these by recreating the symlink(s) from the include directory with: "
      echo "ln -s <path_to_source_file(s)> ."
      echo "run ./scripts/run.sh verify-spm-headers to verify that these are fixed."

      rm BadSymlinks.txt

      exit 1;
    fi

    rm BadSymlinks.txt

    echo "Success! All of the public header symlinks are valid!"
  }

  verify_inclusion
  verify_validity
}

# --------------
# Main Script
# --------------

main "$@"
