package canons

import (
	"log"
	"net/http"
	"encoding/json"
	"github.com/sarahjting/ww4w/models/canons"
	"database/sql"
)

type PostTopResults struct {
	Status bool
	Error error
	Canons []canons.Canon
}

func PostTop(db *sql.DB) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		canons := canons.Top(db)
		js, err := json.Marshal(PostTopResults{
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