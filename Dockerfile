FROM ubuntu:20.10

ENV LANG C.UTF-8
RUN apt-get update
RUN apt-get install python3-pip nano -y
RUN pip3 install pick
WORKDIR /app
COPY . /app
RUN ./install-dotfiles dotfiles
ENTRYPOINT [ "zsh" ]
