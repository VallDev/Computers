package computer

import (
	"context"
	"database/sql"
	"fmt"
	"net/http"

	"github.com/gorilla/mux"
)

func InitRoutes(ctx context.Context, db *sql.DB, r *mux.Router) {

	//r := mux.NewRouter()

	r.HandleFunc("/", index)

	r.HandleFunc("/computers/", func(w http.ResponseWriter, r *http.Request) {
		switch r.Method {
		case http.MethodGet:
			getComputers(w, r, ctx, db)
		case http.MethodPost:
			addComputer(w, r, ctx, db)
		default:
			w.WriteHeader(http.StatusMethodNotAllowed)
			fmt.Fprintf(w, "Method not allowed")
			return
		}
	})

	r.HandleFunc("/computers/{idc}", func(w http.ResponseWriter, r *http.Request) {
		switch r.Method {
		case http.MethodGet:
			vars := mux.Vars(r)
			idc := vars["idc"]
			getComputerById(w, r, ctx, db, idc)
		default:
			w.WriteHeader(http.StatusMethodNotAllowed)
			fmt.Fprintf(w, "Method not alowed")
			return
		}
	})

	http.Handle("/", r)
}
