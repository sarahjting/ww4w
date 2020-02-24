package waifus

import (
	"database/sql"
	"net/http"
	"encoding/json"
	"github.com/gorilla/context"
	"github.com/sarahjting/ww4w/models/waifus"
)

type PostGachaResult struct {
	Status bool
	Waifu waifus.Waifu
	Gems int
	Error string
}

func PostGacha(db *sql.DB) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		var js []byte
		waifu, gems, err := waifus.Gacha(db, context.Get(r, "account_id").(int))
		if(err == nil) {
			js, _ = json.Marshal(PostGachaResult{
				Status: true,
				Gems: gems,
				Waifu: waifu,
			})
		} else {
			js, _ = json.Marshal(PostGachaResult{
				Status: false,
				Error: err.Error(),
			})
		}
		w.Header().Set("Content-Type", "application/json")
		w.Write(js)
	}
}