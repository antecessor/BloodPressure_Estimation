from scipy.signal import butter, lfilter
import numpy as np


def butter_bandpass(lowcut, highcut, fs, order=5):
    nyq = 0.5 * fs
    low = lowcut / nyq
    high = highcut / nyq
    b, a = butter(order, [low, high], btype='band')
    return b, a



def normalizeData(x):
    x= x/np.max(x)
    return x
