# Pandify

[pandify.com][1]

A tool for creating a Spotify playlist from your favorite Pandora.com tracks.

It relies on [Pandata][2].

Logo by Tahni Pierzga

## Docker Production Deploy

Build the Pandify.com image:

    docker build -t ustasb/pandify .

Run a PostgreSQL container:

    docker run -d --name pandify_postgres postgres:9.4.0

Run the Pandify.com container:

    docker run -p 3000:3000 --link=pandify_postgres:db --name pandify -d ustasb/pandify

[1]: http://pandify.com
[2]: http://github.com/ustasb/pandata
