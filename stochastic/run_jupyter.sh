#!/bin/bash

cd ${1:-$HOME}
/opt/miniconda2/bin/jupyter notebook --no-browser --port 8888 --ip=0.0.0.0
