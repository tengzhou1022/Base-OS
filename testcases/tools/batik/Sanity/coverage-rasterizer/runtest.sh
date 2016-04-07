#!/bin/bash
# ----------------------------------------------------------------------
# Filename:   runtest.sh
# Version:    1.0
# Date:       2016/03/30
# Author:     tengzhou1022
# Email:      tengzhou1022@gmail.com
# Summary:    tools/batik/Sanity/coverage-rasterizer
# Notes:       ***
# History：
#             Version 1.0, 2016/03/30
# ----------------------------------------------------------------------

# include lib files
if [ -z "$SFROOT" ]
then
    echo "SFROOT is null, pls check"
    exit 1
fi

. ${SFROOT}/lib/Echo.sh
. ${SFROOT}/lib/RunCmd.sh
. ${SFROOT}/lib/Check.sh

function CleanData()
{
  RunCmd "popd"
  RunCmd "rm -r $TmpDir" 0 "Removing tmp directory"
  EchoInfo "=== test tools/batik/Sanity/coverage-rasterizer finish==="
}
trap "CleanData" EXIT INT

function do_setup()
{
  ##install PACKAGE libbatik-java
  sudo apt-get -y install $PACKAGE

  test -z $PNG_ENABLED && PNG_ENABLED="$DEFAULT_PNG_ENABLED"
  test -z $DJPG_ENABLED && JPG_ENABLED="$DEFAULT_JPG_ENABLED"
  test -z $TIF_ENABLED && TIF_ENABLED="$DEFAULT_TIF_ENABLED"
  test -z $PDF_ENABLED && PDF_ENABLED="$DEFAULT_PDF_ENABLED"

  RunCmd "TmpDir=\`mktemp -d\`" 0 "Creating tmp directory"
  RunCmd "cp dummy.svg $TmpDir"
  RunCmd "pushd $TmpDir"
  RunCmd "mkdir output"

}
function check_size()
{
  local file_size=`du -b $1 | awk '{ print $1 }'`
  local min_size=$2
  if [ -z "$min_size" ]; then
    min_size=$MIN_SIZE
  fi
  EchoInfo "The size of $1 = $file_size"
  CheckGreater "It should be greater than $min_size B" "$file_size" "$min_size"
}

PACKAGE="libbatik-java"
MIN_SIZE="2000"

DEFAULT_PNG_ENABLED="yes"
DEFAULT_JPG_ENABLED="yes"
DEFAULT_TIF_ENABLED="yes"
DEFAULT_PDF_ENABLED="no"

do_setup
if [[ "$PNG_ENABLED" == "yes" ]]; then
  EchoInfo "Testing PNG conversion"
  EchoInfo "==== Testing simple conversion ===="
  RunCmd "rasterizer -d output/png_-_dummy-no-background.png -m image/png dummy.svg"
  CheckExists "output/png_-_dummy-no-background.png"
  check_size "output/png_-_dummy-no-background.png" "10000"

  EchoInfo "==== Testing conversion with modified background ===="
  RunCmd "rasterizer -bg 255.0.0.255 -d output/png_-_dummy-blue-background.png -m image/png dummy.svg"
  CheckExists "output/png_-_dummy-blue-background.png"
  check_size "output/png_-_dummy-blue-background.png" "10000"

  EchoInfo "==== Testing conversion with custom output picture size and dpi (1200x1200, 1200 dpi) ===="
  RunCmd "rasterizer -w 1200 -dpi 1200 -d output/png_-_dummy-1200x1200-1200dpi.png -m image/png dummy.svg"
  CheckExists "output/png_-_dummy-1200x1200-1200dpi.png"
  check_size "output/png_-_dummy-1200x1200-1200dpi.png" "50000"

  EchoInfo "==== Testing conversion with custom output picture size and dpi (300x300, 600dpi) ===="
  RunCmd "rasterizer -w 300 -dpi 600 -d output/png_-_dummy-300x300-600dpi.png -m image/png dummy.svg"
  CheckExists "output/png_-_dummy-300x300-600dpi.png"
  check_size "output/png_-_dummy-300x300-600dpi.png" "10000"

