# Setup Gitlab Repository For Data Science
The concept for this repository is to build Gitlab environment for data Science.

This environment is based on poetry and you can use the following topics managed by poetry.
- pre-commit check
  - black, isort for python files and notebooks
  - flake8 for python files
  - pytest for python files

- CI/CD check
  - flake8 for python files
  - pytest for python files

Optionally, the setting of mypy also is discribed in `setup.cfg`. So if you add settings, you can use mypy and so on.

## Setup Process
It is constructed to devcontainer for Python and apt-get environment and poetry for Python packages.
You can make Python environment if you follow several steps.

### 0. Prepare package
This repository is used this package. You need to install them on your environment and VSCode.
- (rootless) docker
- Docker Desktop (If it is not exist, you can not use `Remote Container` and can use only docker command line.)
- VSCode Extension
  - Remote Container
  - Remote SSH

### 1. Set up Gitlab with [official site](https://docs.gitlab.com/ee/install/docker.html).

Firstly, you must work on new directory to escape for confuse on folders in this repository.
In typically, it is easily setup with using official docker image like below.
Please do the following commands in your terminal after setting `GITLAB_HOME` according to your OS. The detail is written on `Set up the volumes location`.

```bash
$ sudo docker run --detach \
    --hostname gitlab.example.com \
    --publish 443:443 --publish 80:80 --publish 22:22 \
    --name gitlab \
    --restart always \
    --volume $GITLAB_HOME/config:/etc/gitlab \
    --volume $GITLAB_HOME/logs:/var/log/gitlab \
    --volume $GITLAB_HOME/data:/var/opt/gitlab \
    --shm-size 256m \
    gitlab/gitlab-ee:latest
```
After this commands, gitlab server will start in your cpu environment.
Please check your `docker ps` commands with below command.

### 2. Using Devcontainer

#### 2.1 Clone Repository
Next, you clone this repository on work directory.
```
$ git clone gitlab.example.com project
$ cd project
$ (project/) ls
> README.md  models  poetry.lock pyproject.toml test ...
```
I explain about devcontainer under the condition that your position is `project` directory.
And reopen your VSCode so that your workspace is `project` directory. This process is need for using `Devcontainer extensions`.

#### 2.2 Using Devcontainer via VSCode
`Devcontainer` is the tool that we can build and run for Docker container using with VSCode extension function by GUI .
`.devcontainer` directory is contained that there are `Dockerfile` and `devcontainer.json`.
It is described in `devcontainer.json` about `docker build` ,`run` and `VSCode setting/extensions`.

If you work on remote server, you must change `"appPort"` arg in `.devcontainer/devcontainer.json` to `"appPort": ["{your ssh port num}:{your ssh port num}"`.
It must not be the same as any other container already in runing.

Step: 
  1. Click the green button in the lower left corner of the VSCode. If it installs correctly, you will see the list displayed above VSCode.
  2. So click `Reopen in Container` on the list.

Before execution, you need to check the folders to be mounted to the docker container and proxy settings in the dockerfile. It is dependent on your environment.

If all goes well, the screen on VSCode should be switched and the installation of poetry and pre-commit settings should be started working.

### 3. Gitlab account setting
In docker container, it does not have gitlab account information. So you need to register your account following commands.
```
$ git config --global user.name yoshihisa-furusawa
$ git config --global user.email XXXXX@YYYY.com
```

### 4. Using Notebook (Jupyter-Lab)
Pre-commit is install by pip so you need to activate `virtual environment` when you do `git commit` and `jupyter`, which is depend on python environment.
Alternatively, you need to add `poetry run` on the head of a command line.

```bash
$ poetry run jupyter-lab --port=7777 --ip=0.0.0.0 --allow-root
```

### Appendix A. Using docker except for devcontainer
In case of what you do not use `devcontainer` or VSCode, you can build and run following commands.
If you work and use docker on remote server, port number must be select the number which it is used ssh to it so that you open jupyter-lab on browser.

```bash
$ docker build .devcontainer/ -t project_name
$ docker run \
        --restart=always \
        --shm-size=16G \
        -v /path/to/work_dir:/root/project \
        -p 7777:7777 \
        -it project_name
```

### Appendix B. Using GPU
If you want to use GPU, you need to add this args to `.devcontainer/devcontainer.json` and `Dockerfile`. And it may be necessary to install `nvidia-container-runtime`  if you get an error `docker: Error response from daemon: could not select device driver "" with capabilities: [[gpu]].`.

#### In `.devcontainer/Dockerfile`
It needs to select image which be able to use nvidia-driver and cuda.
For example, it is `nvidia/cuda:11.6.0-cudnn8-runtime-ubuntu20.04`.
The kind of image must be selected according to host cuda version and GPU production.

```
FROM nvidia/cuda:11.6.0-cudnn8-runtime-ubuntu20.04
# FROM ubuntu:20.04
```

#### In `.devcontainer/devcontainer.json`
It needs to add `--gpus` args to `.devcontainer/devcontainer.json`.
```
  "runArgs": [
    "--gpus",
    "all",
    "--restart=always",
    "--shm-size=16G"
  ],
```

### Appendix C. Using docker under the Proxy
If you want to build under the proxy, you need to add below command to `.devcontainer/Dockerfile` ahead of `apt-get` commands.

```Dockerfile
ENV HTTP_PROXY "http://XXXXXXXXXX:YYYY"
ENV HTTPS_PROXY "http://XXXXXXXXXX:YYYY"
ENV http_proxy "http://XXXXXXXXXX:YYYY"
ENV https_proxy "http://XXXXXXXXXX:YYYY"

RUN echo PROXY="http://XXXXXXXXXX:YYYY" >> ~/.bashrc \
    && echo export HTTP_PROXY=\$PROXY >> ~/.bashrc \
    && echo export HTTPS_PROXY=\$PROXY >> ~/.bashrc \
    && echo export http_proxy=\$PROXY >> ~/.bashrc \
    && echo export https_proxy=\$PROXY >> ~/.bashrc
```

## Reference
This repository is based on the following there.

- mypy setting
  - [optuna/optuna](https://github.com/optuna/optuna/tree/master)
- issue template
  - [angular-translate/angular-translate](https://github.com/angular-translate/angular-translate/tree/master)

