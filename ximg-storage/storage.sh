#!/bin/sh
sed -i "s#\(port\).*#\1=$STORAGE_PORT#" /etc/fdfs/storage.conf
sed -i "s#\(group_name\).*#\1=$GROUP_NAME#" /etc/fdfs/storage.conf
sed -i "s#\(base_path\).*#\1=$STORAGE_BASE_PATH#" /etc/fdfs/storage.conf
sed -i "s#\(store_path0\).*#\1=$STORAGE_BASE_PATH#" /etc/fdfs/storage.conf
sed -i "s#\(tracker_server\).*#\1=$TRACKER_SERVER#" /etc/fdfs/storage.conf
sed -i "s#\(http.server_port\).*#\1=$HTTP_SERVER_PORT#" /etc/fdfs/storage.conf

sed -i "s#\(base_path\).*#\1=$STORAGE_BASE_PATH#" /etc/fdfs/mod_fastdfs.conf
sed -i "s#\(store_path0\).*#\1=$STORAGE_BASE_PATH#" /etc/fdfs/mod_fastdfs.conf
sed -i "s#\(storage_server_port\).*#\1=$STORAGE_PORT#" /etc/fdfs/mod_fastdfs.conf
sed -i "s#\(tracker_server\).*#\1=$TRACKER_SERVER#" /etc/fdfs/mod_fastdfs.conf
sed -i "s#\(group_name\).*#\1=$GROUP_NAME#" /etc/fdfs/mod_fastdfs.conf
sed -i "s#\(http.server_port\).*#\1=$HTTP_SERVER_PORT#" /etc/fdfs/mod_fastdfs.conf

cd /etc/fdfs
touch mime.types
$NGX_DIR/sbin/nginx -t
$NGX_DIR/sbin/nginx

/usr/bin/fdfs_storaged /etc/fdfs/storage.conf restart
tail -f $STORAGE_BASE_PATH/logs/storaged.log