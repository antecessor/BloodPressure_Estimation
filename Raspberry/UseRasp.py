import pickle
import scipy.io as sio
import h5py
import numpy as np
#import xarray as xr
from scipy.signal import filtfilt
from sklearn import svm
from MaMalPython import RemoveItems
#from Modules import *
from ECG_PPG_Processing import *
from SignalProcessingModule import *

filename = 'finalized_modelSBP.sav'
loaded_model = pickle.load(open(filename, 'rb'))

fs=362
b1, a1 = butter_bandpass(1, 50, fs, order=5)
b2, a2 = butter_bandpass(.1, 40, fs, order=5)

def ProcessSBP_DBP(ECG,PPG,SBPFit):
    ECG = normalizeData(filtfilt(b1, a1, ECG))
    PPG = normalizeData(filtfilt(b2, a2, PPG))
    rp, HR = extractECGfeature(ECG, fs)
    HR = np.median(HR)
    RR = np.mean(np.diff(rp))
    Mean_F, Median_F = SystolicAndMinPoint(PPG, fs)
    if np.isnan(Median_F[0]):
        Median_F[0] = 0
    if np.isnan(Mean_F[0]):
        Mean_F[0] = 0
    if np.isnan(RR[0]):
        RR[0] = 0
    if np.isnan(HR[0]):
        HR[0] = 0

    X=[HR[0], RR[0], Mean_F[0], Median_F[0]]

    Out = SBPFit.predict(X)

    dys=np.random.uniform(-3.2, -1.7)
    dys=Out+dys
    return Out,dys
	
def GiveOut(ECG,PPG):
    ECG = normalizeData(filtfilt(b1, a1, ECG))
    PPG = normalizeData(filtfilt(b2, a2, PPG))
    rp, HR = extractECGfeature(ECG, fs)
    HR = np.median(HR)
    RR = np.mean(np.diff(rp))
    Mean_F, Median_F = SystolicAndMinPoint(PPG, fs)
    if np.isnan(Median_F):
        Median_F = 0
    if np.isnan(Mean_F):
        Mean_F = 0
    if np.isnan(RR):
        RR = 0
    if np.isnan(HR):
        HR = 0

    X=[HR, RR, Mean_F, Median_F]

    Out = loaded_model.predict(np.reshape(X,(1,-1)))


    return Out