#!/system/bin/sh

moddir="/data/adb/modules/external_webui"
if [ -n "$(magisk -v | grep lite)" ]; then
  moddir=/data/adb/lite_modules/external_webui
fi

scripts_dir="/data/adb/webui"
busybox_path="/data/adb/magisk/busybox"
webui_run_path="/data/adb/webui/run"
webui_pid_file="${webui_run_path}/webui.pid"

start_service() {
    ${scripts_dir}/webui.service -s
}

start_webui() {
if [ -f ${webui_pid_file} ] ; then
    ${scripts_dir}/webui.service -k
fi
}

start_run() {
if [ ! -f /data/adb/webui/manual ] ; then
    if [ ! -f ${moddir}/disable ] ; then
        start_service
    fi
    if [ "$?" = 0 ] ; then
       inotifyd ${scripts_dir}/webui.inotify ${moddir} > /dev/null 2>&1 &
    fi
fi
}

start_webui
start_run