package cycles

import (
	"log"
	"database/sql"
	"net/http"
	"encoding/json"
	"github.com/gorilla/context"
	"github.com/sarahjting/ww4w/models/accounts"
	"github.com/sarahjting/ww4w/models/cycles"
)

type PostCurrentResult struct {
	Status bool
	Error error
	Cycle cycles.Cycle
	Gems int
}

func PostCurrent(db *sql.DB) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		cycle := cycles.Current(db, context.Get(r, "account_id").(int))
		js, err := json.Marshal(PostCurrentResult{
			Status: true,
			Cycle: cycle,
			Gems: context.Get(r, "account").(accounts.Account).Gems,
		})
		if err != nil {
			log.Fatal(err)
		}
		w.Header().Set("Content-Type", "application/json")
		w.Write(js)
	}
}