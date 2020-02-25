package waifus

import (
	"log"
	"net/http"
	"html/template"
	"github.com/sarahjting/ww4w/models/waifus"
)

func GetGenerate() func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		waifu := waifus.Generate()
		t, err := template.ParseFiles("waifu.html")
		log.Println(err)
		t.Execute(w, waifu)
	}
}