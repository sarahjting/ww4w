package main

import (
	"log"
	"net/http"

	"database/sql"
	_ "github.com/lib/pq"
	"github.com/gorilla/context"
	"github.com/gorilla/mux"

	"encoding/json"

	"github.com/sarahjting/ww4w/config"
	"github.com/sarahjting/ww4w/api/waifus"
	"github.com/sarahjting/ww4w/api/cycles"
	"github.com/sarahjting/ww4w/models/accounts"
)

func parseAccountId(db *sql.DB) (func(next http.Handler) http.Handler) {
	return func (next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			var v map[string]interface{}
			if err := json.NewDecoder(r.Body).Decode(&v); err != nil {
				log.Fatal(err);
			}
			account, _ := accounts.GetByDeviceId(db, v["id"].(string))
			context.Set(r, "body", v)
			context.Set(r, "account", account)
			context.Set(r, "account_id", account.ID)
			next.ServeHTTP(w, r)
		})
	}
}

func main() {
	config := config.GetConf()
	db, err := sql.Open("postgres", config.DBUrl)
	if(err != nil) {
		log.Fatal(err)
	}    
	
	r := mux.NewRouter()
    r.HandleFunc("/api/waifus/generate", waifus.GetGenerate()).Methods("GET")
    r.HandleFunc("/api/waifus/gacha", waifus.PostGacha(db)).Methods("POST")
    r.HandleFunc("/api/waifus/list", waifus.PostWaifus(db)).Methods("POST")
    r.HandleFunc("/api/cycles/start", cycles.PostStart(db)).Methods("POST")
    r.HandleFunc("/api/cycles/end", cycles.PostEnd(db)).Methods("POST")
    r.HandleFunc("/api/cycles/list", cycles.PostList(db)).Methods("POST")
	http.Handle("/", r)
	
	r.Use(parseAccountId(db))

	log.Fatal(http.ListenAndServe(":8080", nil))
}