# WILL WORK FOR WAIFUS

This was made during my time as a student at Code Chrysalis!

Have trouble concentrating on work? Spend too much money on lootboxes? Not anymore! WW4W will solve all your bad habits. A work cycle tracker that rewards you with gacha so you can collect your favourite waifus. Don't stop working until you have all your best girls!

# Installation

1. Install [go](https://golang.org/doc/install) if you haven't yet done so.
1. Migrate database tables.

```
psql --file=./srv/data/01.up.sql
```

3. Build server files.

```
cd srv && go build && cd ..
```

4. If required, please `cp .env.default .env` and fill `.env` in with new environment variables.
1. Put server up.

```
./srv/ww4w
```

6. Check out the waifu generator at `http://localhost:8080/generate`

# Building the frontend

1. Install [flutter](https://flutter.dev/docs/get-started/install) if you haven't yet done so.
1. Point `.env` to your backend.
1. Build to platform of choice using `flutter build [platform]`.
1. You can build a web application running off localhost by copying a web build into `srv/static`; this will serve the client at `http://localhost:8080/`:

```
cd app && flutter build web && cd .. && cp -r app/build/web/* srv/static/
```
