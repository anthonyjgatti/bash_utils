#!/bin/bash


v1=( "a" "b" "c" )
v2=( "d" "e" )

if [ "`echo $v1 | xargs -n1 echo | grep -q $1`" ]; then
	echo "FOUND"
else
	echo "NO LUCK"
fi


#if [ -n "`echo $LIST | xargs -n1 echo | grep -e \"^$VALUE`$\"`" ]; then
#    echo "OH SHIT"
#fi

