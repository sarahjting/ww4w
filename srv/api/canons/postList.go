package canons

import (
	"log"
	"database/sql"
	"net/http"
	"encoding/json"
	"github.com/gorilla/context"
	"github.com/sarahjting/ww4w/models/canons"
)

type PostListResult struct {
	Status bool
	Error error
	Canons []canons.Canon
}

func PostList(db *sql.DB) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		canons := canons.List(db, context.Get(r, "account_id").(int))
		js, err := json.Marshal(PostListResult{
			Status: true,
			Canons: canons,
		})
		if err != nil {
			log.Fatal(err)
		}
		w.Header().Set("Content-Type", "application/json")
		w.Write(js)
	}
}