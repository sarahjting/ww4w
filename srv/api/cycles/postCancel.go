package cycles

import (
	"database/sql"
	"net/http"
	"encoding/json"
	"github.com/gorilla/context"
	"github.com/sarahjting/ww4w/models/cycles"
)

type PostCancelResult struct {
	Status bool
	Error string
}

func PostCancel(db *sql.DB) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		var js []byte
		err := cycles.Cancel(db, context.Get(r, "account_id").(int));
		if(err == nil) {
			js, _ = json.Marshal(PostCancelResult{ Status: true })
		} else {
			js, _ = json.Marshal(PostCancelResult{ Status: false, Error: err.Error() })
		}
		w.Header().Set("Content-Type", "application/json")
		w.Write(js)
	}
}