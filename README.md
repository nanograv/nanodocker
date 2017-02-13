# nanodocker

A repository of Dockerfiles for NANOGrav DWG Docker images.

## `nanograv-stochastic`

Currently the `nanograv-stochastic` image (available as `micvallis/nanograv-stochastic:v2.1` at the [Docker Hub](https://hub.docker.com/r/micvallis/nanograv-stochastic/)) includes [tempo2](https://bitbucket.org/psrsoft/tempo2) and [libstempo](https://github.com/vallis/libstempo) with the latest ephemeris functionality, [PAL2](https://github.com/jellis18/PAL2), [NX01](https://github.com/stevertaylor/NX01), and attendant Python packages (installed through [Miniconda](http://conda.pydata.org/miniconda.html)), including [PTMCMCSampler](https://github.com/jellis18/PTMCMCSampler). The image was built on top of [gcc:4.9](https://hub.docker.com/_/gcc), and it weighs 3.22GB (roughly half from gcc and half from Anaconda packages). The image is meant to be used by the passwordless user `nanograv`.

## Quickstart for local use

* [Install Docker](https://docs.docker.com/engine/installation)
* Start Docker.
* `docker pull micvallis/nanograv-stochastic:v2`
* `docker run -i -t -p 8888:8888 -u nanograv micvallis/nanograv-stochastic:v1 run_jupyter.sh`
* Then you can open a web browser at the address that appears on the screen, and gain access to a Jupyter notebook that can run the `libstempo`, `PAL2`, and `NX01` demos.
* Don't forget to remove your containers (`docker ps -a; docker rm ...`) once you're done.

## Building notes

* [Calceph](http://www.imcce.fr/fr/presentation/equipes/ASD/inpop/calceph) 2.3.2 is installed from sources, into `\usr/local`.
* `line_profiler` is installed with `pip`, to work around an Anaconda problem.
* `scikit-sparse` 0.31 is installed from the `menpo` repository, after `apt-get`-installing `liblapack3`.
