package canons

import (
	"log"
	"net/http"
	"encoding/json"
	"github.com/sarahjting/ww4w/models/canons"
	"github.com/gorilla/context"
	"database/sql"
)

type PostTopResults struct {
	Status bool
	Error error
	Canons []canons.Canon
}

func PostTop(db *sql.DB) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {

		body := context.Get(r, "body").(map[string]interface{})
		var canonList []canons.Canon
		search := ""
		if(body["search"] != nil) {
			search = body["search"].(string)
		}
		if(body["mal_type"] == nil) {
			canonList = canons.RandomTop(db)
		} else {
			canonList = canons.Top(db, body["mal_type"].(string), search)
		}

		js, err := json.Marshal(PostTopResults{
			Status: true,
			Canons: canonList,
		})
		if err != nil {
			log.Fatal(err)
		}
		w.Header().Set("Content-Type", "application/json")
		w.Write(js)
	}
}