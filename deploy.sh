#! /bin/bash
if [[ $TRAVIS_PULL_REQUEST == "false" ]]; then
  if [[ $TRAVIS_BRANCH == "master" ]]; then
    bundle exec nanoc --env=prod deploy public
  fi
else
  rsync -aglpPrtvz --delete output/ "deploy@$TRAVIS_PULL_REQUEST.zeus.werthen.com:/var/www/html/$TRAVIS_PULL_REQUEST/"
fi
