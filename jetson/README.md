Clone the repository, and switch to that repositories’ directory.

> $ git clone https://github.com/jetsonhacksnano/bootFromUSB  
> $ cd bootFromUSB

#### Step 1

Prepare a USB drive (preferably USB 3.0+, SSD, HDD) by formatting the disk with the **GPT** partitioning scheme. This will erase the data that is on the drive, be warned. Then create a partition, and set the format type to **Ext4**. In the video, we use the ‘Disks’ application. See the video for a walk through. It is easier if you only plug in one USB drive during this procedure. When finished, the disk should show as /dev/sda1 or similar. **_Note:_** _Make sure that the partition is Ext4, as NTSF will appear to copy correctly but cause issues later on. Typically it is easiest to set the volume label for later use during this process._

```
# Convert Disk to GPT
parted /dev/sda
mklabel GPT
# quit to save
q

# open gparted to create ext4 partition
sudo gparted
# open gnome-disks to mount the partition
sudo gnome-disks

```
#### Step 2

Copy the application area of the micro SD card to the USB drive. The script **copyRootToUSB.sh** copies the contents of the entire system micro SD card to the USB drive. Naturally, the USB drive storage should be larger than the micro SD card. Note: Make sure that the USB drive is mounted before running the script. In order to copyRootToUSB:

```
usage: ./copyRootToUSB.sh [OPTIONS]

  -d | --directory     Directory path to parent of kernel

  -v | --volume_label  Label of Volume to lookup

  -p | --path          Device Path to USB drive (e.g. /dev/sda1)

  -h | --help  This message
```

In the video, we:

> $ ./copyRootToUSB.sh -p /dev/sda1

#### Step 3

Modify the /boot/extlinux/extlinux.conf file on the USB drive. An entry should be added to point to the new rootfs (typically this is /dev/sda1). There is a sample configuration file: sample-extlinux.conf in the repository.

Modify the /boot/extlinux/extlinux.conf file located on the USB drive. This is in a system protected area, so you will need privileges to change the file, ie ‘sudo gedit’. Make a copy of the ‘PRIMARY’ entry and rename it sdcard.

In the PRIMARY entry change the location of the root to point to the USB drive, ie change ‘root=/dev/mmcblk0p1’ which is the address of the SD card. Provided in this repository is a sample configuration file: sample-extlinux.conf as an example.

While using root=/dev/sda1 in the extlinux.conf works, it can be a good idea to use the PARTUUID of the disk to identify the disk location. Because USB devices are not guaranteed to enumerate in the same order every time, it is possible that that /dev/sda1 points to a different device. This may happen if an extra flash drive is plugged into the Jetson along with the USB boot drive, for example.

The UUID of the disk in the GPT partition table is called the PARTUUID. This is a low level descriptor. Note that there is another identifier, referred to as UUID, which is given by the Linux file system. Use the PARTUUID for this application, as UUID has been reported to cause issues at the present time in this use case.

There is a convenience file: partUUID.sh which will determine the PARTUUID of a given device. This is useful in determining the PARTUUID of the USB drive. Note: If the PARTUUID returned is not similar in length to the sample-extlinux.conf example (32a76e0a-9aa7-4744-9954-dfe6f353c6a7), then it is likely that the device is not formatted correctly.

> $ ./partUUID.sh

While this defaults to sda1 (/dev/sda1), you can also determine other drive PARTUUIDs. The /dev/ is assumed, use the -d flag. For example:

> $ ./partUUID.sh -d sdb1

After saving the extlinux.conf file, you are ready to test things out. Shutdown the Jetson, and remove the SD card. Boot the Jetson, and the Jetson will then boot from the USB drive. There will be a slight pause as it looks for which drive to boot from. Make sure that your USB drive is plugged in when you attempt to boot the machine, as this is not hot swappable.

If you encounter issues, you can always boot from the SD card again.

Then you are all set! Enjoy.