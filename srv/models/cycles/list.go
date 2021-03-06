package cycles
import (
	"database/sql"
	"log"
)

func List(db *sql.DB, accountId int) (cycles []Cycle) {
	rows, err := db.Query(`SELECT cycles.id AS ID, cycles.created_at AS CreatedAt, cycles.ended_at AS EndedAt,  COALESCE(tags.tag, '') AS Tag, is_ended AS IsEnded
		FROM cycles 
		LEFT JOIN tags ON cycles.tag_id = tags.id
		WHERE cycles.account_id = $1 
			AND is_ended = TRUE
			AND cycles.created_at > NOW() - INTERVAL '1 WEEK'
		ORDER BY id DESC`, accountId)
	if(err != nil) {
		log.Fatal(err)
	}
	for rows.Next() {
		var id int
		var createdAt string
		var endedAt string
		var tag string
		var isEnded bool
		err = rows.Scan(&id, &createdAt, &endedAt, &tag, &isEnded)
		if(err != nil) {
			log.Fatal(err)
		}
		cycles = append(cycles, Cycle{ID:float64(id), CreatedAt: createdAt, EndedAt: endedAt, Tag: tag, IsEnded: isEnded})
	}
	return
}	