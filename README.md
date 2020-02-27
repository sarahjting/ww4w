<p align="center">
    <img src="https://github.com/sarahjting/ww4w/blob/master/readme/logo.png?raw=true" height="150">
</p>

# WILL WORK FOR WAIFUS

This was made during my time as a student at Code Chrysalis!

Have trouble concentrating on work? Spend too much money on lootboxes? Not anymore! WW4W will solve all your bad habits. A work cycle tracker that rewards you with gacha so you can collect your favourite waifus. Don't stop working until you have all your best girls!

Check out the deployed app on heroku: https://ww4w.herokuapp.com/

Just want a waifu generator? https://ww4w.herokuapp.com/generate

# Screenshots

<p align="center">
    <img src="https://github.com/sarahjting/ww4w/blob/master/readme/screenshot_home.png?raw=true" height="300"> 
    <img src="https://github.com/sarahjting/ww4w/blob/master/readme/screenshot_gacha.png?raw=true" height="300">
</p>

# Building the server

1. Install [go](https://golang.org/doc/install) if you haven't yet done so.
1. If required, please `cp .env.default .env` and fill `.env` in with new environment variables.
1. Migrate database tables.

```
psql --file=./srv/data/01.up.sql
```

4. Build server:

```
cd srv && go build && cd ..
```

5. Put server up:

```
./srv/ww4w
```

6. A web build of the app's included at `http://localhost:8080/` by default.

# Building the app

1. Install [flutter](https://flutter.dev/docs/get-started/install) if you haven't yet done so.
1. If required, `cp .env.default .env` and point your app to your server.
1. Build to platform of choice using `flutter build [platform]`.
1. You can serve your web build with the server running off localhost by copying a web build into `srv/static`; this will serve the client at `http://localhost:8080/`:

```
cd app && flutter build web && cd .. && cp -r app/build/web/* srv/static/
```

# Technologies

- **Server:** Go, Postgres
- **App:** Dart, Flutter
- **Third-party:** [Jikan API](https://jikan.moe/) (MyAnimeList API)
