package waifus

import (
	"net/http"
	"html/template"
	"github.com/sarahjting/ww4w/models/waifus"
	"database/sql"
)

func GetGenerate(db *sql.DB) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		waifu := waifus.Generate(db, 0)
		t, _ := template.ParseFiles("waifu.html")
		t.Execute(w, waifu)
	}
}