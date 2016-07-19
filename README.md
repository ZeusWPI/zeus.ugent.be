# zeus.ugent.be
[![Build Status](https://travis-ci.org/ZeusWPI/zeus.ugent.be.svg?branch=master)](https://travis-ci.org/ZeusWPI/zeus.ugent.be)

## Installation

```bash
bundle install
```

## Developing

In one session:
```bash
bundle exec guard
```
Guard will watch for file changes and automatically recompile the site

In another session:
```bash
bundle exec nanoc view
```

## Deploying

The latest builds on master get deployed automatically using [travis](https://travis-ci.org).

For manual deployment, run

```bash
bundle exec nanoc deploy --target public
```
