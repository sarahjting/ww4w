package cycles
import (
	"database/sql"
)

func Current(db *sql.DB, accountId int) (cycle Cycle) {
	var id int
	var createdAt string
	var endedAt string
	var tag string
	var isEnded bool
	err := db.QueryRow(`SELECT cycles.id AS ID, cycles.created_at AS CreatedAt, cycles.ended_at AS EndedAt, tags.tag AS Tag, is_ended AS IsEnded
			FROM cycles 
			LEFT JOIN tags ON cycles.tag_id = tags.id
			WHERE cycles.account_id = $1 AND cycles.is_ended = FALSE`, 
			accountId,
		).Scan(&id, &createdAt, &endedAt, &tag, &isEnded)
	if(err == nil) {
		cycle = Cycle{ID:float64(id), CreatedAt: createdAt, EndedAt: endedAt, Tag: tag, IsEnded: isEnded}
	}
	return
}	