package cycles

import (
	"database/sql"
	"net/http"
	"encoding/json"
	"github.com/gorilla/context"
	"github.com/sarahjting/ww4w/models/cycles"
)

type PostStartResult struct {
	Status bool
	Error string
}

func PostStart(db *sql.DB) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		var js []byte
		err := cycles.Start(db, context.Get(r, "account_id").(int), context.Get(r, "body").(map[string]interface{}));
		if(err == nil) {
			js, _ = json.Marshal(PostStartResult{ Status: true })
		} else {
			js, _ = json.Marshal(PostEndResult{ Status: false, Error: err.Error() })
		}
		w.Header().Set("Content-Type", "application/json")
		w.Write(js)
	}
}