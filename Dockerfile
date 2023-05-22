FROM golang:1.20-alpine AS BUILDER

#RUN go get github.com/gorilla/mux && go get github.com/go-sql-driver/mysql
#RUN go mod download github.com/gorilla/mux &&  go mod download github.com/gorilla/mux

RUN mkdir /build
RUN echo "...aqui...." && pwd
COPY . /build

WORKDIR /build

#RUN export GO111MODULE=on

#RUN export GOPROXY=direct
#&& export GOPROXY=https://gproxy.proxy.goog,direct

RUN cd /build
RUN echo "-----------------AQUI UBICACION--------------------" && pwd && ls -la

#RUN GOPROXY=https://gproxy.proxy.goog,direct
#RUN go get github.com/gorilla/mux && go get github.com/go-sql-driver/mysql


#RUN go mod download -mod=mod
RUN export GO111MODULE=on

RUN export GOPROXY=https://goproxy.cn
RUN go mod download && go mod verify

RUN GOOS=linux && GOARCH=amd64 && go build -v main.go
RUN echo "archivos despues de build main" && ls -la
RUN chmod +x main.go


#EXPOSE 8080

#ENTRYPOINT [ "./main" ]

FROM alpine:latest
WORKDIR /root/
COPY --from=BUILDER /build/main .
RUN echo "---aqui estoy en alpine-----" && pwd && ls -la
RUN chmod +x main
RUN echo "-------------observando donde esta e. ./main--------" && pwd && ls -la
EXPOSE 8080
CMD [ "./main" ]

