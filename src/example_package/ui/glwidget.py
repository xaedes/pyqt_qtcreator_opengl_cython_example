#!/usr/bin/env python2
# -*- coding: utf-8 -*-

from __future__ import absolute_import

from PyQt4 import QtCore, QtGui, QtOpenGL

from example_package.cy.app import App

class GLWidget(QtOpenGL.QGLWidget):
    def __init__(self, parent=None):
        super(GLWidget, self).__init__(parent)


        self.timer = QtCore.QTimer()
        self.timer.timeout.connect(self.on_timer)
        self.timer.start(1)

        self.setFocusPolicy(QtCore.Qt.StrongFocus)

        self.app = App()

    def minimumSizeHint(self):
        return QtCore.QSize(50, 50)

    def sizeHint(self):
        return QtCore.QSize(640, 480)
    
    def initializeGL(self):
        self.app.setup()

    def paintGL(self):
        self.app.display()

    def resizeGL(self, width, height):
        side = min(width, height)
        if side < 0:
            return
        self.app.reshape(width, height)

    def on_timer(self):
        self.app.update()
        self.update()

    def mousePressEvent(self, event):
        self.app.mousePressEvent(event)
        
    def mouseReleaseEvent(self, event):
        self.app.mouseReleaseEvent(event)

    def mouseMoveEvent(self, event):
        self.app.mouseMoveEvent(event)

    def keyPressEvent(self, event):
        self.app.keyPressEvent(event)

    def keyReleaseEvent(self, event):
        self.app.keyReleaseEvent(event)

    def wheelEvent(self, event):
        self.app.wheelEvent(event)