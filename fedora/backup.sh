#!/bin/bash

mkdir /etc/backups/
mkdir /etc/backups/dovecot
mkdir /etc/backups/dovecot/conf.d

cp -rap /etc/dovecot/* /etc/backups/dovecot
cp -rap /etc/dovecot/conf.d/* /etc/backups/dovecot/conf.d


mkdir /etc/backups/postfix
cp -rap /etc/postfix/* /etc/backups/postfix

mkdir /etc/backups/etc
cp -rap /etc/* /etc/backups/
