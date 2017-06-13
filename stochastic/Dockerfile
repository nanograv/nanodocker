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

ENV LD_LIBRARY_PATH="/usr/local/lib"

# make tempo2
RUN wget -q https://bitbucket.org/psrsoft/tempo2/get/master.tar.gz && \
    tar zxf master.tar.gz && \
    cd psrsoft-tempo2-* && \
    ./bootstrap && \    
    ./configure --prefix=/usr/local --with-calceph=/usr/local && \
    make && make install && \
    mkdir /usr/local/share/tempo2 && \
    cp -Rp T2runtime/* /usr/local/share/tempo2/. && \
    cd .. && rm -rf psrsoft-tempo2-* master.tar.gz

# get extra ephemeris
RUN cd /usr/local/share/tempo2/ephemeris && \
    wget -q ftp://ssd.jpl.nasa.gov/pub/eph/planets/bsp/de435t.bsp && \
    wget -q ftp://ssd.jpl.nasa.gov/pub/eph/planets/bsp/de436t.bsp && \
    wget -q https://github.com/nanograv/tempo/raw/master/ephem/DE435.1950.2050 && \
    wget -q https://github.com/nanograv/tempo/raw/master/ephem/DE436.1950.2050

ENV TEMPO2=/usr/local/share/tempo2

# install miniconda
RUN wget -q https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh && \
    bash Miniconda2-latest-Linux-x86_64.sh -b -p /opt/miniconda2 && \
    rm Miniconda2-latest-Linux-x86_64.sh && \
    export PATH="/opt/miniconda2/bin:${PATH}" && \
    conda install -y numpy cython scipy matplotlib ipython jupyter notebook h5py mpi4py numexpr statsmodels astropy ephem && \
    pip install healpy acor line_profiler jplephem && \
    conda install -y -c menpo suitesparse && \
    export CPATH=/opt/miniconda2/include/suitesparse && \
    pip install scikit-sparse && \
    find /opt/miniconda2 ! -perm /o=r -exec chmod o+rx {} \;

ENV PATH="/opt/miniconda2/bin:${PATH}"

# install basic Python packages
#RUN conda install -y numpy cython scipy matplotlib ipython jupyter notebook h5py mpi4py numexpr statsmodels astropy ephem && \
#    pip install healpy acor line_profiler jplephem && \
#   conda clean -a && \
#    find /opt/miniconda2 ! -perm /o=r -exec chmod o+rx {} \;

# install libstempo (before other Anaconda packages, esp. matplotlib, so there's no libgcc confusion)
# get 2.3.3 specifically (git sha 5669e69); run git pull to update to latest
RUN git clone https://github.com/vallis/libstempo.git && \
    cd libstempo && \
    git reset --hard 5669e69 && \
    python setup.py install --with-tempo2=/usr/local && \
    cp -rp demo /home/nanograv/libstempo-demo && chown -R nanograv /home/nanograv/libstempo-demo && \
    cd .. && rm -rf libstempo && \
    find /opt/miniconda2 ! -perm /o=r -exec chmod o+rx {} \; && \
    find /home/nanograv ! -perm /o=r -exec chmod o+rx {} \;

# install more Python packages
# RUN conda install -y matplotlib ipython jupyter notebook h5py mpi4py numexpr statsmodels astropy ephem && \
#   conda clean -a && \
#   find /opt/miniconda2 ! -perm /o=r -exec chmod o+rx {} \;

# Jupyter notebook access script
COPY run_jupyter.sh /opt/miniconda2/bin

ENV MKL_NUM_THREADS=4

# non-standard-Anaconda packages
# RUN pip install healpy acor line_profiler jplephem && \
#     find /opt/miniconda2 ! -perm /o=r -exec chmod o+rx {} \;

# install scikit
# RUN conda install -y -c menpo scikit-sparse && \
#   conda clean -a && \
#     find /opt/miniconda2 ! -perm /o=r -exec chmod o+rx {} \;

# install PTMCMCSampler
RUN git clone https://github.com/jellis18/PTMCMCSampler && \
    cd PTMCMCSampler && \
    python setup.py install && \
    cd .. && rm -rf PTMCMCSampler && \
    find /opt/miniconda2 ! -perm /o=r -exec chmod o+rx {} \;

# install PAL2 (do not remove it)
RUN git clone https://github.com/jellis18/PAL2.git && \
    cd PAL2 && \
    python setup.py install && \
    cp -rp demo /home/nanograv/PAL2-demo && chown -R nanograv /home/nanograv/PAL2-demo && \
    cd .. && rm -rf PAL2 && \
    find /opt/miniconda2 ! -perm /o=r -exec chmod o+rx {} \; && \
    find /home/nanograv ! -perm /o=r -exec chmod o+rx {} \;

# install NX01 (rather, check it out and copy it to the nanograv user)
RUN git clone https://github.com/stevertaylor/NX01.git && \
    cp -rp NX01 /home/nanograv/NX01 && chown -R nanograv /home/nanograv/NX01 && \
    find /home/nanograv ! -perm /o=r -exec chmod o+rx {} \;

# matplotlib rc (default backend: Agg)
RUN mkdir -p /home/nanograv/.config/matplotlib && chown -R nanograv /home/nanograv/.config 
COPY matplotlibrc /home/nanograv/.config/matplotlib
