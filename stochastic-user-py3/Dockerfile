FROM gcc:4.9
WORKDIR /root/install

RUN useradd -ms /bin/bash nanograv

# install LAPACK
RUN apt-get -y update && \
    apt-get -y install liblapack3 && \
    apt-get clean

# install a few other basic tools
RUN apt-get -y install less gawk vim && \
    apt-get clean

# make calceph
RUN wget --no-check-certificate -q https://www.imcce.fr/content/medias/recherche/equipes/asd/calceph/calceph-2.3.2.tar.gz && \
    tar zxvf calceph-2.3.2.tar.gz && \
    cd calceph-2.3.2 && \
    ./configure --prefix=/usr/local && \
    make && make install && \
    cd .. && rm -rf calceph-2.3.2 calceph-2.3.2.tar.gz

USER nanograv
RUN mkdir /home/nanograv/source
WORKDIR /home/nanograv/source

ENV LD_LIBRARY_PATH="/usr/local/lib"

# make tempo2
RUN git clone https://bitbucket.org/psrsoft/tempo2 && \
    cd tempo2 && \
    ./bootstrap && \
    ./configure --prefix=/home/nanograv --with-calceph=/usr/local && \
    make && make install && \
    mkdir -p /home/nanograv/share/tempo2 && \
    cp -Rp T2runtime/* /home/nanograv/share/tempo2/.

# get extra ephemeris
RUN cd /home/nanograv/share/tempo2/ephemeris && \
    wget -q ftp://ssd.jpl.nasa.gov/pub/eph/planets/bsp/de435t.bsp && \
    wget -q ftp://ssd.jpl.nasa.gov/pub/eph/planets/bsp/de436t.bsp && \
    wget -q https://github.com/nanograv/tempo/raw/master/ephem/DE435.1950.2050 && \
    wget -q https://github.com/nanograv/tempo/raw/master/ephem/DE436.1950.2050

ENV TEMPO2=/home/nanograv/share/tempo2

# install miniconda
RUN wget -q https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /home/nanograv/miniconda3 && \
    rm Miniconda3-latest-Linux-x86_64.sh

ENV PATH="/home/nanograv/miniconda3/bin:/home/nanograv/bin:${PATH}"

# install basic Python packages
RUN conda install -y numpy cython scipy && \
    conda clean -a

# install libstempo (before other Anaconda packages, esp. matplotlib, so there's no libgcc confusion)
# get 2.3.3 specifically (git sha 5669e69); run git pull to update to latest
RUN git clone https://github.com/vallis/libstempo.git && \
    cd libstempo && \
    git reset --hard 5aec48b && \
    python setup.py install --with-tempo2=/home/nanograv && \
    cd /home/nanograv && ln -s source/libstempo/demo libstempo-demo

# install more Python packages
RUN conda install -y matplotlib ipython jupyter notebook h5py mpi4py numexpr statsmodels astropy ephem && \
    conda clean -a

ENV MKL_NUM_THREADS=4

# Jupyter notebook extensions (could also be installed from conda-forge)
RUN pip install jupyter_contrib_nbextensions && \
    jupyter contrib nbextension install --user

# Jupyter notebook access script
COPY run_jupyter.sh /home/nanograv/bin

# non-standard-Anaconda packages
RUN pip install healpy acor line_profiler jplephem

# enterprise development packages
COPY requirements_dev.txt /home/nanograv/source/requirements_dev.txt
RUN pip install -r requirements_dev.txt

# install scikit last (in case it messes with MKL, but it may be possible to move it earlier)
RUN conda install -y -c menpo suitesparse && \
    export CPATH=/home/nanograv/miniconda3/include/suitesparse && \
    pip install scikit-sparse && \
    conda clean -a

# install enterprise
RUN git clone https://github.com/nanograv/enterprise.git && \
    cd enterprise && \
    python setup.py install

# matplotlib rc (default backend: Agg)
RUN mkdir -p /home/nanograv/.config/matplotlib 
COPY matplotlibrc /home/nanograv/.config/matplotlib
