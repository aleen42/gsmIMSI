#!/usr/bin/python
# -*- coding: utf-8 -*-
# Author: aleen42
# 2016/05/06
# License : MIT

import time
import re
from scapy.all import sniff

imsis=[]

def write_log(x):
	file_object = open("./gsm.log", "a+")
	try:
		file_object.write(x)
	finally:
		file_object.close()

def show_imsi(imsi):
	global imsis
	new_imsi=''
	for a in imsi:
		c=hex(ord(a))
		if len(c)==4:
			new_imsi+=str(c[3])+str(c[2])
		else:
			new_imsi+=str(c[2])+"0"

	new_imsi=new_imsi[1:4] + " " + new_imsi[4:6]+" " + new_imsi[6:10] + " " + new_imsi[10:11] + " " + new_imsi[11:]

	# filter with head: 460

	if new_imsi[0:3] == '460':
		if new_imsi not in imsis:
			imsis.append(new_imsi)
			print(new_imsi)
			write_log(new_imsi + '\n')

def find_imsi(x):
	p=str(x)
	if p[58:][:2] != '\x01+':
		# if not (CCCH) (SS)
		# GSM CCCH
		l2_pseudo_len=p[58]
		# if (l2_pseudo_len == '\x55'):

		show_imsi(p[72:][:8])
		show_imsi(p[63:][:8])
		show_imsi(p[73:][:8])

		# print(p[80])
		# if p[80] != '\x2b' and p[80] != '\x00' and p[80] != '\x4b' and p[80] != '\xc0':
		# 	# ShenZhen
		# 	# condition1 = '\x55'
		# 	# condition2 = '\x59'
		#
		# 	# Xian
		# 	condition1 = '\x01'
		# 	condition2 = '\x03'
		#
		# 	if l2_pseudo_len == condition1:
		# 	 	print(p[71:][:2] + "_" + l2_pseudo_len)
		# 	elif l2_pseudo_len == condition2:
		# 	 	print(p[62:][:2] + "_" + l2_pseudo_len)
		#
		# 	# if l2_pseudo_len=='\x55':
		# 	# if l2_pseudo_len=='\x55' and p[71:][:2] == '\x08\x29':
		# 	if l2_pseudo_len == condition1 and p[71:][:2] == '\x08\x49':
		# 		# if IMSI
		# 		show_imsi(p[72:][:8])
		# 		# exit()
		# 	# elif l2_pseudo_len=='\x59':
		# 	# elif l2_pseudo_len=='\x59' and p[62:][:2] == '\x08\x29':
		# 	elif l2_pseudo_len == condition2 and p[62:][:2] == '\x08\x49':
		# 		# if IMSI
		# 		show_imsi(p[63:][:8])
		# 		if p[72:][:2] == '\x08\x49':
		# 			# if IMSI 2
		# 			show_imsi(p[73:][:8])

write_log(str(time.time()) + '\n')
write_log('========================' + '\n')
sniff(iface="lo", filter="port 4729 and not icmp and udp", prn=find_imsi, store=0)
