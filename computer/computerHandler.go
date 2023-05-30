package computer

import (
	"context"
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
)

func index(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		w.WriteHeader(http.StatusMethodNotAllowed)
		fmt.Fprintf(w, "Method not allowed")
		return
	}

	fmt.Fprintf(w, "Hello there %s", "visitor")
}

func getComputers(w http.ResponseWriter, r *http.Request, ctx context.Context, db *sql.DB) {
	err := getAllComputers(ctx, db)
	if err != nil {
		panic(err)
	}
	for _, comp := range computers {
		log.Println(comp.ToString())
	}
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(computers)
}

func addComputer(w http.ResponseWriter, r *http.Request, ctx context.Context, db *sql.DB) {

	err := json.NewDecoder(r.Body).Decode(computer)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		fmt.Fprintf(w, "%v", err)
		return
	}

	err = addOneComputer(ctx, db)
	if err != nil {
		panic(err)
	}
	fmt.Fprintf(w, "Computer was added")
	computerString := computer.ToString()
	fmt.Fprintf(w, computerString)
}

func getComputerById(w http.ResponseWriter, r *http.Request, ctx context.Context, db *sql.DB, idc string) {
	err := GetComputerByIdSql(ctx, db, idc)
	if err != nil {
		panic(err)
	}
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(&computer)
}
