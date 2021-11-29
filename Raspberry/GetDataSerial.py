import serial
import matplotlib.pyplot as plt
import numpy as np
ser = serial.Serial(port='COM4',baudrate=57600)
ser.port = 'COM4'
try:
    ser.open()
except:
    pass
plt.ion()
fig=plt.figure(1)

Data=np.zeros([2000,1])
while 1:

    for i in range(0,2000):
        line=ser.readline()
        ECG=line[0:5]
        PPG=line[6:]
        try:
            Data[i]=float(ECG)
        except:
            pass
    plt.figure(1)
    plt.plot(Data)
    plt.draw()




