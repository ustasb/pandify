# Pandify

- [pandify.com](http://pandify.com)
- Initial release: 09/13/2014
- Author: [Brian Ustas](http://brianustas.com)

A tool for creating a Spotify playlist from your favorite Pandora.com tracks.

It relies on [Pandata](http://github.com/ustasb/pandata).

It was featured on [Product Hunt on 10/08/2015](https://www.producthunt.com/posts/pandify).

The logo was created by Tahni Pierzga.

## Usage

First build the Pandify image:

    docker build -t ustasb/pandify .

Then run a PostgreSQL container:

    docker run --name pandify_postgres postgres:9.6.5-alpine

## Docker Development

    docker run \
        -p 3000:3000 \
        --link=pandify_postgres:db \
        -v $(pwd):/opt/pandify \
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
