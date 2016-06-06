#!/bin/bash
##########################################################################
#
#
#                             +-+ +-+ +-+ +-+ +-+
#                             |#| |#| |#| +-+ |#|
#                             |#| |#| |#|     +-+
#                             +-+ |#| |#|
#                                 +-+ |#|
#                                     |#| +-+
#                                     +-+ |#|
#                                         |#| +-+
#                             +-+     +-+ |#| |#|
#                             |#| +-+ |#| |#| |#|
#                             +-+ +-+ +-+ +-+ +-+
#        ____                           _  _                  _    _
#       /  __\ _____ __   _ __ ___  ___| || |_  _____  _____ | |_ / \
#       | |__ /  _  \\ \ | |\ '_  \/  _  ||  _|/  _  \/  _  \|  _|| |___
#       \__  \| |_| || |_| || | | || |_| || |__| |_| || |_| || |__|  _  |
#       |____/\_____/|_____||_| |_|\_____|\___/\_____/\_____/\___/|_| |_|
#
#       ================================================================
#            Copyright ® 2015-2016 Soundtooth.All Rights Reserved.
#       ================================================================
#
#       - Document: loopScan.sh
#       - Author: aleen42
#       - Description: a shell script for catching useful frequency
#       - Create Time: May, 22nd, 2016
#       - Update Time: May, 22n, 2016
#
###########################################################################

# read frequency data
frequency=();
n=0;while read LINE;do frequency[$n]=$LINE;((n++));done<"frequency.dat"


i=0;
while [[ true ]]; do
    # set timeout processes killer
    {
		pid=`ps -A | grep grgsm_livemon | sed -n "1, 1p" | awk '{print int($1)}'`
		while [[ "$pid" == "" ]]; do
			#statements
			pid=`ps -A | grep grgsm_livemon | sed -n "1, 1p" | awk '{print int($1)}'`
		done

		sleep 40;

		`kill $pid`
	}&

    # open grgsm_livemon
    echo "start to listen ${frequency[i]} Hz";
    `grgsm_livemon -f ${frequency[i]} | grep 2b`;

    # loop i
    i=`expr $i + 1`
    i=`expr $i % ${#frequency[@]}`
done
