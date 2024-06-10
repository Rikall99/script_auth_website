#!/bin/bash

sudo apt update

sudo mkdir /etc/snort

wget https://raw.githubusercontent.com/Rikall99/script_auth_website/main/snort.debian.confing -O snort.debian.conf
sudo mv snort.debian.conf /etc/snort/snort.debian.conf
sudo chmod 600 /etc/snort/snort.debian.conf

sudo apt install snort -y

echo 'alert ip any any -> any any (msg:"SQL Injection Attempt"; content:"select"; nocase; classtype:attempted-recon; sid:1000001;)' | sudo tee -a /etc/snort/rules/local.rules
echo 'alert ip any any -> any any (msg:”Possible SQL Injection — Inline Comments Detected”; flow:to_server,established; content:”GET”; nocase; http_method; content:”/”; http_uri; pcre:”/?.( — |#|/*)/”; sid:1000002;)' | sudo tee -a /etc/snort/rules/local.rules
echo 'alert ip any any -> any any (msg:”Possible SQL Injection — UNION keyword detected”; flow:to_server,established; content:”UNION”; nocase; http_uri; sid:1000003;)' | sudo tee -a /etc/snort/rules/local.rules

sudo service snort start
