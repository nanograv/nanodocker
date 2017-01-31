FROM gcc:4.9
WORKDIR /root/install

RUN useradd -ms /bin/bash nanograv

# make calceph
RUN wget -q http://www.imcce.fr/fr/presentation/equipes/ASD/inpop/calceph/calceph-2.3.2.tar.gz && \
    tar zxvf calceph-2.3.2.tar.gz && \
    cd calceph-2.3.2 && \
    ./configure --prefix=/usr/local && \
    make && make install && \
    cd .. && rm -rf calceph-2.3.2 calceph-2.3.2.tar.gz

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
RUN conda install -y matplotlib ipython jupyter notebook h5py mpi4py numexpr statsmodels astropy ephem && \
    conda clean -a

# Jupyter notebook access script
COPY run_jupyter.sh /opt/miniconda2/bin

# non-standard-Anaconda packages
RUN pip install healpy acor line_profiler

# install PAL2 (do not remove it)
RUN git clone https://github.com/jellis18/PAL2.git && \
    cd PAL2 && \
    python setup.py install && \
    cp -rp demo /home/nanograv/PAL2-demo && chown -R nanograv /home/nanograv/PAL2-demo && \
    cd .. && rm -rf PAL2

# install PTMCMCSampler
RUN git clone https://github.com/jellis18/PTMCMCSampler && \
    cd PTMCMCSampler && \
    python setup.py install && \
    cd .. && rm -rf PTMCMCSampler

# install LAPACK
RUN apt-get -y update && \
    apt-get -y install liblapack3 && \
    apt-get clean && \
    conda install -y -c menpo scikit-sparse && \
    conda clean -a

# install NX01 (rather, check it out and copy it to the nanograv user)
RUN git clone https://github.com/stevertaylor/NX01.git && \
    cp -rp NX01 /home/nanograv/NX01 && chown -R nanograv /home/nanograv/NX01 
