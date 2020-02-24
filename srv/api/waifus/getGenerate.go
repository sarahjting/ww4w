package waifus

import (
	"net/http"
	"html/template"
	"github.com/sarahjting/ww4w/models/waifus"
)

func GetGenerate() func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		waifu := waifus.Generate()
		t, _ := template.ParseFiles("waifu.html")
		t.Execute(w, waifu)
	}
}