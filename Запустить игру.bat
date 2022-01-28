@echo off

git fetch
git checkout main
git pull

luajit lua/main.luaс