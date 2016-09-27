# zeus.ugent.be
[![Build Status](https://travis-ci.org/ZeusWPI/zeus.ugent.be.svg?branch=master)](https://travis-ci.org/ZeusWPI/zeus.ugent.be)

## Setup

### Installation

```bash
bundle install
npm install
```

### Developing

```bash
bundle exec nanoc live
```
This will spawn a webserver, and automatically recompile the site
when files get changed.

### Deploying

The latest builds on master get deployed automatically using [travis](https://travis-ci.org).

For manual deployment, run

```bash
bundle exec nanoc deploy --target public
```

## Posts

Posts should be written in [kramdown](http://kramdown.gettalong.org/index.html), a markdown superset which has a very complete [syntax guide](http://kramdown.gettalong.org/syntax.html).

## Events

Example structure:

```
content/
  assets/
  events/
    15-16/
    16-17/
      battlebots/
        main.md
        intro.md
        codenight.md
        finale.md
      awk.md
      sed.md
      ruby.md
    index.erb
```

### Metadata

Every event is a `.md` file with the following metadata tags:

#### Required

* title: String
* time: Date
* location: String

#### Optional

* banner: URL

### Grouped events

If there's a series of events (for example summer code nights) these can be grouped by creating a folder containing a `main.md`, which will need the following metadata:

#### Required

* title: String

#### Optional

* location: String
* banner: URL

Other `.md` files made in that folder are sub-events which need to fit the [metadata description listed earlier](#metadata)
