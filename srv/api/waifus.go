package api

import (
	"log"
	"database/sql"
	"net/http"
	// "net/url"
	"html/template"
	"encoding/json"
	"github.com/gorilla/context"

	"github.com/sarahjting/ww4w/models/waifus"
)

func PostWaifus(db *sql.DB) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		waifus := waifus.List(db, context.Get(r, "accountId").(int))
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

func PostGacha(db *sql.DB) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		waifu, _ := waifus.Gacha(db, context.Get(r, "accountId").(int))
		js, err := json.Marshal(waifu)
		if err != nil {
			log.Fatal(err)
		}
		w.Header().Set("Content-Type", "application/json")
		w.Write(js)
	}
}