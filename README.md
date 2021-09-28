# clean_old_kernels
Dead simple script to remove (apt remove --purge) "unused" kernels in Pop_OS!

Usage: /bin/bash clean_kernels.sh

# What does it do?
0. Gets current kernel (uname -r)
1. Searches for kernels installed in /boot
2. Searches for symlink named vmlinuz* in /boot
3. apt remove --purge kernels that are not current or symlinks*

Then it asks user for permission to purge the "unused" kernels from the system with apt.

* (Unless PURGE is set to 1. Then only current kernel is kept)

# This is dumb
Yes. It's a dumb task I find myself googling once too often. So I created this script instead :)

# Note
clean_kernels.sh is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

