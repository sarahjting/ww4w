package canons 

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"io/ioutil"
	"strconv"
)

func Add(db *sql.DB, accountId int, malID float64, malType string) (canon Canon, returnError error) {
	var canonID int
	err := db.QueryRow(`SELECT canons.id FROM canons WHERE canons.mal_id = $1 AND canons.mal_type = $2`, malID, malType).Scan(&canonID)
	if(err != nil) {
		canon := loadCanon(malID, malType)
		err = db.QueryRow(`INSERT INTO canons(mal_id, mal_type, title, url, image_url) VALUES($1, $2, $3, $4, $5) RETURNING id`,
			canon.MALID, canon.MALType, canon.Title, canon.URL, canon.ImageURL).Scan(&canonID)
	}
	_, returnError = db.Query(`INSERT INTO account_canons(account_id, canon_id) VALUES($1, $2) ON CONFLICT DO NOTHING`, accountId, canonID)
	return
}	

func loadCanon(malID float64, malType string) (canon Canon) {
	if(malType != "manga" && malType != "anime") {
		return
	}
	url := "https://api.jikan.moe/v3/" + malType + "/" + strconv.FormatFloat(malID, 'g', 1, 64)
	
	// load anime/manga from jikan
	resp, _ := http.Get(url)
	defer resp.Body.Close()
	body, _ := ioutil.ReadAll(resp.Body)

	// parse the JSON
	var dat map[string]interface{}
	json.Unmarshal(body, &dat)
	canon = MAL2Canon(malType, dat);
	return
}
