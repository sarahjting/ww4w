package waifus
import (
	"time"  
	"encoding/json"
	"math/rand"
	"net/http"
	"io/ioutil"
)

func getRandomElement(slice []interface{}) interface{} {
	n := rand.Int() % len(slice)
	return slice[n];
}
func getRandomString(slice []string) string {
	n := rand.Int() % len(slice)
	return slice[n];
}

func Generate() Waifu {
	// pick a random anime or manga
	rand.Seed(time.Now().Unix())
	animes := []string{"20899", "10087", "11741", "356", "22297", "34662", "33047", "38000", "33573", "31964", "18115", "4884"}
	mangas := []string{"1133", "116778", "46128", "25", "112115"}
	url := ""
	if(rand.Int() % 2 == 0) {
		anime := getRandomString(animes)
		url = "https://api.jikan.moe/v3/anime/" + anime + "/characters_staff"
	} else {
		manga := getRandomString(mangas)
		url = "https://api.jikan.moe/v3/manga/" + manga + "/characters"
	}
	
	// load anime/manga from jikan
	resp, _ := http.Get(url)
	defer resp.Body.Close()
	body, _ := ioutil.ReadAll(resp.Body)

	// parse the JSON
	var dat map[string]interface{}
	json.Unmarshal(body, &dat)

	// get a random character
	value := getRandomElement(dat["characters"].([]interface{})).(map[string]interface{})

	// create waifu
	return MAL2Waifu(value);
}