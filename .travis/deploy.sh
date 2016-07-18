#!/bin/bash

if [[ $TRAVIS_BRANCH == 'master' ]]; then
  echo "Deploying site..."
  bundle exec nanoc deploy --target public
else
  echo "Not deploying."
fi
