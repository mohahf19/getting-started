FROM --platform=amd64 nvidia/cuda:12.2.2-cudnn8-runtime-ubuntu22.04

LABEL maintainer "Mohamad Fakhouri <mohamad.fakhouri@epfl.ch>"

ENV DEBIAN_FRONTEND=noninteractive

# Install some necessary tools.
RUN apt-get update && apt-get install -y \
    bzip2 \
    ca-certificates \
    cmake \
    curl \
    git \
    htop \
    libssl-dev \
    libffi-dev \
    locales \
    openssh-server \
    openssh-client \
    rsync \
    sudo \
    tmux \
    screen \
    unzip \
    vim \
    wget \
    zsh \
    python3 \
    python3-pip \
    keychain \
    && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8


# install oh-my-zsh
# Uses "robbyrussell" theme (original Oh My Zsh theme)
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
RUN chsh -s /bin/zsh root

# Setup env
ENV PATH="usr/local/cuda/bin:${PATH}" \
    LD_LIBRARY_PATH="/usr/local/cuda/lib64"

# Make $PATH and $LD_LIBRARY PATH available to all users
RUN echo PATH="${PATH}" >> /etc/environment && \
    echo LD_LIBRARY_PATH="${LD_LIBRARY_PATH}" >> /etc/environment

# Seems like you need this to run Tensorflow and Jax together
RUN echo TF_FORCE_GPU_ALLOW_GROWTH='true' >> /etc/environment

# Set a password for the root
RUN echo 'root:root' | sudo chpasswd

# Create and configure user
ARG USER=fakhouri
ARG UID=237125
ARG GID=30133
ARG GROUP=MLO-unit
ENV SHELL=/bin/zsh
ENV HOME=/home/${USER}

RUN groupadd $GROUP -g $GID && \
    useradd -m -s $SHELL -N -u $UID -g $GID $USER && \
    echo "${USER}:${USER}" | chpasswd && \
    usermod -aG sudo,adm,root ${USER} && \
    chown -R ${USER}:${GROUP} ${HOME} && \
    echo "${USER}   ALL = NOPASSWD: ALL" > /etc/sudoers

USER $UID:$GID

RUN sudo cp -r /root/.oh-my-zsh /home/${USER}/.oh-my-zsh && \
    sudo cp /root/.zshrc /home/${USER}/.zshrc && \
    sudo chown -R ${USER}:${GROUP} /home/${USER}/.oh-my-zsh /home/${USER}/.zshrc

# Install pixi
RUN curl -fsSL https://pixi.sh/install.sh | bash

# Pixi autocomplete
RUN echo 'eval "$(pixi completion --shell zsh)"' >> ${HOME}/.zshrc


WORKDIR ${HOME}

ENTRYPOINT [ "/bin/zsh" ]