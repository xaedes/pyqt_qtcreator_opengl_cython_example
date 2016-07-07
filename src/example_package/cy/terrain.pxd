
cdef class Terrain(object):
    
    cdef float[:,:] height_values
    cdef float[:,:] velocities
    cdef int width
    cdef int height

    cdef float[3] color

    cdef update(Terrain self, double dt)
    cdef render(Terrain self)

