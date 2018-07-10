#! /bin/bash
echo "Pull Request: $TRAVIS_PULL_REQUEST"
echo "Branch: $TRAVIS_BRANCH"

if [[ $TRAVIS_PULL_REQUEST == "false" ]]; then
  if [[ $TRAVIS_BRANCH == "master" ]]; then
    bundle exec nanoc --env=prod deploy public
  fi
else
  rsync -e 'ssh -p 2222' -aglpPrtvz --delete output/ "zeuspr@herbert.ugent.be:/home/zeuspr/public/$TRAVIS_PULL_REQUEST/"
fi
