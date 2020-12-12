#!/bin/bash

#Si no es passa el fitxer per marametre aturem el procés
if [ -z $1 ];then
	echo Has de pasar un fitxer
	exit 1
fi

#Agafem totes les IPs que han fallat un intent de SSH
content=`cat $1 | grep Failed | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sort`

#Declarem una array asociativa
declare -A ipList

#Aquesta funció guarda el nombre de vegades que es troba una IP en una Key de la array.
saveIp(){
	for i in $content;do
		if [ -z "${ipList[$i]}" ];then
			ipList[$i]=1
		else
			ipList[$i]+=1
		fi
	done
}

#Printem els continguts en funció dels valors de la array.
showContent(){
	echo "--------------------------------"
	echo "Count	Ip		Contry"
	echo "--------------------------------"
	for i in "${!ipList[@]}";do
		att=`echo "${ipList[$i]}" | wc -m`
		geo=`geoiplookup $i | awk '{print $NF}'`
		echo "$att	$i	$geo"
		echo "--------------------------------"
	done
}

saveIp
showContent


