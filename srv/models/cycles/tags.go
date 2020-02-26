package cycles
import (
	"database/sql"
	"log"
)

func Tags(db *sql.DB, accountId int, query string) (tags []string) {
	var rows *sql.Rows
	var err error
	if(query != "") {
		rows, err = db.Query(`SELECT tag FROM tags WHERE account_id = $1 AND LOWER(tag) LIKE '%' || LOWER($2) || '%' ORDER BY tag ASC`, 
			accountId, query,
		)
	} else {
		rows, err = db.Query(`SELECT tag FROM tags WHERE account_id = $1 ORDER BY tag ASC`, 
			accountId, 
		)
	}
	if(err != nil) {
		log.Fatal(err)
	}
	defer rows.Close()
	for rows.Next() {
		var tag string
		err = rows.Scan(&tag)
		tags = append(tags, tag)
	}
	return
}	