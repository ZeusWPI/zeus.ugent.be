#!/bin/bash

if [[ $TRAVIS_BRANCH == 'master' ]]; then
  bundle exec nanoc deploy --target public
fi
