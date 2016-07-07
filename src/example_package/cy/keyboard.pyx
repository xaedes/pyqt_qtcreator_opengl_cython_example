
from collections import defaultdict

cdef class Keyboard(object):
    def __init__(Keyboard self):
        self.key_down = defaultdict(lambda:False)

    cdef bint is_key_down(Keyboard self, int key):
        return self.key_down[key]

    cdef bint is_key_up(Keyboard self, int key):
        return self.key_down[key]

    cdef keyPressEvent(Keyboard self, event):
        self.key_down[event.key()] = True
    
    cdef keyReleaseEvent(Keyboard self, event):
        self.key_down[event.key()] = False

