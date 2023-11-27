# zeus.ugent.be
[![Build Status](https://api.travis-ci.com/ZeusWPI/zeus.ugent.be.svg?branch=master)](https://travis-ci.com/github/ZeusWPI/zeus.ugent.be)
[![Code Climate](https://codeclimate.com/github/ZeusWPI/zeus.ugent.be.png)](https://codeclimate.com/github/ZeusWPI/zeus.ugent.be)
[![PageSpeed](https://pagespeed-badges.herokuapp.com/?url=zeus.ugent.be&strat=desktop&showStratLabel=true)](https://developers.google.com/speed/pagespeed/insights/?url=https%3A%2F%2Fzeus.ugent.be&tab=desktop)
[![PageSpeed](https://pagespeed-badges.herokuapp.com/?url=zeus.ugent.be&strat=mobile&showStratLabel=true)](https://developers.google.com/speed/pagespeed/insights/?url=https%3A%2F%2Fzeus.ugent.be&tab=mobile)

This repository contains the source code for [zeus.ugent.be](https://zeus.ugent.be), the website of Zeus WPI, the official student association of Informatics at Ghent University. The site is developed using [nanoc](https://github.com/nanoc/nanoc), which is actively developed by ex-Zeus member [ddfreyne](https://github.com/ddfreyne). The CSS framework used is [Bulma](https://bulma.io/). We primarily focus on using markdown for blogposts and events. Feel free to make a Pull Request with a blog post if you feel inspired and need an outlet!


## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

You will need Ruby (gem), yarn and pandoc (optional). Installation instructions are listed below.

* [Ruby](https://www.ruby-lang.org/en/documentation/installation/)
* [yarn](yarnpkg.com/en/docs/install)
* [pandoc](https://pandoc.org/installing.html) (optional, install if you want to see the reports)

### Installing

If bundler is not yet installed on your system, make sure to install it using the following command:

```bash
gem install bundler
```

In the root directory of the project, execute following commands

```bash
bundle install
yarn install
```

You will (momentarily) also need `pandoc` and `latex` to compile the reports from the board meetings. Refer to your OS package manager to install these things.

These will pull in all Ruby and Node.js dependencies. If everything goes well, you should be able to execute the following.

```bash
bundle exec nanoc live
```

Go to <http://localhost:3000> to view the site! When developing, the site gets regenerated when editing files. A simple refresh will show the new changes.

### Optional: install submodules

Our official meeting reports are added as a submodule so they update automatically. For normal development, it is not required to initialize these. But if you want to deploy to production (or test the report generation), you will have to initialize the submodule.

```bash
git submodule update --init --recursive
```

### Deploying

The latest and greatest builds on master get deployed automatically using [travis](https://travis-ci.org).

For manual deployment, run

```bash
# Build the site for production
bundle exec nanoc --env=prod

# Run checks
bundle exec nanoc --env=prod check --deploy

# Deploy it to the server
bundle exec nanoc deploy --target public --env=prod
```

If you want to deploy this on your own system for whatever reason, just serve the files using a webserver like nginx or Apache.

## Uploading media files

Before using mediafiles on the site, upload them via https://zeus.ugent.be/zeuswpi/, our own custom [uploading service](https://github.com/ZeusWPI/ZeusWPI). You'll receive the server-filename which is available at the aforementioned url.
The file must be less than 1MB!

To upload remove the . in action="./zeuswpi" in following code so it looks like this:
```
form id="upload" class="form" method="post" enctype="multipart/form-data" action="/zeuswpi" style="display: none;">
    <label class="file-upload">
```

## Submitting a Pull Request

Once you've submitted a PR, it will automatically be deployed to (PR#).pr.zeus.gent, for easier reviewing.

## Analytics

Analytics are powered by [Fathom](https://usefathom.com) and are available on <https://stats.zeus.gent>. These are only available to administrators with proper rights. These analytics are self hosted and provide only simple statistics for our information, without breaching your privacy.

## Built With

* [nanoc](https://github.com/nanoc/nanoc), static site generator
* [Bulma](https://bulma.io/), CSS framework

## Authors

See the list of [contributors](https://github.com/zeuswpi/zeus.ugent.be/contributors) who participated in this project.
