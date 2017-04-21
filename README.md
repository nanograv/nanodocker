# nanodocker

A repository of Dockerfiles for NANOGrav DWG Docker images.

## `nanograv-stochastic`

Currently the `nanograv-stochastic` image (available as `micvallis/nanograv-stochastic:v2.4` at the [Docker Hub](https://hub.docker.com/r/micvallis/nanograv-stochastic/)) includes [tempo2](https://bitbucket.org/psrsoft/tempo2) and [libstempo](https://github.com/vallis/libstempo) with the latest ephemeris functionality, [PAL2](https://github.com/jellis18/PAL2), [NX01](https://github.com/stevertaylor/NX01), and attendant Python packages (installed through [Miniconda](http://conda.pydata.org/miniconda.html)), including [PTMCMCSampler](https://github.com/jellis18/PTMCMCSampler). The image was built on top of [gcc:4.9](https://hub.docker.com/_/gcc), and it weighs 3.22GB (roughly half from gcc and half from Anaconda packages). The image is meant to be used by the passwordless user `nanograv`.

## `nanograv-stochastic-user`

Same as `nanograv-stochastic`, but all Python packages are installed under the user `nanograv`, and can therefore be updated. The latest version is `micvallis/nanograv-stochastic-user:v1.1`.

## Quickstart for local use

* [Install Docker](https://docs.docker.com/engine/installation)
* Start Docker.
* Pull the repository and run jupyter notebook in a new container
```bash
docker pull micvallis/nanograv-stochastic:v2.4
docker run -i -t -p 8888:8888 -u nanograv micvallis/nanograv-stochastic:v2.4 run_jupyter.sh
```
* Then you can open a web browser at the address that appears on the screen, and gain access to a Jupyter notebook that can run the `libstempo`, `PAL2`, and `NX01` demos.
* If you're using the older Docker Toolbox for Mac (and perhaps some versions on Windows), you need to point your browser to the IP address of the virtual machine, which you can see with `docker-machine ip default`.
* Also, if you're already using port 8888 locally, you should remap the Docker port elsewhere, e.g., with `-p 8890:8888`.  
* Don't forget to remove your containers (`docker ps -a; docker rm ...`) once you're done.

### Tips and Tricks
 * **run a terminal in an already running container.**
 ```bash
 docker exec -it [container_ID] bash
 ```
 You can replace `bash` with any terminal command.
 
 * **mount a local directory in a container.**
 When you run a new container all files you create will be available to **that** container.
 If you start a second container or update a container all of your changes will be inaccessible.
 ```bash
 docker run [the usual options] -v /my/local/dir:/home/nanograv/local_data/ run_jupyter.sh
 ```
 Your local directory will appear in the home directory of the container as `local_data/`.
 
 * **reattach to a stopped container.**  Use `docker ps -a` to see all containers.
 ```bash
 docker start [container_ID]  # start a stopped container
 docker attach [container_ID] # attach this terminal to a container
 ```
 You can now navigate your browser to the same URL to reattch to the Jupyter notebook server.
 
 * **copy files to or from the local file system.**
 From a local terminal you can use `docker cp [source] [dest]` with the container ID.
 `docker cp` is recursive by default so it can copy full directories (unlike standard `cp`).
 ```bash
 docker cp /path/to/local/file [container_ID]:/path/in/container
 ```
 
## Building notes

* [Calceph](http://www.imcce.fr/fr/presentation/equipes/ASD/inpop/calceph) 2.4.2 is installed from sources, into `/usr/local`.
* `line_profiler` is installed with `pip`, to work around an Anaconda problem.
* `scikit-sparse` 0.31 is installed from the `menpo` repository, after `apt-get`-installing `liblapack3`.
* `less`, `gawk`, and `vim` are installed with `apt-get`.
