#! /bin/bash
echo "Pull Request: $TRAVIS_PULL_REQUEST"
echo "Branch: $TRAVIS_BRANCH"

if [[ $TRAVIS_PULL_REQUEST == "false" ]]; then
  if [[ $TRAVIS_BRANCH == "master" ]]; then
    bundle exec nanoc --env=prod deploy public
  fi
else
  # TODO: Re-enable this when wildcard certs are okay for zeus.gent or zeuswpi.org
  # rsync -aglpPrtvz --delete output/ "deploy@$TRAVIS_PULL_REQUEST.zeus.werthen.com:/var/www/html/$TRAVIS_PULL_REQUEST/"
fi
