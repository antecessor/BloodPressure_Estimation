import numpy as np

def RemoveItems(A,ind):
    ind=np.sort(ind)[::-1]
    for i in ind:
        A=np.delete(A,i)
    return A