#!/bin/bash

export SSH_AUTH_SOCK=/run/user/1000/ssh-agent.socket

backup_dir=./s/sync.old
sync_dir=./s/sync
source_dir=~/sync

get_date() {
date +_%Y%m%d_%H%M
}



rclone sync $source_dir thinkcentre:$sync_dir --backup-dir thinkcentre:$backup_dir --suffix "$(get_date)" --suffix-keep-extension --syslog --metadata --config ~/.config/rclone/rclone.conf -v
rclone sync $source_dir orangepi3-lts:$sync_dir --backup-dir orangepi3-lts:$backup_dir --suffix "$(get_date)" --suffix-keep-extension --syslog --metadata --config ~/.config/rclone/rclone.conf -v
