package waifus

import (
	"log"
	"database/sql"
	"net/http"
	"encoding/json"
	"github.com/gorilla/context"
	"github.com/sarahjting/ww4w/models/waifus"
)

type PostWaifuResult struct {
	Status bool
	Waifus []waifus.Waifu
}

func PostWaifus(db *sql.DB) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		waifus := waifus.List(db, context.Get(r, "account_id").(int))
		js, err := json.Marshal(PostWaifuResult{
			Status: true,
			Waifus: waifus })
		if err != nil {
			log.Fatal(err)
		}
	  
		w.Header().Set("Content-Type", "application/json")
		w.Write(js)
	}
}