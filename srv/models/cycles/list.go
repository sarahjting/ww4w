package cycles
import (
	"database/sql"
	"log"
)

func List(db *sql.DB, accountId int) (cycles []Cycle) {
	rows, err := db.Query(`SELECT cycles.id AS ID, cycles.created_at AS CreatedAt, cycles.ended_at AS EndedAt, tags.tag AS Tag
		FROM cycles 
		LEFT JOIN tags ON cycles.tag_id = tags.id
		WHERE cycles.account_id = $1`, accountId)
	if(err != nil) {
		log.Fatal(err)
	}
	defer rows.Close()
	for rows.Next() {
		var id int
		var createdAt string
		var endedAt string
		var tag string
		err = rows.Scan(&id, &createdAt, &endedAt, &tag)
		if(err != nil) {
			log.Fatal(err)
		}
		cycles = append(cycles, Cycle{ID:float64(id), CreatedAt: createdAt, EndedAt: endedAt, Tag: tag})
	}
	return
}	