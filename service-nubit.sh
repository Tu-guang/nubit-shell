#!/bin/bash

echo -e "\e[1;33m"
echo "    __    __  __   __    _____   _______  _____    _____  __          __ _    _    ____  "
echo "   |  \  /  |\  \ /  /  / ____| |__   __||_   _|  / ____| \ \        / /| |  | |  / __ \ "
echo "   |   \/   | \  V  /  | (___      | |     | |   | |       \ \  /\  / / | |__| | | |  | |"
echo "   | |\  /| |  \   /    \___ \     | |     | |   | |        \ \/  \/ /  |  __  | | |  | |"
echo "   | | \/ | |   | |     ____) |    | |    _| |_  | |____     \  /\  /   | |  | | | |__| |"
echo "   |_|    |_|   |_|    |_____/     |_|   |_____|  \_____|     \/  \/    |_|  |_|  \____/ "
echo -e "\e[0m"
sleep 2;
echo "\e[1;33m🆙 Begin create nubit light node... \e[0m"
while [ $# -gt 0 ]; do
    if [[ $1 = "--"* ]]; then
        v="${1/--/}"
        declare "$v"="$2"
        shift
    fi
    shift
done
NETWORK="nubit-alphatestnet-1"
NODE_TYPE="light"
VALIDATOR_IP="validator.nubit-alphatestnet-1.com"

BINARY="$HOME/nubit-node/bin/nubit"

# create service
sudo tee /etc/systemd/system/nubitlightd.service > /dev/null <<EOF
[Unit]
Description=Nubit Light Client
After=network-online.target

[Service]
User=root
ExecStart=$BINARY $NODE_TYPE start --p2p.network $NETWORK --core.ip $VALIDATOR_IP --metrics.endpoint otel.nubit-alphatestnet-1.com:4318 --rpc.skip-auth
Restart=on-failure
RestartSec=10000
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
echo -e "\e[1;33mStarting service... \e[0m" && sleep 1;
sudo systemctl daemon-reload
sudo systemctl enable nubitlightd
sudo systemctl restart nubitlightd

echo -e "\e[1;33m=============== SETUP FINISHED ===================\e[0m"
echo -e "\e[1;33mView the logs from the running service, use: journalctl -f -u nubitlightd\e[0m"
echo -e "\e[1;33mCheck if the node is running, enter: sudo systemctl status nubitlightd\e[0m"
echo -e "\e[1;33mStop your Nubit light node, use: sudo systemctl stop nubitlightd\e[0m"
echo -e "\e[1;33mStart your Nubit light node, enter: sudo systemctl start nubitlightd\e[0m"
echo -e "\e[1;33mAfter modifying the nubitlightd.service file, reload the service using: sudo systemctl daemon-reload\e[0m"
echo -e "\e[1;33mRestart the service, use: sudo systemctl restart nubitlightd\e[0m"
echo -e "\e[31mPlease download the mnemonic.txt file from the root directory to your computer to back up the seed phrase\e[0m"