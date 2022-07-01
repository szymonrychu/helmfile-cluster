[openvpn_server]
OPENVPN_SERVER_IP    ansible_connection=ssh  ansible_user=vpn

[openvpn_clients]
192.168.1.20    ansible_connection=ssh  ansible_user=nas