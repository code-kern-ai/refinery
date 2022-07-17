#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os

from setuptools import setup, find_packages

this_directory = os.path.abspath(os.path.dirname(__file__))
with open(os.path.join(this_directory, "README.md"), encoding="utf8") as file:
    long_description = file.read()

setup(
    name="kern-refinery",
    version="1.0.1",
    author="jhoetter",
    author_email="johannes.hoetter@kern.ai",
    description="The open-source data-centric IDE for NLP.",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/code-kern-ai/refinery",
    keywords=[
        "Kern AI",
        "refinery",
        "machine-learning",
        "supervised-learning",
        "data-centric-ai",
        "data-annotation",
        "python",
    ],
    classifiers=[
        "Development Status :: 4 - Beta",
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: Apache Software License",
    ],
    package_dir={"": "."},
    packages=find_packages("."),
    install_requires=[
        "requests",
        "wasabi",
        "GitPython",
    ],
    entry_points={
        "console_scripts": [
            "refinery=cli:main",
        ],
    },
)
