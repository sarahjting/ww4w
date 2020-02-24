package main

import (
	"log"
	"net/http"

	"database/sql"
	_ "github.com/lib/pq"
	"github.com/gorilla/context"
	"github.com/gorilla/mux"

	"encoding/json"
	"strconv"

	"github.com/sarahjting/ww4w/config"
	"github.com/sarahjting/ww4w/api"
)

func parseAccountId(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		var v map[string]interface{}
		if err := json.NewDecoder(r.Body).Decode(&v); err != nil {
			log.Fatal(err);
		}
		accountId, _ := strconv.Atoi(v["id"].(string))
		context.Set(r, "accountId", accountId)
        next.ServeHTTP(w, r)
    })
}

func main() {
	config := config.GetConf()
	db, err := sql.Open("postgres", config.DBUrl)
	if(err != nil) {
		log.Fatal(err)
	}    
	
	r := mux.NewRouter()
    r.HandleFunc("/generate", api.GetGenerate()).Methods("GET")
    r.HandleFunc("/gacha", api.PostGacha(db)).Methods("POST")
    r.HandleFunc("/waifus", api.PostWaifus(db)).Methods("POST")
	http.Handle("/", r)
	
	r.Use(parseAccountId)

	log.Fatal(http.ListenAndServe(":8080", nil))
}