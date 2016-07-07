
cdef class MeasureFps(object):
    
    cdef int _first
    cdef double gain
    cdef double dt
    cdef double fps
    cdef double start_time
    cdef double end_time

    cdef start(MeasureFps self)
    cdef end(MeasureFps self)
