# zeus.ugent.be
[![Build Status](https://travis-ci.org/ZeusWPI/zeus.ugent.be.svg?branch=master)](https://travis-ci.org/ZeusWPI/zeus.ugent.be)

## Installation

```bash
bundle install
npm install
```

## Developing

```bash
bundle exec nanoc live
```
This will spawn a webserver, and automatically recompile the site
when files get changed.

## Deploying

The latest builds on master get deployed automatically using [travis](https://travis-ci.org).

For manual deployment, run

```bash
bundle exec nanoc deploy --target public
```
