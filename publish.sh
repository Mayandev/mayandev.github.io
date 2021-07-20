#!/bin/bash
nvm use 12
hexo g -d
git add .
git commit -m "post"
git push