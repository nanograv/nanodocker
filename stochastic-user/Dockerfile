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
RUN wget -q http://www.imcce.fr/fr/presentation/equipes/ASD/inpop/calceph/calceph-2.3.2.tar.gz && \
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
    wget -q ftp://ssd.jpl.nasa.gov/pub/eph/planets/bsp/de436t.bsp

ENV TEMPO2=/home/nanograv/share/tempo2

# install miniconda
RUN wget -q https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh && \
    bash Miniconda2-latest-Linux-x86_64.sh -b -p /home/nanograv/miniconda2 && \
    rm Miniconda2-latest-Linux-x86_64.sh

ENV PATH="/home/nanograv/miniconda2/bin:/home/nanograv/bin:${PATH}"

# install basic Python packages
RUN conda install -y numpy cython scipy && \
    conda clean -a

# install libstempo (before other Anaconda packages, esp. matplotlib, so there's no libgcc confusion)
RUN git clone https://github.com/vallis/libstempo.git && \
    cd libstempo && \
    python setup.py install --with-tempo2=/home/nanograv && \
    cd /home/nanograv && ln -s source/libstempo/demo libstempo-demo

# install more Python packages
RUN conda install -y matplotlib ipython jupyter notebook h5py mpi4py numexpr statsmodels astropy ephem && \
    conda clean -a

# Jupyter notebook access script
COPY run_jupyter.sh /home/nanograv/bin

# non-standard-Anaconda packages
RUN pip install healpy acor line_profiler

# install PTMCMCSampler
RUN git clone https://github.com/jellis18/PTMCMCSampler && \
    cd PTMCMCSampler && \
    python setup.py install

# install scikit
RUN conda install -y -c menpo scikit-sparse && \
    conda clean -a

# install PAL2 (do not remove it)
RUN git clone https://github.com/jellis18/PAL2.git && \
    cd PAL2 && \
    python setup.py install && \
    cd /home/nanograv && ln -s source/PAL2/demo PAL2-demo

# install NX01 (rather, check it out and create a symbolic link)
RUN git clone https://github.com/stevertaylor/NX01.git && \
    cd /home/nanograv && ln -s source/NX01 NX01

# matplotlib rc (default backend: Agg)
RUN mkdir -p /home/nanograv/.config/matplotlib 
COPY matplotlibrc /home/nanograv/.config/matplotlib
