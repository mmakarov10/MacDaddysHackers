#!/bin/bash

sudo yum install ufw

sudo ufw --force reset

sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

sudo ufw default deny incoming

sudo ufw allow out 80/tcp
sudo ufw allow out 443/tcp
sudo ufw allow out 53/tcp
sudo ufw allow out 9997/tcp

sudo ufw default deny outgoing

sudo ufw --force enable

sudo ufw status verbose
