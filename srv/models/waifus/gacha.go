package waifus
import (
	"database/sql"
)

func Gacha(db *sql.DB, accountId int) (returnWaifu Waifu, returnError error) {
	returnWaifu = Generate()
	row := db.QueryRow(`SELECT waifus.mal_id FROM waifus WHERE waifus.mal_id = $1`, returnWaifu.MALID)
	err := row.Scan()
	if(err != nil) {
		db.Query(`INSERT INTO waifus(mal_id, name, image_url, url) VALUES($1, $2, $3, $4)`,
		returnWaifu.MALID, returnWaifu.Name, returnWaifu.ImageURL, returnWaifu.URL)
	}
	db.Query(`INSERT INTO account_waifus(account_id, waifu_id) VALUES($1, $2)`, accountId, returnWaifu.MALID)
	return
}	