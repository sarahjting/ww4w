package canons

type Canon struct {
	MALType string
	MALID int
	Title string
	URL string
	ImageURL string
}

func MAL2Canon(malType string, mal map[string]interface{}) Canon {
	return Canon{ 
		MALType: malType,
		MALID: int(mal["mal_id"].(float64)), 
		Title: mal["title"].(string),  
		URL: mal["url"].(string),  
		ImageURL: mal["image_url"].(string)}
}