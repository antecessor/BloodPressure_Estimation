from scipy.signal import find_peaks
import numpy as np
#from IPython.core.debugger import Pdb


def SperateSignals(Data,N):

    ECG=Data[-1- N: -1,2]
    PPG=Data[-1 - N: -1,0]
    ABP=Data[-1 - N: -1,1]
    SBP,DBP = FindDBP_FindSBP(ABP)

    #if isempty(SBP(k)) | | isempty(DBP(k))
    #   k = k;
    #else
    #    k = k + 1;
    return ECG,PPG,SBP,DBP

def FindDBP_FindSBP(ABP):
    Distance = 50
    locs,pks  = find_peaks(ABP, height=80,distance=Distance)
    pks=pks['peak_heights']
   # Pdb.set_trace()
    x = np.nonzero(pks > 180)
    np.delete(locs,x)
   
    try:
        SBP = np.median(pks)
    except:
        SBP = []
    ''' DBP '''
    Distance = 50
    locs, pks = find_peaks(-ABP, height= -130, distance=Distance)
    pks = pks['peak_heights']
    pks = -pks
    x =  np.nonzero(pks < 60)
    np.delete(locs,x)
    try:
        DBP = np.median(pks)
    except:
        DBP = []
    
    return SBP,DBP


