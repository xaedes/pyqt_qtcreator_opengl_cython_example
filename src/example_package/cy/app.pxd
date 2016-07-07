
from example_package.cy.measure_fps cimport MeasureFps
from example_package.cy.keyboard cimport Keyboard
from example_package.cy.building cimport Building
from example_package.cy.terrain cimport Terrain
from example_package.cy.camera cimport Camera

cdef class App(object):
    cdef double last_time
    
    cdef unsigned int width
    cdef unsigned int height
    
    cdef unsigned int font_texture
    
    cdef MeasureFps render_fps
    cdef MeasureFps true_fps
    cdef MeasureFps update_fps
    
    cdef double next_print_time
    cdef double print_interval

    cdef Keyboard keyboard
    cdef Terrain terrain 
    cdef list buildings
    cdef Camera camera

    cpdef setup(self)

    cpdef reshape(self, width, height)

    cpdef update(App self)

    cpdef render(App self)

    cpdef display(self)
    
    cpdef mousePressEvent(self, event)
    cpdef mouseReleaseEvent(self, event)
    cpdef mouseMoveEvent(self, event)
    cpdef wheelEvent(self, event)

    cpdef keyPressEvent(self, event)
    cpdef keyReleaseEvent(self, event)
