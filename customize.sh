#!/system/bin/sh

# Declaring a variable to skip the default installation steps
SKIPUNZIP=1

install_module() {
    ui_print "Installing..."
    sleep 1

    ui_print "- Extracting module files"
    mkdir -p /data/adb/webui
    mkdir -p /data/adb/webui/run
 
    if [ ! -d /data/adb/service.d ] ; then
        mkdir -p /data/adb/service.d
    fi

    unzip -o "${ZIPFILE}" -x 'META-INF/*' -d $MODPATH >&2
    unzip -j -o "${ZIPFILE}" 'webui_service.sh' -d /data/adb/service.d >&2
    unzip -j -o "${ZIPFILE}" 'scripts/*' -d /data/adb/webui >&2
    unzip -j -o "${ZIPFILE}" 'module.prop' -d $MODPATH >&2
    unzip -j -o "${ZIPFILE}" 'service.sh' -d $MODPATH >&2
    unzip -j -o "${ZIPFILE}" 'uninstall.sh' -d $MODPATH >&2
    unzip -o ${MODPATH}/webui.zip -d /data/adb/box/ >&2

    rm -rf ${MODPATH}/webui.zip
    rm -rf ${MODPATH}/scripts
    rm -rf ${MODPATH}/webui_service.sh

    sleep 1
    ui_print "- Settings module"    
    ui_print "- Settings permission"
    set_perm_recursive $MODPATH 0 0 0755 0644
    set_perm_recursive /data/adb/webui 0 0 0755 0644
    set_perm /data/adb/service.d/webui_service.sh 0 0 0755
    chmod ugo+x /data/adb/webui/*
}

if [ $API -lt 21 ]; then
    ui_print " Requires API 21+ (Android 5.0+) to install this module! "
    abort "*********************************************************"
elif [ $MAGISK_VER_CODE -lt 23000 ]; then
    ui_print " Please install Magisk v23.0+! "
    abort "*******************************"
elif ! $BOOTMODE; then
    ui_print " Install this module in Magisk! "
    abort "********************************"
elif [ ! -f /data/data/com.termux/files/usr/bin/php ]; then
    ui_print " Install PHP"
    ui_print " Open Termux"
    ui_print " pkg install php"
    abort "********************************"
elif [ ! -d /data/adb/box ]; then
    ui_print " tidak ada folder /data/adb/box"
    abort "********************************"
else
    set -x
    sleep 3
    install_module
fi