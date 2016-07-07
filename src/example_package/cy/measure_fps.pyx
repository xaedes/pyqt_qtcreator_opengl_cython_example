
from example_package.cy.utils cimport gettimeofday_d

cdef class MeasureFps(object):

    def __init__(MeasureFps self, float gain):
        self._first = True
        self.gain = gain
        self.dt = 0
        self.fps = 0
        self.start_time = 0
        self.end_time = 0

    cdef start(MeasureFps self):
        self.start_time = gettimeofday_d()

    cdef end(MeasureFps self):
        self.end_time = gettimeofday_d()
        cdef double dt = self.end_time - self.start_time
        if self._first:
            self.dt = dt
            self._first = False
        else:
            self.dt = self.gain * dt + (1-self.gain) * self.dt

        if self.dt <> 0:
            self.fps = 1/self.dt
