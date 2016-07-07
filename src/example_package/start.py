#!/usr/bin/env python2
# -*- coding: utf-8 -*-

from __future__ import absolute_import

import sys
import math
from funcy import partial

from PyQt4 import QtCore, QtGui, QtOpenGL

print sys.path

from example_package.ui.form_ui import Ui_Form
from example_package.ui.glwidget import GLWidget

class Form(Ui_Form, QtGui.QMainWindow):
    def __init__(self):
        QtGui.QWidget.__init__(self)
        self.setupUi(self)
        self.glWidget = GLWidget()
        self.container.addWidget(self.glWidget)


    def setupUi(self, form):
        super(Form,self).setupUi(form)


def main():
    qapp = QtGui.QApplication(sys.argv)
    frm = Form()
    frm.show()
    sys.exit(qapp.exec_())

if __name__ == '__main__':
    main()
