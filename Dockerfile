FROM ubuntu:20.10

ENV LANG C.UTF-8
RUN apt-get update
RUN apt-get install python3-pip -y
RUN pip3 install pick
WORKDIR /app
COPY . /app
RUN ./install-dotfiles -p dotfiles
# TODO: run installations inside install-dotfiles with extra flag for each file
RUN "./installations/linux/7. install zsh and ohmyzsh"
RUN "./installations/common/1. add global gitignore rules"
RUN apt-get install nano -y
RUN "./installations/common/3. set default git editor to nano"
ENTRYPOINT [ "zsh" ]
