#!/bin/bash
printf "\e[0;34m\n%s\n==========\n\n\e[m" "GIT TO SVN"


URL=$1
printf "URL=$1\n"
TITLE='\e[1;33m\n%s\n-----------------------\e[m\n'


#clone
printf $TITLE "Cloning svn"
git svn clone ${URL} --no-metadata -A ~/authors-transform.txt --stdlayout temp

#gitignore
printf $TITLE "Create gitignore from svn-ignore"
cd temp
git svn show-ignore > .gitignore
git add .gitignore
git commit -m 'Convert svn:ignore properties to .gitignore.'
cd ..

#init bare
printf $TITLE "init bare repo"
git init --bare bare.git
cd bare.git/
git symbolic-ref HEAD refs/heads/trunk

#push to bare
printf $TITLE "push to bare repo"
cd ../temp
git remote add bare ../bare.git
git config remote.bare.push 'refs/remotes/*:refs/heads/*'
git push bare
cd ../bare.git/

#trunk -> master
printf $TITLE "Rename trunk to master"
git branch -m trunk master

#clean up branches and tags
printf $TITLE "Clean up"
git for-each-ref --format='%(refname)' refs/heads/tags | cut -d / -f 4 | while read ref; do   git tag "$ref" "refs/heads/tags/$ref";   git branch -D "tags/$ref"; done

printf '\e[1;32m%s\e[m\n' "Finished!"
printf "You can now do\n"
printf " git config user.name \"Jan Haensli\"\n"
printf " git config user.email \"jan@haens.li\"\n"
printf " git remote add origin [URL]\n"
printf " git push -u origin master\n\n"



