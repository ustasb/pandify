# Pandify

[pandify.com][1]

A tool for creating a Spotify playlist from your favorite Pandora.com tracks.

It relies on [Pandata][2].

Logo by Tahni Pierzga

## Usage

First build the Pandify.com image:

    docker build -t ustasb/pandify .

Then run a PostgreSQL container:

    docker run --name pandify_postgres postgres:9.4.0

## Docker Development

    docker run \
        -p 3000:3000 \
        --link=pandify_postgres:db \
        -v $(pwd):/srv/www/pandify.com \
        -e RAILS_ENV=development \
        -e SPOTIFY_CLIENT_ID=<fill-in> \
        -e SPOTIFY_CLIENT_SECRET=<fill-in> \
        --name pandify \
        ustasb/pandify

## Docker Production

    docker run \
        -p 3000:3000 \
        --link=pandify_postgres:db \
        -e RAILS_ENV=production \
        -e SPOTIFY_CLIENT_ID=<fill-in> \
        -e SPOTIFY_CLIENT_SECRET=<fill-in> \
        --name pandify \
        ustasb/pandify

[1]: http://pandify.com
[2]: http://github.com/ustasb/pandata
