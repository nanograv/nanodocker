FROM gcc:4.9
WORKDIR /root/install

RUN useradd -ms /bin/bash nanograv

# make tempo2
RUN wget -q https://bitbucket.org/psrsoft/tempo2/get/master.tar.gz && \
    tar zxf master.tar.gz && \
    cd psrsoft-tempo2-* && \
    ./bootstrap && \    
    ./configure --prefix=/usr/local && \
    make && make install && \
    mkdir /usr/local/share/tempo2 && \
    cp -Rp T2runtime/* /usr/local/share/tempo2/. && \
    cd .. && rm -rf psrsoft-tempo2-* master.tar.gz

# install miniconda
RUN wget -q https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh && \
    bash Miniconda2-latest-Linux-x86_64.sh -b -p /opt/miniconda2 && \
    rm Miniconda2-latest-Linux-x86_64.sh

ENV PATH="/opt/miniconda2/bin:${PATH}"

# install basic Python packages
RUN conda install -y numpy cython scipy && \
    conda clean -a

# install libstempo (before other Anaconda packages, esp. matplotlib, so there's no libgcc confusion)
RUN git clone https://github.com/vallis/libstempo.git && \
    cd libstempo && \
    python setup.py install --with-tempo2=/usr/local && \
    cp -rp demo /home/nanograv/libstempo-demo && chown -R nanograv /home/nanograv/libstempo-demo && \
    cd .. && rm -rf libstempo

# install more Python packages
RUN conda install -y matplotlib ipython jupyter notebook h5py mpi4py numexpr statsmodels astropy ephem line_profiler && \
    conda clean -a

# Jupyter notebook access script
COPY run_jupyter.sh /opt/miniconda2/bin

# non-standard-Anaconda packages
RUN pip install healpy acor

# install PAL2 (do not remove it)
RUN git clone https://github.com/jellis18/PAL2.git && \
    cd PAL2 && \
    python setup.py install && \
    cp -rp demo /home/nanograv/PAL2-demo && chown -R nanograv /home/nanograv/PAL2-demo && \
    cd .. && rm -rf PAL2
