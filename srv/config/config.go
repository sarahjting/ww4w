package config
import (
	"os"
	"fmt"
	"github.com/joho/godotenv"
)

type Config struct {
	Port string
	DBUrl string
}

type DBConfig struct {
	Name string
	Password string
	Host string
	Port string
	User string
	Url string
}

func env(key string, fallback string) string {
	godotenv.Load(".env")
	if os.Getenv(key) != "" {
		return os.Getenv(key)
	} else {
		return fallback
	}
}

func GetConf() *Config {
	return &Config{
		Port: env("PORT", "8080"),
		DBUrl: env("DATABASE_URL", fmt.Sprintf("postgres://%s:%s@%s:%s/%s?sslmode=disable", 
			env("DB_USER", "postgres"),
			env("DB_PASSWORD", ""),
			env("DB_HOST", "localhost"),
			env("DB_PORT", "5432"),
			env("DB_NAME", "w4w")))};
}
