#!/usr/bin/env python2
# -*- coding: utf-8 -*-

# from distutils.core import setup 
from setuptools import setup
from distutils.extension import Extension
from Cython.Build import cythonize

import os
import numpy as np

PACKAGE_NAME="example_package"
PACKAGE_DIR="src/"+PACKAGE_NAME+"/"

# Find all Cython modules.
ext_modules = []


include_path = os.path.abspath(PACKAGE_DIR+"/../")
for dirpath, dirnames, filenames in os.walk(PACKAGE_DIR):

    for filename in filenames:
        if filename.endswith('.pyx'):
            # print dirpath,filename
            
            path = os.path.join(dirpath, filename)
            module_name = path.replace('/', '.')[:-4].strip('.')
            if module_name.startswith("src."):
                module_name = module_name[4:]
            # print module_name
            ext_modules.append(Extension(module_name, [path],
                include_dirs=['.',include_path,np.get_include()],
                libraries=['GL','GLU']
            ))


setup(
    name = PACKAGE_NAME,
    package_dir = {"": "src"},
    packages = [PACKAGE_NAME],
    ext_modules = cythonize(ext_modules)

)

# http://docs.cython.org/src/reference/compilation.html#compilation-reference
# http://docs.cython.org/src/userguide/source_files_and_compilation.html
