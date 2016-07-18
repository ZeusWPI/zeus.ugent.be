#!/bin/bash

if [[ $TRAVIS_BRANCH == 'master' ]]
  bundle exec nanoc deploy --target public
fi
