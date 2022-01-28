@echo off

git fetch
git checkout main
git pull

luajit.exe lua/main.luac
