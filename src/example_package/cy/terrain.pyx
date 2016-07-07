
from example_package.opengl.c_opengl cimport *

import numpy as np
cimport numpy as np

cdef class Terrain(object):
    
    def __init__(Terrain self, int width, int height):
        self.width = width
        self.height = height
        self.height_values = np.random.normal(0,0.1,size=(self.width, self.height)).astype("float32")
        self.velocities = np.zeros(shape=(self.width, self.height),dtype="float32")
        self.color[0] = 1
        self.color[1] = 1
        self.color[2] = 1

    cdef update(Terrain self, double dt):
        rand = np.random.normal(0,1,size=(self.width,self.height)).astype("float32")
        cdef int x,y

        cdef float n1,n2,n3,n4,g
        for x in range(self.width):
            for y in range(self.height):
                self.velocities[x,y] += dt * 1.5*rand[x,y]
                self.velocities[x,y] *= 0.3 ** dt
                self.height_values[x,y] += dt * self.velocities[x,y]
                self.height_values[x,y] *= 0.99 ** dt

                if 0 < x < self.width-1:
                    if 0 < y < self.height-1:
                        g = 0.683 ** dt
                        n1 = self.velocities[x-1,y]
                        n2 = self.velocities[x,y-1]
                        n3 = self.velocities[x+1,y]
                        n4 = self.velocities[x,y+1]
                        self.velocities[x,y] = self.velocities[x,y] * g + (1-g) * 0.25 * (n1+n2+n3+n4)
                        n1 = self.height_values[x-1,y]
                        n2 = self.height_values[x,y-1]
                        n3 = self.height_values[x+1,y]
                        n4 = self.height_values[x,y+1]
                        self.height_values[x,y] = self.height_values[x,y] * g + (1-g) * 0.25 * (n1+n2+n3+n4)

    cdef render(Terrain self):
        cdef int x,y
        cdef float z00,z01,z10,z11
        for x in range(self.width-1):
            glBegin(GL_QUAD_STRIP)

            glColor3fv(&self.color[0])

            # Draws a connected group of quadrilaterals. One quadrilateral is defined for 
            # each pair of vertices presented after the first pair. 
            # Vertices 2 ⁢ n - 1 , 2 ⁢ n , 2 ⁢ n + 2 , and 2 ⁢ n + 1 define quadrilateral n. 
            # N 2 - 1 quadrilaterals are drawn. Note that the order in which vertices are
            # used to construct a quadrilateral from strip data is different from that used
            # with independent data.

            y = 0
            z00 = self.height_values[x,y]
            z10 = self.height_values[x+1,y]

            glVertex3f(x,y,z00)
            glVertex3f(x+1,y,z10)

            for y in range(self.width-1):
                z01 = self.height_values[x,y+1]
                z11 = self.height_values[x+1,y+1]

                glVertex3f(x,y+1,z01)
                glVertex3f(x+1,y+1,z11)

                z00,z10 = z01,z11

            glEnd()
