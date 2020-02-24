package accounts
import (
	"database/sql"
)

type Account struct {
	ID int
	Gems int
}

func GetByDeviceId(db *sql.DB, deviceId string) (account Account, err error) {
	var id float64
	var gems float64 = 0
	err = db.QueryRow(`SELECT id, gems FROM accounts WHERE device_id = $1`, deviceId).Scan(&id, &gems)
	if(err != nil) {
		err = db.QueryRow(`INSERT INTO accounts(device_id) VALUES($1) RETURNING id`, deviceId).Scan(&id)
	}
	account = Account {
		ID: int(id),
		Gems: int(gems),
	}
	return 
}	