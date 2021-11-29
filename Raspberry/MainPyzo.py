import pickle

import scipy.io as sio
import h5py
import numpy as np
import xarray as xr
from scipy.signal import filtfilt
from sklearn import svm
from MaMalPython import RemoveItems
from Modules import *
from ECG_PPG_Processing import *
from SignalProcessingModule import *
# %% Load Data
NumberProcess=1000
filename='C:/Users/antecessor/Desktop/Proj_bloodPressure/Code/Part_1.mat'
bar = h5py.File(filename)
data=bar['Part_1']
Data=xr.DataArray
DataAll={}
for i in range(0,NumberProcess):
    Data=bar[data.value[i][0]][:]
    DataAll[i]=Data
    print(str(i)+" number is done")
print('Data is loaded')

# %% Sperate Variables
N_sampleProcess=500
ECG={}
PPG={}
SBP={}
DBP={}
for i in range(0,len(DataAll)):
    ECG[i],PPG[i],SBP[i],DBP[i]=SperateSignals(DataAll[i],N_sampleProcess)

# %% removing Nan
SBP=np.array(list(SBP.values())) # convert to  array
DBP=np.array(list(DBP.values()))
SBP_ind_nan=np.argwhere(~np.isnan(SBP))
DBP_ind_nan=np.argwhere(~np.isnan(DBP))
#del DataAll
NotNanIndex=np.concatenate((SBP_ind_nan,DBP_ind_nan))
NotNanIndex=np.unique(NotNanIndex)
# %% Pre-Processing
fs=125
b1, a1 = butter_bandpass(1, 50, fs, order=5)
b2, a2 = butter_bandpass(.1, 30, fs, order=5)
rp={}
RR_All=np.zeros([NumberProcess,1])
HR_All=np.zeros([NumberProcess,1])
Mean_F=np.zeros([NumberProcess,1])
Median_F=np.zeros([NumberProcess,1])
X=[]
for i in NotNanIndex:
    ECG[i]=normalizeData(filtfilt(b1,a1,ECG[i]))
    PPG[i] = normalizeData(filtfilt(b2, a2, PPG[i]))
    print('Signal Number '+str(i)+' is doen...')
    rp[i],HR=extractECGfeature(ECG[i],fs)
    HR_All[i]=np.median(HR)
    RR_All[i]=np.mean(np.diff(rp[i]))
    Mean_F[i],Median_F[i]=SystolicAndMinPoint(PPG[i],fs)
    if np.isnan(Median_F[i][0]):
        Median_F[i][0]=0
    if np.isnan(Mean_F[i][0]):
        Mean_F[i][0]=0
    if np.isnan(RR_All[i][0]):
        RR_All[i][0] = 0
    if np.isnan(HR_All[i][0]):
        HR_All[i][0] = 0
    X.append([HR_All[i][0],RR_All[i][0],Mean_F[i][0],Median_F[i][0]])
# %% Regression Sections
SBP_ind_nan=np.argwhere(np.isnan(SBP))
SBP=RemoveItems(SBP,SBP_ind_nan)
ind=np.sort(SBP_ind_nan)[::-1]
for i in ind:
    del X[int(i)]
SBPFit = svm.SVR()
SBPFit.fit(X, SBP[1:996])
Out=SBPFit.predict(X)
# %% Finalize Model
filename = 'finalized_modelSBP.sav'
pickle.dump(SBPFit, open(filename, 'wb'))
