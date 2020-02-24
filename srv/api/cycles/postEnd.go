package cycles

import (
	"database/sql"
	"net/http"
	"encoding/json"
	"github.com/gorilla/context"
	"github.com/sarahjting/ww4w/models/cycles"
)

type PostEndResult struct {
	Status bool
	Gems int
	Error string
}

func PostEnd(db *sql.DB) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		gems, err := cycles.End(db, context.Get(r, "account_id").(int))
		var js []byte 
		if err == nil {
			js, _ = json.Marshal(PostEndResult{ Status: true, Gems: gems })
		} else {
			js, _ = json.Marshal(PostEndResult{ Status: false, Error: err.Error() })
		}
	  
		w.Header().Set("Content-Type", "application/json")
		w.Write(js)
	}
}