
from PyQt4.QtCore import Qt
from libc.math cimport sin,cos,atan2
from math import pi

from example_package.opengl.c_opengl cimport *
from example_package.cy.keyboard cimport Keyboard



cdef class Camera(object):

    def __init__(Camera self, Keyboard keyboard, float eye_x, float eye_y, float eye_z):
        self.keyboard = keyboard
        self.pos.x = eye_x
        self.pos.y = eye_y
        self.pos.z = eye_z
        self.set_yaw_pitch(0,0)
        self.inverted = True

        self.speed.x = 0
        self.speed.y = 0

        self.speed_forward = 4
        self.speed_sideward = 2
        self.speed_forward_gain = 0.9
        self.speed_sideward_gain = 0.9
        self.speed_forward_friction = 0.3
        self.speed_sideward_friction = 0.1

        self.mouse_walking = False

    cdef set_proj(Camera self, int display_width, int display_height):
        # gluPerspective(GLdouble fovy, GLdouble aspect, GLdouble zNear, GLdouble zFar)
        gluPerspective(45, (<float>(display_width)/<float>(display_height)), 0.1, 100.0)


    cdef set_view(Camera self):
        gluLookAt(self.pos.x, self.pos.y, self.pos.z,  self.lookat.x, self.lookat.y, self.lookat.z,  0,  0,  1)

    cdef set_lookat(Camera self, float x, float y, float z):
        self.lookat.x = x
        self.lookat.y = y
        self.lookat.z = z
        cdef float dx,dy,dz
        dx = x-self.pos.x
        dy = y-self.pos.y
        dz = z-self.pos.z
        self.yaw = atan2(dy,dx)
        self.pitch = atan2(dz,dx)

    cdef set_yaw_pitch(Camera self, float yaw, float pitch):
        self.yaw = yaw
        self.pitch = pitch

        self.lookat.x = self.pos.x + cos(self.yaw)*cos(pitch)
        self.lookat.y = self.pos.y + sin(self.yaw)*cos(pitch)
        self.lookat.z = self.pos.z + sin(self.pitch)

    cdef forward(Camera self, float amount):
        cdef float speed = amount * self.speed_forward
        self.speed.x = speed * self.speed_forward_gain + (1-self.speed_forward_gain) * self.speed.x


    cdef sideward(Camera self, float amount):
        cdef float speed = amount * self.speed_sideward
        self.speed.y = speed * self.speed_sideward_gain + (1-self.speed_sideward_gain) * self.speed.y


    cdef update(Camera self, double dt):
        if self.keyboard.is_key_down(Qt.Key_W)or self.keyboard.is_key_down(Qt.Key_Up):
            self.forward(+1)
        if self.keyboard.is_key_down(Qt.Key_S)or self.keyboard.is_key_down(Qt.Key_Down):
            self.forward(-1)
        if self.keyboard.is_key_down(Qt.Key_A)or self.keyboard.is_key_down(Qt.Key_Left):
            self.sideward(-1)
        if self.keyboard.is_key_down(Qt.Key_D)or self.keyboard.is_key_down(Qt.Key_Right):
            self.sideward(+1)

        if self.mouse_walking:
            self.forward(1)


        # forward movement
        self.pos.x += cos(self.yaw) * self.speed.x * dt 
        self.pos.y += sin(self.yaw) * self.speed.x * dt

        # sideward movement
        self.pos.x += sin(self.yaw) * self.speed.y * dt
        self.pos.y -= cos(self.yaw) * self.speed.y * dt

        # friction
        self.speed.x *= self.speed_forward_friction ** dt
        self.speed.y *= self.speed_sideward_friction ** dt

        # set lookat
        self.set_yaw_pitch(self.yaw, self.pitch)

    cdef mousePressEvent(Camera self, event):
        buttons = event.buttons()
        if buttons & Qt.LeftButton:
            self.last_mouse.x = event.x()
            self.last_mouse.y = event.y()

        if (buttons & Qt.LeftButton) and (buttons & Qt.RightButton):
            self.mouse_walking = True
    
    cdef mouseReleaseEvent(Camera self, event):
        buttons = event.buttons()
        if self.mouse_walking and (buttons & (Qt.LeftButton | Qt.RightButton)):
            self.mouse_walking = False


    cdef mouseMoveEvent(Camera self, event):
        cdef int dx, dy
        dx = event.x()-self.last_mouse.x
        dy = event.y()-self.last_mouse.y
        cdef float dyaw, dpitch
        cdef float d2r = (2*pi/360)
        dyaw  = dx*0.1*d2r
        dpitch = dy*0.1*d2r
        if self.inverted:
            dyaw = -dyaw
            dpitch = -dpitch
        self.set_yaw_pitch(self.yaw+dyaw,self.pitch+dpitch)
        self.last_mouse.x = event.x()
        self.last_mouse.y = event.y()   

    cdef wheelEvent(Camera self, event):
        # QWheelEvent.delta() returns distance that wheel is 
        # rotated, in eights of a degree
        cdef float delta_deg = <float>(event.delta())/8.
        cdef float z_per_deg = 0.1 / 15.

        self.pos.z += z_per_deg * delta_deg

        self.set_yaw_pitch(self.yaw, self.pitch)
