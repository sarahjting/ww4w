package canons

import (
	"database/sql"
)

func Remove(db *sql.DB, accountId int, malID float64, malType string) (returnError error) {
	_, returnError = db.Query(`DELETE FROM account_canons
		USING canons 
		WHERE account_canons.account_id = $1 AND account_canons.canon_id = canons.id AND canons.mal_type = $2 AND canons.mal_id = $3`, 
		accountId, malType, malID)
	return
}	