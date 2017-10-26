FROM fedora:latest
MAINTAINER zwPapEr <zw.paper@gmail.com>

# Env
RUN echo "root:root" | chpasswd \
	cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN dnf install -y zsh mosh tmux openssh-server \
    net-tools iproute iputils telnet            \
    findutils procps                            \
    git man gcc gdb vim wget

RUN ssh-keygen -A
RUN sed -i 's/#Port/Port/g' /etc/ssh/sshd_config                    && \
    sed -i 's/#AddressFamily/AddressFamily/g' /etc/ssh/sshd_config  && \
    sed -i 's/#ListenAddress/ListenAddress/g' /etc/ssh/sshd_config  && \
    sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN usermod -s /usr/bin/zsh root 
	#setcap cap_net_raw+ep /usr/bin/ping


# Dev software
## Golang
RUN wget -O go.tgz https://redirector.gvt1.com/edgedl/go/go1.9.2.linux-amd64.tar.gz; \
	tar -C /usr/local -xzf go.tgz; \
	rm go.tgz; \
	export PATH="/usr/local/go/bin:$PATH"; \
	go version; \
	mkdir /root/golang;

ENV LANG en_US.UTF-8 \
	GOPATH /root/golang \
	PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p $GOPATH/src $GOPATH/bin 

WORKDIR /root

ADD env.rc /etc/env.rc
RUN chmod +x /etc/env.rc
