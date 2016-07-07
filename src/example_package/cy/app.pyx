
# derived from
# https://github.com/mikeboers/0x10c-toolkit/blob/master/dcpu16/run.pyx

import sys
import time
from example_package.opengl.c_opengl cimport *

from example_package.opengl.mygl import glu, glut

from example_package.cy.measure_fps cimport MeasureFps
from example_package.cy.utils cimport gettimeofday_d

from example_package.cy.measure_fps cimport MeasureFps
from example_package.cy.keyboard cimport Keyboard
from example_package.cy.building cimport Building
from example_package.cy.terrain cimport Terrain
from example_package.cy.camera cimport Camera

import numpy as np
cimport numpy as np

from libc.math cimport cos
from math import pi


cdef class App(object):
    def __init__(self):
        self.render_fps = MeasureFps(0.15)
        self.update_fps = MeasureFps(0.15)
        self.true_fps = MeasureFps(0.15)
        self.next_print_time = 0
        self.print_interval = 1

        self.terrain = Terrain(25,25)
        self.keyboard = Keyboard()

        self.buildings = list()
        self.buildings.append(Building(self.terrain.width/2,self.terrain.height/2,0,0,2,1,1))
        self.buildings.append(Building(+2+self.terrain.width/2,-1+self.terrain.height/2,0,0.1*pi/2,2,1,3))

        self.camera = Camera(self.keyboard,0,0,10)
        # self.camera = Camera(0,0,10)
        self.camera.set_lookat(self.terrain.width/2,self.terrain.height/2,0)

    cpdef setup(self):
        # INIT OPENGL
        glClearColor(0, 0, 0, 1)
        
        # set wireframe mode
        glPolygonMode(GL_FRONT,GL_LINE)
        glPolygonMode(GL_BACK,GL_LINE)

    cpdef reshape(self, width, height):
        self.width = width
        self.height = height
        side = min(width, height)

        glViewport(0, 0, self.width, self.height)

        glMatrixMode(GL_PROJECTION)
        glLoadIdentity()
        self.camera.set_proj(self.width, self.height)

        glMatrixMode(GL_MODELVIEW)

    cpdef update(App self):
        cdef double now = gettimeofday_d()
        self.update_fps.start()

        if self.last_time <> 0:
            dt = now-self.last_time
        else:
            dt = 0.1
        self.last_time = now

        self.camera.update(dt)
        self.terrain.update(dt)

        cdef Building building
        for building in self.buildings:
            building.update(dt)

        self.update_fps.end()


    cpdef render(App self):
        self.terrain.render()

        cdef Building building
        for building in self.buildings:
            building.render()

    cpdef display(self):
        self.true_fps.start()
        
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)

        cdef double now = gettimeofday_d()

        glMatrixMode(GL_MODELVIEW)
        glLoadIdentity()
        self.camera.set_view()
        
        self.render_fps.start()
        self.render()
        self.render_fps.end()
        
        self.true_fps.end()

        if now > self.next_print_time:
            self.next_print_time = now + self.print_interval
            print "true fps %.2f \t update fps %.2f \t render fps %.2f"%(self.true_fps.fps,self.update_fps.fps,self.render_fps.fps)

    cpdef mousePressEvent(self, event):
        self.camera.mousePressEvent(event)
        
    cpdef mouseReleaseEvent(self, event):
        self.camera.mouseReleaseEvent(event)

    cpdef mouseMoveEvent(self, event):
        self.camera.mouseMoveEvent(event)

    cpdef wheelEvent(self, event):
        self.camera.wheelEvent(event)

    cpdef keyPressEvent(self, event):
        self.keyboard.keyPressEvent(event)

    cpdef keyReleaseEvent(self, event):
        self.keyboard.keyReleaseEvent(event)
