package canons

import (
	"database/sql"
	"net/http"
	"encoding/json"
	"github.com/gorilla/context"
	"github.com/sarahjting/ww4w/models/canons"
)

type PostAddResult struct {
	Status bool
	Error string
	Canon canons.Canon
}

func PostAdd(db *sql.DB) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		var js []byte
		body := context.Get(r, "body").(map[string]interface{})
		canon, err := canons.Add(db, context.Get(r, "account_id").(int), int(body["mal_id"].(float64)), body["mal_type"].(string));
		if(err == nil) {
			js, _ = json.Marshal(PostAddResult{ Status: true, Canon: canon })
		} else {
			js, _ = json.Marshal(PostAddResult{ Status: false, Error: err.Error() })
		}
		w.Header().Set("Content-Type", "application/json")
		w.Write(js)
	}
}