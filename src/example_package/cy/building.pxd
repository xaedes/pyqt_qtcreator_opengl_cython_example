
from example_package.cy.utils cimport Point3f, Point2i, Point2f

cdef class Building(object):
    
    cdef Point3f dimensions
    cdef Point3f center
    cdef float rotation

    # vertices
    cdef float[:,:] vertices

    cdef float[3] color

    cdef update_vertices(Building self)

    cdef update(Building self, double dt)
    cdef render(Building self)

