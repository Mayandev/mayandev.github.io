#!/bin/bash
hexo g -d
git add .
git commit -m "post"
git push