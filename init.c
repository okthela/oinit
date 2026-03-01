#include <stdio.h>
#include <sys/mount.h>
#include <errno.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>  
#include <spawn.h>
#include <stdlib.h>

extern char **environ;

void boot_msg(void) {
    printf("STAGE 1: BOOT\n");
}

void mounts(void) {
    pid_t pid;
    printf("Mounting pseudo-filesystems.\n");
    mkdir("/proc", 0555);
    mkdir("/sys", 0555);
    mkdir("/dev", 0755);
    mkdir("/run", 0755);

    mount("proc", "/proc", "proc", 0, NULL);
    printf("Mounted /proc\n");

    mount("sysfs", "/sys", "sysfs", 0, NULL);
    printf("Mounted /sys\n");

    mount("devtmpfs", "/dev", "devtmpfs", 0, NULL);
    printf("Mounted /dev\n");

    mount("tmpfs", "/run", "tmpfs", 0, NULL);
    printf("Mounted /run\n");

    printf("Mount other filesystems\n");
    posix_spawn(&pid, "/sbin/mount", 0, 0, (char*[]){"/sbin/mount", "-a", NULL}, environ);
    printf("Remount / as RW\n");
    mount("/", "/", NULL, MS_REMOUNT, NULL);

}

void udev(void) {
    pid_t pid;
    printf("Start udev\n");
    posix_spawn(&pid, "/sbin/udevd", 0, 0, (char*[]){"/sbin/udevd", "--daemon", NULL}, environ);
    sleep(1);
    printf("Triggering devices\n");
    posix_spawn(&pid, "/sbin/udevadm", 0, 0, (char*[]){"/sbin/udevadm", "trigger", NULL}, environ);
    sleep(1);
    printf("Settling those devices\n");
    posix_spawn(&pid, "/sbin/udevadm", 0, 0, (char*[]){"/sbin/udevadm", "settle", NULL}, environ);
    sleep(1);
    printf("End of udev\n");
}

int main(void) {
    pid_t pid;
    boot_msg();
    mounts();
    udev();
    printf("INIT COMPLETE\nINIT SERVICE MANAGEMENT\n");
    posix_spawn(&pid, "/sbin/oinit-service", 0, 0, (char*[]){"/sbin/oinit-service", NULL}, environ);
    while (1){sleep(1);}
}
