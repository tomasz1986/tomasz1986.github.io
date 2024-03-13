@echo off

if exist ".git\config" copy ".git\config" ".\"
rd /q /s ".git"
md ".git"
copy ".\config" ".git\"

git init
git config --global init.defaultBranch master
git add .
git commit --message "Initial commit"
git push --force --set-upstream origin master

pause
exit /b
