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

# Install micromamba
RUN curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj bin/micromamba
RUN mv bin/micromamba /usr/local/bin/micromamba
# Hook zsh to micromamba
RUN echo 'eval "$(micromamba shell hook -s zsh)"' >> /root/.zshrc

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

# # ===== Copy init files to /docker/ folder =====
RUN mkdir /docker
# COPY utils/* /docker/
COPY utils/entrypoint.sh /docker/entrypoint.sh
RUN chmod +x /docker/*.sh

CMD ["/bin/zsh"]

# copy oh-my-zsh config over to /docker/ folder
# so that it can be copied to scratch space
# inside entrypoint.sh
RUN cp -r /root/.oh-my-zsh/ /docker/.oh-my-zsh/
RUN cp -r /root/.zshrc /docker/.zshrc
RUN cp -r /root/.bashrc /docker/.bashrc
RUN cp -r /root/.profile /docker/.profile

# change to home directory
WORKDIR /root
ENTRYPOINT ["/docker/entrypoint.sh"]
# ENTRYPOINT ["/bin/zsh"]
