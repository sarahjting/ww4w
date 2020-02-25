package cycles
import (
	"database/sql"
)

func Cancel(db *sql.DB, accountId int) (returnError error) {
	_, returnError = db.Query(`DELETE FROM cycles WHERE account_id = $1 AND is_ended = FALSE`, accountId)
	return
}	