package main

import (
	"log"
	"net/http"

	"database/sql"
	_ "github.com/lib/pq"

	"github.com/sarahjting/willwork4waifu/config"
	"github.com/sarahjting/willwork4waifu/api"
)



func main() {
	config := config.GetConf()
	db, err := sql.Open("postgres", config.DBUrl)
	if(err != nil) {
		log.Fatal(err)
	}

	http.HandleFunc("/generate", api.GetGenerate())
	http.HandleFunc("/gacha", api.GetGacha(db))
	http.HandleFunc("/waifus", api.GetWaifus(db))

	log.Fatal(http.ListenAndServe(":8080", nil))
}