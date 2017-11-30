#!/bin/sh

#                 $1      $2      $3   $4    $5       $6
# ./vposwifi.sh update interface ssid key psk2-mixed false
# ./vposwifi.sh update wlan0 csmrouter gbc@vng psk2-mixed false

CMD="$1"
IFACE="$2"
WPA_CLI=/sbin/wpa_cli
DHCLIENT=/sbin/dhclient

case "$CMD" in
	"status") echo "Get wifi status" 
	$WPA_CLI -i $IFACE status
	;;
	"update") echo "Update wifi config" 

	$WPA_CLI -i $IFACE disconnect
	$WPA_CLI -i $IFACE remove_network all
	$WPA_CLI -i $IFACE add_network
	$WPA_CLI -i $IFACE set_network 0 ssid \"$3\"
if [ -z "$4" ]; then
	$WPA_CLI -i $IFACE set_network 0 proto RSN
	$WPA_CLI -i $IFACE set_network 0 key_mgmt NONE
else
	$WPA_CLI -i $IFACE set_network 0 psk \"$4\"
	$WPA_CLI -i $IFACE set_network 0 scan_ssid 1
fi
	$WPA_CLI -i $IFACE enable_network 0
	$WPA_CLI -i $IFACE reassociate

	$DHCLIENT $IFACE
	$WPA_CLI -i $IFACE status
	$WPA_CLI -i $IFACE save_config
	;;
esac

