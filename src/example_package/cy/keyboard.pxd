
cdef class Keyboard(object):

    cdef object key_down

    cdef bint is_key_down(Keyboard self, int keycode)
    cdef bint is_key_up(Keyboard self, int keycode)

    cdef keyPressEvent(Keyboard self, event)
    cdef keyReleaseEvent(Keyboard self, event)
