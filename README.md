# clean_old_kernels
Dead simple script to remove (apt remove --purge) "unused" kernels in Pop_OS!

Usage: /bin/bash clean_kernels.sh

# What does it do?
Searches for kernels installed in /boot and mark for deletion; searches for symlinks named vmlinuz in /boot (that are typically current or .old kernel) and these are reserved (unless PURGE is set to 1). Then it asks user for permission to purge the "unused" kernels from the system with apt.

# Note
clean_kernels.sh is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

