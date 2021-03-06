package canons

import (
	"database/sql"
	"net/http"
	"io/ioutil"
	"encoding/json"
	"math/rand"
	"net/url"
)

func Top(db *sql.DB, malType string, search string) (canons []Canon) {
	getUrl := ""
	key := "top"
	if(search == "") {
		getUrl = "https://api.jikan.moe/v3/top/" + malType
	} else {
		getUrl = "https://api.jikan.moe/v3/search/" + malType + "?q=" + url.QueryEscape(search)
		key = "results"
	}
	resp, _ := http.Get(getUrl)
	defer resp.Body.Close()
	body, _ := ioutil.ReadAll(resp.Body)

	var dat map[string]interface{}
	json.Unmarshal(body, &dat)
	for _, x := range dat[key].([]interface{}) {
		var canonId int
		var canon Canon
		canon = MAL2Canon(malType, x.(map[string]interface{}))
		err := db.QueryRow(`SELECT id FROM canons WHERE canons.mal_id = $1 AND canons.mal_type = $2`, canon.MALID, malType).Scan(&canonId)
		if(err != nil) {
			_ = db.QueryRow(`INSERT INTO canons(mal_id, mal_type, title, image_url, url) VALUES($1, $2, $3, $4, $5) RETURNING id`,
				canon.MALID, canon.MALType, canon.Title, canon.ImageURL, canon.URL).Scan(&canonId)
		}
		canon.ID = canonId
		canons = append(canons, canon)
	}
	return
}	

func RandomTop(db *sql.DB) []Canon {
	malType := "anime"
	if(rand.Int() % 2 == 0) {
		malType = "manga"
	} 
	return Top(db, malType, "")
}	