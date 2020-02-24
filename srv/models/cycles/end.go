package cycles
import (
	"database/sql"
	"errors"
)

func End(db *sql.DB, accountId int) (gems int, returnError error) {
	res, err := db.Exec(`UPDATE cycles SET ended_at = NOW() WHERE account_id = $1 AND ended_at IS NULL AND NOW() - created_at >= INTERVAL '25 MINUTE'`, accountId)
	if(err != nil) {
		returnError = err
		return
	}
	rows, err := res.RowsAffected()
	if(err != nil) {
		returnError = err
		return
	}
	if(rows != 1) {
		returnError = errors.New("Cycle is not ready to complete.")
		return
	}

	db.QueryRow(`UPDATE accounts SET gems = gems + 1 WHERE id = $1 RETURNING gems`, accountId).Scan(&gems)
	return
}	