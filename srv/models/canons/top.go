package canons

import (
	"net/http"
	"math/rand"
	"io/ioutil"
	"encoding/json"
)

func Top() (canons []Canon) {
	url := ""
	malType := "anime"
	if(rand.Int() % 2 == 0) {
		url = "https://api.jikan.moe/v3/top/anime"
	} else {
		url = "https://api.jikan.moe/v3/top/manga"
		malType = "manga"
	}
	
	resp, _ := http.Get(url)
	defer resp.Body.Close()
	body, _ := ioutil.ReadAll(resp.Body)

	var dat map[string]interface{}
	json.Unmarshal(body, &dat)
	for _, x := range dat["top"].([]interface{}) {
		canons = append(canons, MAL2Canon(malType, x.(map[string]interface{})));
	}
	return
}	