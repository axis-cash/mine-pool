#!/bin/sh
echo "Prepare...">/tmp/ember.log
num=`ps -aux|grep ember|wc -l`
echo "Num:$num">>/tmp/ember.log
if [ $num -le 5 ]; then
	echo "Starting" >>/tmp/ember.log
	cd /root/gopath/src/github.com/axis-cash/mine-pool/www-zh/
	ember server --port 8082 --environment production &
fi
