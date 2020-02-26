package canons
import (
	"log"
	"database/sql"
)

func List(db *sql.DB, accountId int) (canons []Canon) {
	rows, err := db.Query(`SELECT canons.mal_id AS MALID, canons.mal_type AS MALType, canons.title AS Title, canons.url AS URL, canons.image_url AS ImageURL
		FROM canons 
		JOIN account_canons ON canons.id = account_canons.canon_id
		WHERE account_canons.account_id = $1 
		ORDER BY canons.title ASC`, accountId)
	if(err != nil) {
		log.Fatal(err)
	}
	defer rows.Close()
	for rows.Next() {
		var MALType string
		var MALID int
		var Title string
		var URL string
		var ImageURL string
		err = rows.Scan(&MALID, &MALType, &Title, &URL, &ImageURL)
		if(err != nil) {
			log.Fatal(err)
		}
		canons = append(canons, Canon{MALID:float64(MALID), MALType: MALType, Title:Title, URL:URL, ImageURL:ImageURL})
	}
	return
}	