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
#       - Document: getFrequency.sh
#       - Author: aleen42
#       - Description: a shell script for catching useful frequency
#       - Create Time: May, 6th, 2016
#       - Update Time: May, 6th, 2016
#
###########################################################################

# clear file content first
echo "" > "./frequency.dat"

# fork a process to kill grgsm live monitor
frequency=936000000

while [[ "$frequency" -lt 960000000 ]]; do
	{
		pid=`ps -A | grep grgsm_livemon | sed -n "1, 1p" | awk '{print int($1)}'`
		while [[ "$pid" == "" ]]; do
			#statements
			pid=`ps -A | grep grgsm_livemon | sed -n "1, 1p" | awk '{print int($1)}'`
		done

		sleep 5;

		`kill $pid`
	}&

	#statements
	result=`grgsm_livemon -f $frequency | grep 2b`;

	if [[ "$result" != "" ]]
	then
		echo "$frequency: true" >> "./frequency.txt"
		echo "$frequency" >> "./frequency.dat"
	fi

	frequency=`expr $frequency + 100000`
	echo $frequency
done
