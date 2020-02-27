package waifus
import (
	"database/sql"
	"log"
)

func List(db *sql.DB, accountId int) (waifus []Waifu) {
	rows, err := db.Query(`SELECT waifus.mal_id AS MALID, waifus.name  AS Name, waifus.image_url AS ImageURL, waifus.url AS URL,
			canons.title AS Canon, canons.url AS CanonURL
		FROM waifus 
		JOIN account_waifus ON account_waifus.waifu_id = waifus.mal_id 
		JOIN canons ON waifus.canon_id = canons.id
		WHERE account_waifus.account_id = $1
		ORDER BY account_waifus.created_at DESC`, accountId)
	if(err != nil) {
		log.Fatal(err)
	}
	defer rows.Close()
	for rows.Next() {
		var malID int
		var name string
		var imageURL string
		var url string
		var canonURL string
		var canon string
		err = rows.Scan(&malID, &name, &imageURL, &url, &canon, &canonURL)
		if(err != nil) {
			log.Fatal(err)
		}
		waifus = append(waifus, Waifu{MALID:int(malID), Name: name, ImageURL: imageURL, URL: url, Canon: canon, CanonURL: canonURL})
	}
	return
}	