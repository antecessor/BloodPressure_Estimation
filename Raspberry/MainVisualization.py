#!/usr/bin/env python
# -*- coding: utf-8 -*-
# vispy: gallery 2
# Copyright (c) Vispy Development Team. All Rights Reserved.
# Distributed under the (new) BSD License. See LICENSE.txt for more info.

"""
Multiple real-time digital signals with GLSL-based clipping.
"""
import time

import serial
from tkinter import *
import matlab.engine as me
import matlab
import numpy as np
import math
from threading import Timer,Thread,Event
import matplotlib.pyplot as plt
from drawnow import *
# Serial
#from UseRasp import GiveOut




eng = me.start_matlab()
eng.cd('C:\\Users\\antecessor\\Desktop\\Proj_bloodPressure\\Code')
ser = serial.Serial(baudrate=57600)
ser.port = 'COM4'
serard = serial.Serial(baudrate=9600)
serard.port = 'COM5'



try:
    ser.open()
    serard.open()
except:
    pass

# You probably won't need this if you're embedding things in a tkinter plot...
plt.ion()

# Number of cols and rows in the table.
nrows = 4
ncols = 1
# Number of samples per signal.
n = 1300
# Number of signals.
m = nrows*ncols



# Generate the signals as a (m, n) array.
y =  np.random.randn(m, n).astype(np.float32)
#fig = plt.figure()
#axs=fig.add_subplot(411)
#axs.autoscale_view(True,True,True)
#axs.relim()
#line0,= axs.plot(y[0, :])
#line1, = axs[1].plot(y[1, :])
#line2, = axs[2].plot(y[2, :])
#line3, = axs[3].plot(y[3, :])

#fig.canvas.draw()
#plt.show(block=False)


# Color of each vertex (TODO: make it more efficient by using a GLSL-based
# color map and the index).
color = np.repeat(np.random.uniform(size=(m, 3), low=.5, high=.9),
                  n, axis=0).astype(np.float32)

# Signal 2D index of each vertex (row and col) and x-index (sample index
# within each signal).
index = np.c_[np.repeat(np.repeat(np.arange(ncols), nrows), n),
              np.repeat(np.tile(np.arange(nrows), ncols), n),
              np.tile(np.arange(n), m)].astype(np.float32)



def FindBP():
    try:
        sysdys =eng.InterfacePythonMatlab(matlab.double(y[0, :].tolist()), matlab.double(y[1, :].tolist()), matlab.double(y[2, :].tolist()), matlab.double(y[3, :].tolist()))
       # eng.InterfacePythonMatlab(matlab.double(y[0,:].tolist()),matlab.double(y[1,:].tolist()))


        print(sysdys)
        print("Sys&Dys Real:\n")


        #sys,dys=GiveOut(y[0,:],y[1,:])
        #print('S:'+str(sys))
        #print('D:' + str(dys))
    except:
        print("Waiting for Good signal")
class perpetualTimer():

   def __init__(self,t,hFunction):
      self.t=t
      self.hFunction = hFunction
      self.thread = Timer(self.t,self.handle_function)

   def handle_function(self):
      self.hFunction()
      self.thread = Timer(self.t,self.handle_function)
      self.thread.start()

   def start(self):
      self.thread.start()

   def cancel(self):
      self.thread.cancel()


#global f22
#global f11
def ReadData():
    #global f22,f11
    f1=open('DataECG.MRD','w+')
    f2=open('DataPPG.MRD', 'w+')
    f3 = open('DataSys.MRD', 'w+')
    f4 = open('DataDys.MRD', 'w+')
    #f11 = open('DataECG.MRD', 'rb')
    #f22 = open('DataPPG.MRD', 'rb')
    ser.flush()
    serard.flush()
    iter=0
    while 1:
        try:
            line = ser.readline()
            linesysdys1=serard.readline()
            linesysdys2 = serard.readline()
            sys=float(linesysdys1)
            dys=float(linesysdys2)
            if sys<dys:
                temp=sys
                sys=dys
                dys=temp
            ECG = float(line[0:5])
            PPG = float(line[6:])
            f1.write(str(ECG)+"\n")
            f2.write(str(PPG)+"\n")
            f3.write(str(sys)+"\n")
            f4.write(str(dys)+"\n")
            y[0,iter]=ECG
            y[1,iter]=PPG
            y[2, iter] = sys
            y[3, iter] = dys

            iter = iter + 1
            if iter>=n:
                #line0.set_ydata(y[0,:])
                #line1.set_ydata(y[1, :])
                #line2.set_ydata(y[2, :])
                #line3.set_ydata(y[3, :])
                #fig.canvas.draw()
                #axs.draw()
                #time.sleep(0.01)
                #drawnow(makeFig)  # Call drawnow to update our live graph
                #plt.pause(.000001)


                iter=0

        except:
            ser.flush()
            serard.flush()
            y[0, iter] = y[0, iter-1]
            y[1, iter] = y[1,iter-1]
            y[2, iter] = y[2, iter - 1]
            y[3, iter] = y[3, iter - 1]
            print("problem")
            pass


c=[]
if __name__ == '__main__':
    c = Canvas()
    tReadData = Thread(target=ReadData)
    tReadData.start()
    t = perpetualTimer(2, FindBP)
    t.start()

