
from example_package.opengl.c_opengl cimport *

import numpy as np
cimport numpy as np

from libc.math cimport cos,sin
from math import pi

cdef class Building(object):
    
    def __init__(Building self, float center_x, float center_y, float center_z, float rotation, float dim_x, float dim_y, float dim_z):
        self.dimensions.x = dim_x
        self.dimensions.y = dim_y
        self.dimensions.z = dim_z
        self.center.x = center_x
        self.center.y = center_y
        self.center.z = center_z
        self.rotation = rotation
        self.vertices = np.zeros(shape=(8,3),dtype="float32")
        self.color[0] = 1
        self.color[1] = 1
        self.color[2] = 0
        self.update_vertices()

    cdef update_vertices(Building self):
        # index of self.vertices:
        # each bit stands for one axis
        # 0bXYZ
        # each bit specifies which point on this axis 


        cdef Point2f unit_x, unit_y
        # pointing from center to left plane of building (where X=1)
        unit_x.x = cos(self.rotation)*self.dimensions.x/2
        unit_x.y = sin(self.rotation)*self.dimensions.x/2
        # pointing from center to top plane of building (where Y=1)
        unit_y.x = cos(self.rotation+pi/2)*self.dimensions.y/2
        unit_y.y = sin(self.rotation+pi/2)*self.dimensions.y/2


        # set ceiling xy positions
        self.vertices[0b000,0] = self.center.x - unit_x.x - unit_y.x 
        self.vertices[0b000,1] = self.center.y - unit_x.y - unit_y.y

        self.vertices[0b010,0] = self.center.x - unit_x.x + unit_y.x
        self.vertices[0b010,1] = self.center.y - unit_x.y + unit_y.y

        self.vertices[0b100,0] = self.center.x + unit_x.x - unit_y.x
        self.vertices[0b100,1] = self.center.y + unit_x.y - unit_y.y

        self.vertices[0b110,0] = self.center.x + unit_x.x + unit_y.x
        self.vertices[0b110,1] = self.center.y + unit_x.y + unit_y.y

        cdef int k, index

        # copy xy to ceiling of building 
        for k in range(4):
            # iterate over XY in 0bXYZ by shifting 1 left
            index = (k << 1)

            # copy XY for Z=1 from Z=0
            self.vertices[index | 1,0] = self.vertices[index,0]
            self.vertices[index | 1,1] = self.vertices[index,1]

            # set floor height
            self.vertices[index,2] = self.center.z

            # set ceiling height
            self.vertices[index | 1,2] = self.vertices[index,2] + self.dimensions.z

    cdef update(Building self, double dt):
        pass

    cdef render(Building self):
        glBegin(GL_QUADS)

        glColor3fv(&self.color[0])

        # floor
        glVertex3fv(&self.vertices[0b000,0])
        glVertex3fv(&self.vertices[0b010,0])
        glVertex3fv(&self.vertices[0b110,0])
        glVertex3fv(&self.vertices[0b100,0])

        # ceil
        glVertex3fv(&self.vertices[0b001,0])
        glVertex3fv(&self.vertices[0b011,0])
        glVertex3fv(&self.vertices[0b111,0])
        glVertex3fv(&self.vertices[0b101,0])

        # y = 0 
        glVertex3fv(&self.vertices[0b000,0])
        glVertex3fv(&self.vertices[0b001,0])
        glVertex3fv(&self.vertices[0b101,0])
        glVertex3fv(&self.vertices[0b100,0])

        # y = 1
        glVertex3fv(&self.vertices[0b010,0])
        glVertex3fv(&self.vertices[0b011,0])
        glVertex3fv(&self.vertices[0b111,0])
        glVertex3fv(&self.vertices[0b110,0])

        # x = 0
        glVertex3fv(&self.vertices[0b000,0])
        glVertex3fv(&self.vertices[0b001,0])
        glVertex3fv(&self.vertices[0b011,0])
        glVertex3fv(&self.vertices[0b010,0])

        # x = 1
        glVertex3fv(&self.vertices[0b100,0])
        glVertex3fv(&self.vertices[0b101,0])
        glVertex3fv(&self.vertices[0b111,0])
        glVertex3fv(&self.vertices[0b110,0])

        glEnd()
