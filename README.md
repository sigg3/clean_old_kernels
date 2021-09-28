# clean_old_kernels
Dead simple script to remove (apt remove --purge) "unused" kernels in Pop_OS!

Usage: /bin/bash clean_kernels.sh

# What does it do?
0. Gets current kernel (uname -r)
1. Searches for kernels installed in /boot
2. Searches for symlinks named vmlinuz* in /boot
3. apt remove --purge kernels that are not current or symlinks* (* unless PURGE set to 1. Then only current is reserved.)

Then it asks user for permission to purge the "unused" kernels from the system with apt.

Pop_OS symlinks current (vmlinuz) and previous kernel (vmlinuz.old).

User can create symlink of kernels they want to keep, e.g. ``sudo ln -s /boot/vmlinuz-5.13.0-7614-generic /boot/vmlinuz.keep``.

# Exit codes
0 ) Success

1 ) Too few or can't determine number of kernels 

2 ) All installed kernels are reserved

3 ) User aborted


# This is dumb
Yes. It's a dumb task I find myself googling once too often. So I created this script instead :)

# TODOs
* Allow CLI args to control it. Args are: use_sudo, remove_all, no_prompts
* quiet mode (no prompts, just goes aheads and deletes)

# Note
clean_kernels.sh is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

