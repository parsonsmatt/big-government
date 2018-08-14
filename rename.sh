#!/usr/bin/env zsh

echo Renaming all instances of lib-template to: $1
sed -i "s/lib-template/$1/g" **/*.{yaml,hs,md}

echo Deleting the Git directory
rm -rf .git

echo Deleting the old cabal file
rm lib-template.cabal

echo Initializing the new Git directory
git init
