

#https://github.com/cython/cython/blob/master/Cython/Includes/posix/time.pxd
from posix.time cimport timeval, timezone, gettimeofday

cdef double gettimeofday_d():
    cdef timeval tp
    
    gettimeofday(&tp, <timezone*>0)
    return tp.tv_sec + 1e-6 * tp.tv_usec
