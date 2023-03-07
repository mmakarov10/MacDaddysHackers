#!/bin/bash
echo "# Require the root pw when booting into single user mode" >> /etc/inittab
echo "~~:S:wait:/sbin/sulogin" >> /etc/inittab
echo "Don't allow any nut to kill the server"
perl -npe 's/ca::ctrlaltdel:\/sbin\/shutdown/#ca::ctrlaltdel:\/sbin\/shutdown/' -i /etc/inittab