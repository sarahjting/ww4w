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
	"github.com/sarahjting/ww4w/api/canons"
	"github.com/sarahjting/ww4w/api/cycles"
	"github.com/sarahjting/ww4w/models/accounts"
)

func parseAccountId(db *sql.DB) (func(next http.Handler) http.Handler) {
	return func (next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			if(r.Body != http.NoBody) {
				var v map[string]interface{}
				if err := json.NewDecoder(r.Body).Decode(&v); err != nil {
					log.Fatal(err);
				}
				account, _ := accounts.GetByDeviceId(db, v["id"].(string))
				context.Set(r, "body", v)
				context.Set(r, "account", account)
				context.Set(r, "account_id", account.ID)
			}
			next.ServeHTTP(w, r)
		})
	}
}

func allowCORS(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		next.ServeHTTP(w, r)
	});
}

func main() {
	config := config.GetConf()
	db, err := sql.Open("postgres", config.DBUrl)
	defer db.Close()
	
	if(err != nil) {
		log.Fatal(err)
	}    
	
	r := mux.NewRouter()

	r.HandleFunc("/generate", waifus.GetGenerate(db)).Methods("GET")
	
    r.HandleFunc("/api/waifus/gacha", waifus.PostGacha(db)).Methods("POST")
	r.HandleFunc("/api/waifus/list", waifus.PostWaifus(db)).Methods("POST")
	
    r.HandleFunc("/api/canons/list", canons.PostList(db)).Methods("POST")
	r.HandleFunc("/api/canons/top", canons.PostTop(db)).Methods("POST")
	r.HandleFunc("/api/canons/add", canons.PostAdd(db)).Methods("POST")
	r.HandleFunc("/api/canons/remove", canons.PostRemove(db)).Methods("POST")
	
    r.HandleFunc("/api/cycles/tags", cycles.PostTags(db)).Methods("POST")
    r.HandleFunc("/api/cycles/start", cycles.PostStart(db)).Methods("POST")
    r.HandleFunc("/api/cycles/end", cycles.PostEnd(db)).Methods("POST")
    r.HandleFunc("/api/cycles/cancel", cycles.PostCancel(db)).Methods("POST")
    r.HandleFunc("/api/cycles/list", cycles.PostList(db)).Methods("POST")
	r.HandleFunc("/api/cycles/current", cycles.PostCurrent(db)).Methods("POST")
	
	r.PathPrefix("/").Handler(http.FileServer(http.Dir("static")))
	http.Handle("/", r)
	
	r.Use(parseAccountId(db))
	r.Use(allowCORS)

	log.Fatal(http.ListenAndServe(":" + config.Port, nil))
}