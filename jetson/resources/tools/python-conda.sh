conda_version="4.11.0"
# Miniforge installer patch version
miniforge_patch_number="0"
# Miniforge installer architecture
miniforge_arch="aarch64"
# Python implementation to use 
# can be either Miniforge3 to use Python or Miniforge-pypy3 to use PyPy
miniforge_python="Miniforge3"

# Miniforge archive to install
miniforge_version=${conda_version}-${miniforge_patch_number}
# Miniforge installer
miniforge_installer=${miniforge_python}-${miniforge_version}-Linux-${miniforge_arch}.sh

miniforge_checksum=$(wget -qO- https://github.com/conda-forge/miniforge/releases/download/${miniforge_version}/${miniforge_installer}.sha256)

CONDA_DIR=/opt/miniforge 
export PATH=$CONDA_DIR/bin:$PATH
CONDA_VERSION="${conda_version}"
MINIFORGE_VERSION="${miniforge_version}"
PYTHON_VERSION=default
# Prerequisites installation: conda, pip, tini
# Prerequisites installation: conda, pip, tini

if [[ ! -d $CONDA_DIR ]]; then

wget "https://github.com/conda-forge/miniforge/releases/download/${miniforge_version}/${miniforge_installer}" && \
    echo "${miniforge_checksum}" | sha256sum --check && \
    rm -rf $CONDA_DIR  && \
    /bin/bash "${miniforge_installer}" -f -b -p $CONDA_DIR && \
    rm "${miniforge_installer}" && \
    # Conda configuration see https://conda.io/projects/conda/en/latest/configuration.html
    echo "conda ${CONDA_VERSION}" >> $CONDA_DIR/conda-meta/pinned && \
    conda config --system --set auto_update_conda false && \
    conda config --system --set show_channel_urls true && \
    if [ ! $PYTHON_VERSION = 'default' ]; then conda install --yes python=$PYTHON_VERSION; fi && \
    conda list python | grep '^python ' | tr -s ' ' | cut -d '.' -f 1,2 | sed 's/$/.*/' >> $CONDA_DIR/conda-meta/pinned && \
    conda install --quiet --yes \
    "conda=${CONDA_VERSION}" \
    'pip' \
    'tini=0.18.0' && \
    conda update --all --quiet --yes && \
    conda list tini | grep tini | tr -s ' ' | cut -d ' ' -f 1,2 >> $CONDA_DIR/conda-meta/pinned && \
    conda clean --all -f -y && \
    rm -rf $HOME/.cache/yarn && \ 
    conda init

fi