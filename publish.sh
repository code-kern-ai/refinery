#!/usr/bin/env bash
rm -rf dist/*
python3 setup.py bdist_wheel --universal
twine upload dist/*