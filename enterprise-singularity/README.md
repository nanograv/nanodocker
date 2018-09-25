# Running Enterprise with Singularity

* Singularity home: https://www.sylabs.io
* Singularity documentation: https://www.sylabs.io/guides/2.6/user-guide/
* SingularityHub `nanograv/nanodocker` collection: https://www.singularity-hub.org/collections/1726 

The broad idea is that a Singularity "container" includes Python 3.6 with all the libraries (`numpy/scipy`, `tempo2`, `libstempo`, etc.) that are needed to run enterprise. Thus, in a cluster environment, you will run Jupyter notebooks and batch jobs *inside* the Singularity container. However, your data files, output files, and even the Enterprise distribution will reside in your home directory on the cluster, and will be visible to Singularity. (I could have included the Enterprise distribution in the container, but since it's still evolving, it’s best to keep it under your control so you can `git pull` as needed.)

To get set up on a cluster with singularity, do the following

    git clone https://github.com/nanograv/enterprise.git
    git clone https://github.com/stevertaylor/enterprise_extensions

    singularity pull shub://nanograv/nanodocker

    singularity shell nanograv-nanodocker-master-latest.simg

[the commands to follow will be “inside” the container”]

    cd enterprise
    python setup.py develop --user
    cd ..
    cd enterprise_extensions
    python setup.py develop --user 
    cd ..

[CTRL-D to exit the container]

After this (which you need to do only once), every time you want to use the containerized Jupyter interactively, you can just do

    singularity run nanograv-nanodocker-master-latest.simg 9000 --ip=0.0.0.0

If port 9000 is busy, try 9001 or higher. Note the secret “token” that Jupyter gives you. Last, you need to set up a tunnel from your laptop to the cluster to access the Jupyter notebook server:

    ssh CLUSTERHOST -L 9000:CLUSTERHOST:9000 -N

(or change the 9000 if you have used a different value). Now point your browser (on your laptop) to localhost:9000, and insert the token you noted before. Remember that everything you save (and more generally, the file system that you see) comes from your home directory on the cluster, and use scp to transfer files as needed.

To run other Python scripts or other commands inside the container (as you would do for batch jobs), you can just do

    singularity exec nanograv-nanodocker-master-latest.simg YOURCOMMAND
