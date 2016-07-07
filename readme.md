
"missing cimport in module" 
This warning happens when you don't have installed the package.

Invoking make will install the package after first compilation.

Use virtualenv to locally install the package:

make venv                   ; Creates virtualenv
source venv/bin/activate    ; Activate virtualenv
make                        ; to build, install and run

make run                    ; only run, dont build
