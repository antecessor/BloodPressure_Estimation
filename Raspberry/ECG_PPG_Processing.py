from biosppy.signals import ecg
import numpy as np
from scipy.signal import find_peaks
#from libs import detect_peaks
import pdb

'''
 ts : array
        Signal time axis reference (seconds).
    filtered : array
        Filtered ECG signal.
    rpeaks : array
        R-peak location indices.
    templates_ts : array
        Templates time axis reference (seconds).
    templates : array
        Extracted heartbeat templates.
    heart_rate_ts : array
        Heart rate time axis reference (seconds).
    heart_rate : array
        Instantaneous heart rate (bpm).
'''

def extractECGfeature(data,fs):
    _,_,rpeaks,_,_,_,HR=ecg.ecg(data,fs,show=False)
    #rpeaks,HR=ecgPeak(data,fs)
    return rpeaks,HR
def SystolicAndMinPoint(PPG,fs):
    dist=.3*fs
    locsys,pksys=find_peaks(PPG,height=.7,distance=dist)
    #locsys=detect_peaks(PPG, mph=.7, mpd=dist)
    #pksys=PPG[locsys]
    pksys = pksys['peak_heights']
    #locs_sys_min=detect_peaks(-PPG, mph=.7, mpd=dist)
    locs_sys_min,pks_sys_min = find_peaks(-PPG, height=-.7, distance= dist)
    pks_sys_min=-pks_sys_min['peak_heights']
    #pks_sys_min=-PPG[locs_sys_min]
    Dist=np.zeros([len(locsys),len(locs_sys_min)])

    for i in np.arange(len(locsys)):
        for j in np.arange(len(locs_sys_min)):
            Dist[i,j]=np.abs(locsys[i]-locs_sys_min[j])


    a = Dist.shape[0]
    b = Dist.shape[1]
    Subset=[]
    #pdb.set_trace()
    if a >= b:
        mD = np.min(Dist,axis=0)
        for i in np.arange(len(mD)):
            ind = np.where(Dist[:, i] == mD[i])
            if len(ind) > 0:
                try:
                    Subset.append(locsys[int(ind[0])])
                    Subset.append(locs_sys_min[i])
                except:
                    pass

    else:
        mD = np.min(Dist,axis=1)
        for i in np.arange(len(mD)):
            ind = np.where(Dist[i,:] == mD[i])
            if len(ind)>0:
                try:
                    Subset.append(locsys[int(ind[0])])
                    Subset.append(locs_sys_min[i])
                except:
                    pass

    Mean_F=0
    Median_F=0
    try:
        Mean_F = np.round(np.mean(Subset))
        Median_F = np.round(np.mean(Subset))
    except:
        Mean_F=0
        Median_F=0


    return Mean_F,Median_F