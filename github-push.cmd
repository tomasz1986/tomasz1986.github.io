@echo off

git add .
git commit -C HEAD
git push --force
REM git show

pause
exit /b
