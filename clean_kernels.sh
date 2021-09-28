#!/bin/bash
# Usage: /bin/bash clean_kernels.sh
# Written by Sigge Smelror (C) 2021, GNU GPL v. 3+
#
# clean_kernels.sh is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, version 3 or newer.
#
# clean_kernels.sh is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# URL: <https://www.gnu.org/licenses/gpl-3.0.txt>
#
# Submit bugs at: <https://github.com/sigg3/clean_old_kernels/issues>



# Will ask for sudo while running (default 1)
USE_SUDO="1"

# Set to 1 to erase all but current kernel (default 0)
PURGE="0"

USAGE="This program searches for and removes \"unused\" kernels in Pop_OS"


echo "$USAGE"

if ! uname >> /dev/null ; then
  echo "ERR: Can't run uname..?" ; exit 1
fi

KERNELS=$(  find /boot/ -maxdepth 1 -type f -name 'vmlinuz-*' | sed "s|/boot/vmlinuz-|linux-image-|g" )
SYMLINKS=$( find /boot/ -maxdepth 1 -type l -name 'vmlinuz*'  )
NUM_KERNELS=$(  echo "$KERNELS"  | wc -l )
NUM_SYMLINKS=$( echo "$SYMLINKS" | wc -l )
CURRENT=$( uname -r | sed "s|^|linux-image-|" )

# Do we have enough kernels to bother?
NUM_OK="0"
case "$NUM_KERNELS" in
1 ) echo "ERR: Nothing to do, just 1 kernel installed." ;;
2 ) if [ "$PURGE" -ne "1" ] ; then
      echo "ERR: Nothing to do, not enough kernels installed (2)"
    else
      NUM_OK="1"
    fi
    ;;
0 ) echo "ERR: Can't determine number of kernels installed." ;;
* ) NUM_OK="1" ;;
esac
if [ "$NUM_OK" -eq "0" ] ; then exit 1 ; fi


# List kernels found
echo -e "Found $NUM_KERNELS Linux kernels:"
echo "$KERNELS" | sed -e "s|^|+ |g"

# Check whether we have symlinks
if [ "$NUM_SYMLINKS" -gt "0" ] ; then
  # List symlinks found (these are not to be removed)
  # These are "current" and "old" typically
  LINK_TARGETS=$( file $(echo "$SYMLINKS") | awk '{print $NF}' | sed "s|vmlinuz-|linux-image-|g" )
  echo -e "\nFound $NUM_SYMLINKS kernel symlinks (typically .current and .old):"
  if [ "$PURGE" -eq "0" ] ; then
    echo "$LINK_TARGETS" | sed -e "s|^|- |g" -e "s|$| (will not be removed)|g"
  else
    echo "$LINK_TARGETS" | sed -e "s|^|* |g" -e "s|$| (will delete PURGE=1)|g"
  fi
fi

if [ "$NUM_SYMLINKS" -eq "$NUM_KERNELS" ] ; then
  echo -e "\nERR: Installed kernels are reserved." ; exit 1
else
  echo -e "\n$((NUM_KERNELS - NUM_SYMLINKS)) kernel(s) marked for removal"
fi

read -t 60 -sn 1 -p "This will uninstall kernels. Proceed? [y/N] " U_PROMPT
case "$U_PROMPT" in
"y" | "Y" ) true ;;
* ) echo "Aborted." ; exit 2 ;;
esac

if [ "$USE_SUDO" -eq "1" ] ; then
  echo "Checking sudo privs (sudo true)" ; sudo true
fi


# Finally we get to do the stuff
KERN_REM_COUNT="0"
echo "$KERNELS" | while read -r krnl ; do
  if echo "$krnl" | grep -i -q "$CURRENT" ; then
    echo "Skipping $krnl (current kernel)"
    continue
  fi
  if [ "$PURGE" -eq "0" ] ; then
    if echo "$LINK_TARGETS" | tr "\n" " " | grep -i -q "$krnl" ; then
      echo "Skipping $krnl (reserved)"
      continue
    fi
  fi
  if [ "$USE_SUDO" -eq "1" ] ; then
	sudo apt remove --purge -y "$krnl"
  else
	apt remove --purge -y "$krnl"
  fi
  ((KERN_REM_COUNT++))
  export KERN_REM_COUNT
done

echo "Removed $KERN_REM_COUNT kernels from /boot !" # not sure if count is accurate TODO
echo "Done."
exit 0
