
PACKAGE_NAME=example_package
.PHONY: all cython ui clean run install_develop uninstall_develop activate_venv

all: ui cython install_develop run

cython:
	python setup.py build_ext --inplace

install_develop:
	python setup.py develop

uninstall_develop:
	python setup.py develop --uninstall

ui: src/$(PACKAGE_NAME)/ui/form_ui.py

%_ui.py: %.ui
	pyuic4 $< > $@
	
clean:
	rm -rf build/
	rm -rf src/build/
	rm -rf src/$(PACKAGE_NAME).egg-info
	find -name "*.c" -delete
	find -name "*.pyc" -delete
	find -name "*.so" -delete
	find -name "*_ui.py" -delete

run:
	cd src/ && ./$(PACKAGE_NAME)/start.py

activate_venv:
	@echo "Execute this to activate virtual env:"
	@echo "source venv/bin/activate"

venv:
	virtualenv --system-site-packages venv
