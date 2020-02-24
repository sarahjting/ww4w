package api

import (
	"log"
	"database/sql"
	"net/http"
	// "net/url"
	"html/template"
	"encoding/json"
	"strconv"
	"github.com/sarahjting/willwork4waifu/models/waifus"
)

func getAccountId(r *http.Request) int {
	var v map[string]interface{}
	if err := json.NewDecoder(r.Body).Decode(&v); err != nil {
		log.Fatal(err);
	}
	accountId, _ := strconv.Atoi(v["id"].(string))
	return accountId
}

func GetWaifus(db *sql.DB) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		accountId := getAccountId(r)

		waifus := waifus.List(db, accountId)
		js, err := json.Marshal(waifus)
		if err != nil {
			log.Fatal(err)
		}
	  
		w.Header().Set("Content-Type", "application/json")
		w.Write(js)
	}
}

func GetGenerate() func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		waifu := waifus.Generate()
		t, _ := template.ParseFiles("waifu.html")
		t.Execute(w, waifu)
	}
}

func GetGacha(db *sql.DB) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		accountId := getAccountId(r)
		waifu, _ := waifus.Gacha(db, accountId)
		js, err := json.Marshal(waifu)
		if err != nil {
			log.Fatal(err)
		}
		w.Header().Set("Content-Type", "application/json")
		w.Write(js)
	}
}