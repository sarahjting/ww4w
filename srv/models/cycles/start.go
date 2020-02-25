package cycles
import (
	"database/sql"
	"strings"
	"log"
)

func Start(db *sql.DB, accountId int, data map[string]interface{}) (returnError error) {
	var tagId int = 0
	db.Query(`DELETE FROM cycles WHERE account_id = $1 AND is_ended = FALSE`, accountId)
	var tag string = strings.TrimSpace(data["tag"].(string));
	if(tag != "") {
		row := db.QueryRow(`SELECT id FROM tags WHERE account_id = $1 AND tag = $2`, accountId, tag)
		if err := row.Scan(&tagId); err != nil {
			err := db.QueryRow(`INSERT INTO tags(account_id, tag) VALUES($1, $2) RETURNING id`, accountId, tag).Scan(&tagId)
			if(err != nil) {
				log.Fatal(err)
			}
		} 
	}
	db.Query(`INSERT INTO cycles(account_id, tag_id) VALUES($1, $2)`, accountId, tagId)
	return
}	