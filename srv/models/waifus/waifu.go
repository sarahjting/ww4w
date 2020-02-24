package waifus

type Waifu struct {
	MALID float64
	Name string
	ImageURL string
	URL string
}

func MAL2Waifu(mal map[string]interface{}) Waifu {
	return Waifu{ 
		MALID: mal["mal_id"].(float64), 
		Name: mal["name"].(string),  
		URL: mal["url"].(string),  
		ImageURL: mal["image_url"].(string)}
}

func Waifu2Map(waifu Waifu) (out map[string]interface{}) {
	out["mal_id"] = waifu.MALID
	out["name"] = waifu.Name
	out["url"] = waifu.URL
	out["image_url"] = waifu.ImageURL
	return
}