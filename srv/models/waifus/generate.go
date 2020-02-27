package waifus
import (
	"time"  
	"encoding/json"
	"math/rand"
	"net/http"
	"io/ioutil"
	"github.com/sarahjting/ww4w/models/canons"
	"database/sql"
	"strconv"
)

func getRandomElement(slice []interface{}) interface{} {
	n := rand.Int() % len(slice)
	return slice[n];
}
func getRandomString(slice []string) string {
	n := rand.Int() % len(slice)
	return slice[n];
}

func Generate(db *sql.DB, accountId int) Waifu {
	rand.Seed(time.Now().Unix())

	// load canon list
	canonList := canons.List(db, accountId)
	if(canonList == nil) {
		canonList = canons.Top(db)
	}

	// grab a random canon
	n := rand.Int() % len(canonList)
	canon := canonList[n];
	
	// load anime/manga from jikan
	url := "";
	if(canon.MALType == "anime") {
		url = "https://api.jikan.moe/v3/anime/" + strconv.Itoa(canon.MALID) + "/characters_staff"
	} else {
		url = "https://api.jikan.moe/v3/manga/" + strconv.Itoa(canon.MALID) + "/characters"
	}
	resp, _ := http.Get(url)
	defer resp.Body.Close()
	body, _ := ioutil.ReadAll(resp.Body)

	// parse the JSON
	var dat map[string]interface{}
	json.Unmarshal(body, &dat)

	// get a random character
	value := getRandomElement(dat["characters"].([]interface{})).(map[string]interface{})

	// create waifu
	waifu := MAL2Waifu(value)
	waifu.CanonID = canon.ID
	waifu.CanonURL = canon.URL
	waifu.Canon = canon.Title
	return waifu
}