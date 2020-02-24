package waifus
import (
	"database/sql"
	"errors"
)

func Gacha(db *sql.DB, accountId int) (returnWaifu Waifu, returnGems int, returnError error) {
	err := db.QueryRow(`UPDATE accounts SET gems = gems - 1 WHERE id = $1 AND gems > 0 RETURNING gems`, accountId).Scan(&returnGems)
	if(err != nil) {
		returnError = errors.New("Insufficient gems.")
		return
	}
	returnWaifu = Generate()
	err = db.QueryRow(`SELECT waifus.mal_id FROM waifus WHERE waifus.mal_id = $1`, returnWaifu.MALID).Scan()
	if(err != nil) {
		db.Query(`INSERT INTO waifus(mal_id, name, image_url, url) VALUES($1, $2, $3, $4)`,
			returnWaifu.MALID, returnWaifu.Name, returnWaifu.ImageURL, returnWaifu.URL)
	}
	db.Query(`INSERT INTO account_waifus(account_id, waifu_id) VALUES($1, $2)`, accountId, returnWaifu.MALID)
	return
}	