package main

import (
	"Computers/computer"
	"context"
	"database/sql"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"

	"github.com/gorilla/mux"
)

func main() {

	db, err := computer.CreateConnection()
	if err != nil {
		panic(err)
	}

	// variable de context
	ctx := context.Background()

	/*err = computer.GetComputerById(ctx, db)
	if err != nil {
		panic(err)
	}*/
	//las siguientes dos linea spermiten que el sistema se siga ejecutando y no se pause

	serverDoneChan := make(chan os.Signal, 1)

	signal.Notify(serverDoneChan, os.Interrupt, syscall.SIGTERM)

	myComputerApi := NewConnection(":8080", ctx, db)

	// go routine
	go func() {
		// se inicia el servidor
		err := myComputerApi.ListenAndServe()
		if err != nil {
			panic(err)
		}
	}()

	log.Println("server started")

	//esto espera a que nuestro server reciba una señal
	<-serverDoneChan

	// una vez que reciba las señales la go routnine se sigue con la ejecución
	myComputerApi.Shutdown(ctx)
	log.Println("server stopped")


	db.Close()
}

func NewConnection(addr string, ctx context.Context, db *sql.DB) *http.Server {

	r := mux.NewRouter()
	computer.InitRoutes(ctx, db, r)

	return &http.Server{
		Addr:    addr,
		Handler: r,
	}
}
