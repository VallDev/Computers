#Jus doing a comment from VM of Jenkins

FROM golang:1.20

#RUN go get github.com/gorilla/mux && go get github.com/go-sql-driver/mysql
#RUN go mod download github.com/gorilla/mux &&  go mod download github.com/gorilla/mux

RUN mkdir /build
COPY . /build

WORKDIR /build

#RUN export GO111MODULE=on

#RUN export GOPROXY=direct
#&& export GOPROXY=https://gproxy.proxy.goog,direct


RUN cd /build

#RUN GOPROXY=https://gproxy.proxy.goog,direct
#RUN go get github.com/gorilla/mux && go get github.com/go-sql-driver/mysql


#RUN go mod download -mod=mod
RUN export GO111MODULE=on

RUN export GOPROXY=https://goproxy.cn
RUN go mod download

RUN GOOS=linux && GOARCH=amd64 && go build main.go
RUN chmod +x main.go

EXPOSE 8080

ENTRYPOINT [ "./main" ]


