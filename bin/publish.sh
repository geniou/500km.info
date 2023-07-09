#!/bin/bash
bundle exec jekyll build && rsync -avz --delete _site/ ssh-w00f60fa@500km.info:/www/htdocs/w00f60fa/
