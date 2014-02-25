#!/bin/bash
bundle exec jekyll build && rsync -avz --delete _site/ 500km.info:/www/htdocs/w00f60fa/