fi
if [[ "$JPG_ENABLED" == "yes" ]]; then
  EchoInfo "Testing JPEG conversion"
  EchoInfo "==== Testing simple conversion ===="
  RunCmd "rasterizer -d output/jpg_-_dummy.jpg -m image/jpeg dummy.svg"
  CheckExists "output/jpg_-_dummy.jpg"
  check_size "output/jpg_-_dummy.jpg" "10000"

  EchoInfo "==== Testing conversion with custom output quality option = 0.1 ===="
  RunCmd "rasterizer -d output/jpg_-_dummy-q-0_1.jpg -q 0.1 -m image/jpeg dummy.svg"
  CheckExists "output/jpg_-_dummy-q-0_1.jpg"
  check_size "output/jpg_-_dummy-q-0_1.jpg" "3000"

  EchoInfo "==== Testing conversion with custom output quality option = 0.5 ===="
  RunCmd "rasterizer -d output/jpg_-_dummy-q-0_5.jpg -q 0.5 -m image/jpeg dummy.svg"
  CheckExists "output/jpg_-_dummy-q-0_5.jpg"
  check_size "output/jpg_-_dummy-q-0_5.jpg" "8000"

  EchoInfo "==== Testing conversion with custom output quality option = 0.99 ===="
  RunCmd "rasterizer -d output/jpg_-_dummy-q-0_99.jpg -q 0.99 -m image/jpeg dummy.svg"
  CheckExists "output/jpg_-_dummy-q-0_99.jpg"
  check_size "output/jpg_-_dummy-q-0_99.jpg" "36000"

  EchoInfo "==== Testing conversion with custom output picture size and dpi (1200x1200, 1200 dpi) ===="
  RunCmd "rasterizer -w 1200 -dpi 1200 -d output/jpg_-_dummy-1200x1200-1200dpi.jpg -m image/jpeg dummy.svg"
  CheckExists "output/jpg_-_dummy-1200x1200-1200dpi.jpg"
  check_size "output/jpg_-_dummy-1200x1200-1200dpi.jpg" "50000"

  EchoInfo "==== Testing conversion with custom output picture size and dpi (300x300, 600dpi) ===="
  RunCmd "rasterizer -w 300 -dpi 600 -d output/jpg_-_dummy-300x300-600dpi.jpg -m image/jpeg dummy.svg"
  CheckExists "output/jpg_-_dummy-300x300-600dpi.jpg"
  check_size "output/jpg_-_dummy-300x300-600dpi.jpg" "8000"

fi
if [[ "$TIF_ENABLED" == "yes" ]]; then
  EchoInfo "Testing TIFF conversion"
  EchoInfo "==== Testing simple conversion ===="
  RunCmd "rasterizer -d output/tif_-_dummy.tif -m image/tiff dummy.svg"
  CheckExists "output/tif_-_dummy.tif"
  check_size "output/tif_-_dummy.tif" "360000"

  EchoInfo "==== Testing conversion with modified background ===="
  RunCmd "rasterizer -bg 255.0.0.255 -d output/tif_-_dummy-blue-background.tif -m image/tiff dummy.svg"
  CheckExists "output/tif_-_dummy-blue-background.tif"
  check_size "output/tif_-_dummy-blue-background.tif" "360000"

  EchoInfo "==== Testing conversion with custom output picture size and dpi (1200x1200, 1200 dpi) ===="
  RunCmd "rasterizer -d output/tif_-_dummy-1200x1200-120dpi.tif -w 1200 -dpi 1200 -m image/tiff dummy.svg"
  CheckExists "output/tif_-_dummy-1200x1200-120dpi.tif"
  check_size "output/tif_-_dummy-1200x1200-120dpi.tif" "5000000"

  EchoInfo "==== Testing conversion with custom output picture size and dpi (300x300, 600 dpi) ===="
  RunCmd "rasterizer -d output/tif_-_dummy-300x300-600dpi.tif -w 300 -dpi 600 -m image/tiff dummy.svg"
  CheckExists "output/tif_-_dummy-300x300-600dpi.tif"
  check_size "output/tif_-_dummy-300x300-600dpi.tif" "250000"
fi

if [[ "$PDF_ENABLED" == "yes" ]]; then
  EchoInfo "Testing PDF conversion"
  EchoInfo "==== Testing simple conversion ===="
  RunCmd "rasterizer -d output/pdf_-_dummy.pdf -m application/pdf dummy.svg"
  CheckExists "output/pdf_-_dummy.pdf"
  check_size "output/pdf_-_dummy.pdf"
fi
