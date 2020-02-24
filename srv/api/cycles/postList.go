package cycles

import (
	"log"
	"database/sql"
	"net/http"
	"encoding/json"
	"github.com/gorilla/context"
	"github.com/sarahjting/ww4w/models/cycles"
)

type PostListResult struct {
	Status bool
	Error error
	Cycles []cycles.Cycle
}

func PostList(db *sql.DB) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		cycles := cycles.List(db, context.Get(r, "account_id").(int))
		js, err := json.Marshal(PostListResult{
			Status: true,
			Cycles: cycles,
		})
		if err != nil {
			log.Fatal(err)
		}
		w.Header().Set("Content-Type", "application/json")
		w.Write(js)
	}
}