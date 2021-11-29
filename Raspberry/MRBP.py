# -*- coding: utf-8 -*-
"""
Created on Wed. May 4 2016

@author: Beershare
"""
from UseRasp import *
import time
import serial
from multiprocessing.pool import ThreadPool
import numpy as np
#Serial port configuration
ser = serial.Serial(port='/dev/ttyAMA0',timeout=1,baudrate=57600)
ser.isOpen()
ser.flushInput()
print("THUMB BLOOD PLEASURE")
print("------------------")
print("")
velocidad=[1]
enable=0
enable2=0
counter=0
tiempo=0                                    #time1 Ecg
tiempoanterior=0                            #time2 Ecg
tiempo2=0                                   #time1 Ppg
tiempoanterior2=0                           #time2 Ppg
x=float(0)                                  #x will save the peek of Ecg but initialize with 0
x2=float(0)                                 #x will save the peek of Ppg but initialize with 0
average=3                                   ##how many values for average
avheart=np.zeros(average)                   ##average values
avsbp=np.zeros(average)                     ##inicialize the array
avdbp=np.zeros(average)                     ##with zeros
avcount=0
def acelerador():                           #loop
	global enable
	global enable2
	global counter
	global x
	global x2
	global tiempo
	global tiempoanterior
	global tiempo2
	global tiempoanterior2
	global avheart
	global avsbp
	global avdbp
	global avcount
	global average
	try:
		line = ser.readline()              #serial reading port
		counter+=1                         #count the samples
		if counter>0:                      #start if counter is >0
		 data0=line[0:5]                #detect ECG value
		 data1=line[6:]                 #detect PPG value
		 sys,dys=GiveOut(data0,data1)
		 print('systol')
		 print(sys)
		 print('dyastol')
		 print(dys)
	except:
		velocidad[0]+=1         
while True:             #make a loop
    acelerador()        #call the function

