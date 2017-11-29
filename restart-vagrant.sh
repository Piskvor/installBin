#!/bin/bash

cleanup() {
	set +x
	echo "Interrupted" 1>&2
	exit
}
trap cleanup SIGINT
BB_ID=$(get-bb-id)
if [ "$BB_ID" = "" ]; then
	echo "No blackbox vagrant ID!" 1>&2
	exit 1
fi

set -x
vagrant ssh "$BB_ID" -- "docker restart blackbox_varnish_1; sleep 1; docker restart reverse-proxy; sleep 1; docker restart blackbox_ssl-offloading_1; sleep 1; docker restart reverse-proxy; docker restart blackbox_i0_1; docker restart blackbox_frontend_1 ; docker exec -i blackbox_frontend_1 bash -c \"cd /packages/blackbox; /usr/bin/php ./tools/generate-config/generate.php ./administration/conf/admin.yml ./administration/conf/admin.yml.php\"; docker exec -i blackbox_i0_1 bash -c \"sed -i 's/sendfile\(\s*\)on;/sendfile\1off;/' /etc/nginx/nginx.conf && hostname && /etc/init.d/nginx reload\"; docker exec -i reverse-proxy bash -c \"sed -i 's/sendfile\(\s*\)on;/sendfile\1off;/' /etc/nginx/nginx.conf && hostname && /etc/init.d/nginx reload\"; " || get-bb-id --reset || (echo "Retry!" && exit 3)

