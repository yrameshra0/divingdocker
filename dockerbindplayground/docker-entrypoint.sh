#!/bin/bash
set -e

if [ "$JEKYLL_NEW" = true ]; then
    echo "NOTE: Making new jekyll site"
    jekyll new .
fi

if [ ! -f Gemfile ]; then
    echo "Please check you bind mount as no jekyll site was found"
    exit 1
fi

bundle install

exec "$@"