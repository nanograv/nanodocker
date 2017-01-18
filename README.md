# nanodocker

A repository of Dockerfiles for NANOGrav DWG Docker images.

## `nanograv-stochastic`

Currently the `nanograv-stochastic` image (available as `micvallis/nanograv-stochastic:v1` at the [Docker Hub](https://hub.docker.com/r/micvallis/nanograv-stochastic/)) includes [tempo2](https://bitbucket.org/psrsoft/tempo2), [libstempo](https://github.com/vallis/libstempo), [PAL2](https://github.com/jellis18/PAL2), and attendant Python packages (installed through [Miniconda](http://conda.pydata.org/miniconda.html)). The image was built on top of [gcc:4.9](https://hub.docker.com/_/gcc), and it weighs 3.1GB (roughly half from gcc and half from Anaconda packages). The image is meant to be used by the passwordless user `nanograv`.

## Quickstart for local use

* [Install Docker](https://docs.docker.com/engine/installation)
* Start Docker.
* `docker pull micvallis/nanograv-stochastic:v1`
* `docker run -i -t -p 8888:8888 -u nanograv micvallis/nanograv-stochastic:v1 run_jupyter.sh`
* Then you can open a web browser at the address that appears on the screen, and gain access to a Jupyter notebook that can run the `libstempo` and `PAL2` demos.
* Don't forget to remove your containers (`docker ps -a; docker rm ...`) once you're done.
