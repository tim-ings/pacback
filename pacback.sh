DATE=$1

# ensure running as root
[[ ! ${EUID:-$(id -u)} -eq 0 ]] && echo "Please run as root" && exit 1

# ensure the date is valid
[[ ! $DATE =~ ^202[0-9]\/(12|11|10|0[1-9])\/(31|30|10|[0-2][1-9])$ ]] && echo "Please specify date as YYYY/MM/DD" && exit 1

# back up mirrorlist first
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

# point mirrorlist to the archive specifying date to rollback to e.g. to return to 5th April:
echo "Server=https://archive.archlinux.org/repos/$DATE/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

# do a full system upgrade (double 'y' refreshes your package database, double 'u' allows pacman to downgrade packages)
pacman -Syyuu

cat /etc/pacman.d/mirrorlist

# revert mirror list to current mirros
cp /etc/pacman.d/mirrorlist.bak /etc/pacman.d/mirrorlist
