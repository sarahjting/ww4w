package waifus

type Waifu struct {
	MALID int
	Name string
	ImageURL string
	URL string
	CanonID int
	CanonURL string
	Canon string
}

func MAL2Waifu(mal map[string]interface{}) Waifu {
	return Waifu{ 
		MALID: int(mal["mal_id"].(float64)), 
		Name: mal["name"].(string),  
		URL: mal["url"].(string),  
		ImageURL: mal["image_url"].(string)}
}