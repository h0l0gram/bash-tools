#!/bin/bash
#
#Git prompt
#Author: Jan Hänsli jan@haens.li
#Makes you a nice git prompt when in a git repository
#
#call "ginfo" for symbol explanation
#

#printf "\e[0;36mJan Haensli\n"
#echo -e "\033[0;36mJan Haensli"
R="\e[0;37m"

TITLE_COLOR="\e[0;36m"
SYMBOL_SPACE= 
AHEAD_SYMBOL=↑${SYMBOL_SPACE}
AHEAD_COLOR="\e[0;32m"
BEHIND_SYMBOL=↓${SYMBOL_SPACE}
BEHIND_COLOR="\e[0;31m"
UPTODATE_SYMBOL=✔${SYMBOL_SPACE}
UPTODATE_COLOR="\e[0;32m"
UNTRACKED_SYMBOL=★${SYMBOL_SPACE}
UNTRACKED_COLOR="\e[0;33m"
STAGED_SYMBOL=⚑${SYMBOL_SPACE}
STAGED_COLOR="\e[01;33m"
DIRTY_SYMBOL=∴${SYMBOL_SPACE}
DIRTY_COLOR="\e[0;35m"
BRANCH_COLOR="\e[1;37m"
BRANCH_SYMBOL="\e[0;36m"→${SYMBOL_SPACE}$R
UPSTREAM_COLOR="\e[1;37m"


function ginfo(){
printf "\n${TITLE_COLOR}Git Prompt v1.0.0$R
  Author: Jan Haensli
  https://github.com/h0l0gram/bash-tools

Symbols:
  ${AHEAD_COLOR}${AHEAD_SYMBOL}: commits ahead
  ${BEHIND_COLOR}${BEHIND_SYMBOL}: commits behind
  ${UPTODATE_COLOR}${UPTODATE_SYMBOL}: up to date
  ${STAGED_COLOR}${STAGED_SYMBOL}: staged files
  ${DIRTY_COLOR}${DIRTY_SYMBOL}: modified files (unstaged)
  ${UNTRACKED_COLOR}${UNTRACKED_SYMBOL}: untracked files
"
}

function parse_git_status() {
	DIVERGE_PATTERN="Your branch and '(.*)' have diverged,"
	DIVERGE_PATTERN2="and have ([0-9]+) and ([0-9]+)"
	BRANCH_PATTERN="^On branch ([^${IFS}]*)"
	DIRTY_PATTERN=`git diff --numstat | wc -l`
	STAGED_PATTERN=`git diff --cached --numstat | wc -l`
	AHEAD_PATTERN="ahead of '(.*)'.* ([0-9]+) commit"
	BEHIND_PATTERN="behind '(.*)'.* ([0-9]+) commit"
	UNTRACKED_PATTERN=`git status -u -s | grep ^?? | wc -l`
	UPTODATE_PATTERN="up-to-date with '(.*)'"

	git_dirty="$(git diff --numstat | wc -l)"
	git_staged="$(git diff --cached --numstat | wc -l)"
	git_status="$(git status 2> /dev/null)"

    if [[ ${git_status} =~ ${BRANCH_PATTERN} ]]; then
        branch=${BRANCH_COLOR}${BASH_REMATCH[1]}
    fi

    if [[ ${git_status} =~ ${AHEAD_PATTERN} ]]; then
        upstream=${BASH_REMATCH[1]}
        ahead= ${AHEAD_COLOR}${AHEAD_SYMBOL}${BASH_REMATCH[2]}
	fi

    if [[ ${git_status} =~ ${BEHIND_PATTERN} ]]; then
        upstream=${BASH_REMATCH[1]}
        behind= ${BEHIND_COLOR}${BEHIND_SYMBOL}${BASH_REMATCH[2]}
    fi
    if [[ ${git_status} =~ ${DIVERGE_PATTERN} ]]; then
        upstream=${BASH_REMATCH[1]}
        if [[ ${git_status} =~ ${DIVERGE_PATTERN2} ]]; then
            ahead=" ${AHEAD_COLOR}${AHEAD_SYMBOL}${BASH_REMATCH[1]}"
            behind=" ${BEHIND_COLOR}${BEHIND_SYMBOL}${BASH_REMATCH[2]}"
        fi
    fi
    if [[ ${git_status} =~ ${UPTODATE_PATTERN} ]]; then
	upstream=${BASH_REMATCH[1]}
	uptodate="${UPTODATE_COLOR}${UPTODATE_SYMBOL} "
    fi
    if [[ $DIRTY_PATTERN -gt 0 ]]; then
        dirty= ${DIRTY_COLOR}${DIRTY_SYMBOL}$DIRTY_PATTERN
    fi
    if [[ $STAGED_PATTERN -gt 0 ]]; then
        staged= ${STAGED_COLOR}${STAGED_SYMBOL}$STAGED_PATTERN
    fi
    if [[ $UNTRACKED_PATTERN -gt 0 ]]; then
        untracked= ${UNTRACKED_COLOR}${UNTRACKED_SYMBOL}$UNTRACKED_PATTERN
    fi

    echo -e "${BRANCH_COLOR}($branch)${BRANCH_SYMBOL}${UPSTREAM_COLOR}($upstream)$ahead$behind$uptodate$staged$dirty$untracked"
}

function git_prompt() {
    worktree=`git rev-parse --is-inside-work-tree 2>&1`
    if [ $? -ne 0 ]; then
         return;
    fi
    if [[ "false" == "$worktree" ]]; then
        return;
    fi
    gitPrompt="$(parse_git_status)"
    printf "%s$R\n" "${gitPrompt}"
}

git_prompt
