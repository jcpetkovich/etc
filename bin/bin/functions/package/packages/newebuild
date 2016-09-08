#!/usr/bin/env bash

read -r -d '' HELP <<EOF
Usage: new-ebuild.sh [options]

Create a new ebuild either by basing it off a previous ebuild or by
creating a completely new one. User will be prompted for information
necessary to create the ebuild.

    Command options:
    -h    Print this help documentation.
EOF


while getopts ":h" opt; do
    case $opt in
        h ) echo "$HELP";
            exit 0;;
    esac
done
shift $(($OPTIND - 1))

[[ ! -d $PERSONAL_OVERLAY ]] && echo "PERSONAL_OVERLAY not set" && exit 1

# For slightly saner defaults
set -u

# Variables and their defaults
BASE_OFF=
USE_ALL_FILES=y
CATEGORY=sys-apps
PACKAGE=
VERSION=0.0.1

# Construct Ebuild Spec ========================================
read -e -p 'Ebuild to base it off (empty for nothing): ' -i "$BASE_OFF" BASE_OFF

# Find the ebuild if there is one specified
if [[ -z $BASE_OFF ]]; then
    USE_ALL_FILES=
    # Make default structure
    echo "Make default structure"

    read -e -p 'What category is the package in? (e.g. sys-apps): ' -i "$CATEGORY" CATEGORY
    read -e -p 'What is the name of the package?: ' -i "$PACKAGE" PACKAGE

    [[ -z $PACKAGE ]] && echo 'No package name specified! ' && exit 1

    read -e -p 'What is your package version?: ' -i "$VERSION" VERSION
    
else
    
    if [[ -r $BASE_OFF ]]; then
        if ! echo $BASE_OFF | grep -E '\.ebuild$'; then
            echo "File exists, and is not an ebuild."
            exit 1
        fi
        echo "Using $BASE_OFF"
    elif BASE_OFF=$(equery w $BASE_OFF); then
        echo "Using $BASE_OFF"
    else
        echo "Couldn't find the ebuild you're talking about."
        exit 1
    fi

    read -e -p 'Do you want to include the whole set of files (Y/n): ' -i "$USE_ALL_FILES" USE_ALL_FILES

    PACKAGE_DIR=$(dirname $BASE_OFF)
    CATEGORY_DIR=$(dirname $(dirname $BASE_OFF))

    PACKAGE=$(basename $PACKAGE_DIR)
    CATEGORY=$(basename $CATEGORY_DIR)
    
    VERSION=${BASE_OFF%.ebuild}
    VERSION=${VERSION##*-}

    read -e -p 'What is the name of your new package? ' -i "$PACKAGE" PACKAGE
    read -e -p 'What version is your new package? ' -i "$VERSION" VERSION
fi

echo
echo "BASE_OFF: $BASE_OFF"
echo "USE_ALL_FILES: $USE_ALL_FILES"
echo "CATEGORY: $CATEGORY"
echo "PACKAGE: $PACKAGE"
echo "VERSION: $VERSION"
echo

echo "Press [enter] if you are satisfied."
x=
read -r x

# Default Ebuilds ========================================

DEFAULT_EBUILD="$(cat /usr/portage/skel.ebuild)"

# Create Ebuild ========================================

PKG_DIR="${PERSONAL_OVERLAY}/${CATEGORY}/${PACKAGE}"
NEW_EBUILD="${PKG_DIR}/${PACKAGE}-${VERSION}.ebuild"

function create_dir() {
    local dir=$1
    echo "Creating dir $dir"
    mkdir -p $dir || (echo "Couldn't make directory $dir" && exit 1)
}

function default_hierarchy() {
    create_dir $PKG_DIR
    echo "Creating default ebuild at $NEW_EBUILD"
    echo "$DEFAULT_EBUILD" > $NEW_EBUILD
}

function copy_heirarchy() {

    create_dir $PKG_DIR

    echo "Creating new ebuild $NEW_EBUILD"
    cp $BASE_OFF $NEW_EBUILD

    if [[ -n $USE_ALL_FILES ]]; then
        echo "Copying files to new package"
        cp -ur "${PACKAGE_DIR}/files" $PKG_DIR
    fi
}

if [[ -z $BASE_OFF ]]; then
    default_hierarchy;
else
    copy_heirarchy
fi

# Edit Ebuild ========================================

EDIT_NOW=
read -e -p 'Would you like to edit your new ebuild with $EDITOR? (y/n) ' -i "$EDIT_NOW" EDIT_NOW

if echo $EDIT_NOW | grep -i 'n' &> /dev/null; then
    exit 0
fi

$EDITOR $NEW_EBUILD
