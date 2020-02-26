package cycles

import (
	"log"
	"database/sql"
	"net/http"
	"encoding/json"
	"github.com/gorilla/context"
	"github.com/sarahjting/ww4w/models/cycles"
)

type PostTagsResult struct {
	Status bool
	Error error
	Tags []string
}

func PostTags(db *sql.DB) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		var body = context.Get(r, "body").(map[string]interface{})
		if(body["tag"] == nil) {
			body["tag"] = "";
		}
		
		js, err := json.Marshal(PostTagsResult{
			Status: true,
			Tags: cycles.Tags(db, context.Get(r, "account_id").(int), body["tag"].(string)),
		})
		if err != nil {
			log.Fatal(err)
		}
		w.Header().Set("Content-Type", "application/json")
		w.Write(js)
	}
}