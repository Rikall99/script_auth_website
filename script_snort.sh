#!/bin/bash

sudo apt update

sudo mkdir /etc/snort

sudo wget https://raw.githubusercontent.com/Rikall99/script_auth_website/main/snort.debian.conf -O snort.debian.conf
sudo mv snort.debian.conf /etc/snort/snort.debian.conf
sudo chmod 600 /etc/snort/snort.debian.conf

sudo DEBIAN_FRONTEND=noninteractive apt install snort -yq

echo 'alert ip any any -> any any (msg:"SQL Injection Attempt"; content:"select"; nocase; classtype:attempted-recon; sid:1000001;)' | sudo tee -a /etc/snort/rules/local.rules
echo 'alert ip any any -> any any (msg:"Possible SQL Injection — UNION keyword detected"; flow:to_server,established; content:"UNION"; nocase; http_uri; sid:1000002;)' | sudo tee -a /etc/snort/rules/local.rules
echo 'alert ip any any -> any any (msg:"SQL Injection Attempt"; content:"1 = 1"; nocase; classtype:attempted-recon; sid:1000003;)' | sudo tee -a /etc/snort/rules/local.rules
echo 'alert ip any any -> any any (msg:"SQL Injection Attempt"; content:"or"; nocase; classtype:attempted-recon; sid:1000004;)' | sudo tee -a /etc/snort/rules/local.rules


sudo service snort start
