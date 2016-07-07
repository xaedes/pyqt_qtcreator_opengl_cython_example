
from example_package.cy.utils cimport Point3f, Point2i, Point2f

from example_package.cy.keyboard cimport Keyboard

cdef class Camera(object):
    
    cdef Point3f pos
    cdef Point3f lookat
    cdef float yaw
    cdef float pitch
    
    cdef int inverted

    cdef Point2i last_mouse

    cdef Point2f speed

    cdef Keyboard keyboard

    cdef float speed_forward
    cdef float speed_sideward
    cdef float speed_forward_gain
    cdef float speed_sideward_gain
    cdef float speed_forward_friction
    cdef float speed_sideward_friction

    cdef bint mouse_walking

    cdef set_proj(Camera self, int display_width, int display_height)
    cdef set_view(Camera self)

    cdef set_lookat(Camera self, float x, float y, float z)
    cdef set_yaw_pitch(Camera self, float yaw, float pitch)

    cdef forward(Camera self, float amount)
    cdef sideward(Camera self, float amount)

    cdef update(Camera self, double dt)

    cdef mousePressEvent(Camera self, event)
    cdef mouseReleaseEvent(Camera self, event)
    cdef mouseMoveEvent(Camera self, event)
    cdef wheelEvent(Camera self, event)
