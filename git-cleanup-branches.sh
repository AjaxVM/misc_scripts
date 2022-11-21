#!/bin/bash

function gitcb() {
    # This script can be called from any git repo
    # or the function can be added to a bash_profile to use the gitcb alias in any git repo

    # This script will check if there is a develop branch on remote
    # if there is a develop branch, use it as root, otherwise use main/master
    # once on the nearest root branch, the script:
    # 1) pulls for most recent
    # 2) collects branches merged to root
    # 3) deletes all branches (except a root branch)
    # exiting if any of the steps fails

    # see if we have a develop branch, and use that
    remote_url=$(git config --get remote.origin.url)

    can_develop=$(git ls-remote --heads $remote_url develop | wc -l)
    can_master=$(git ls-remote --heads $remote_url master | wc -l)

    # ZSH: if [ $can_develop = "1" ]; then
    if [ $can_develop == "1" ]; then
        git checkout develop
    elif [ $can_master == "1" ]; then
        git checkout master
    else
        git checkout main
    fi

    # ZSH: if [ "$?" != 0 ]; then
    if [ "$?" -ne 0 ]; then
        echo "Cannot checkout to root (develop or main/master)"
        return 1
    fi

    git pull
    can_pull="$?"

    # ZSH: if [ "$can_pull" != 0 ]; then
    if [ "$can_pull" -ne 0 ]; then
        echo "Cannot pull most recent from root"
        return 2
    fi

    git branch --merged | grep -E -v "(^\*|main|master|develop)" | xargs -n 1 -r git branch -d

    # ZSH: if [ "$?" != 0 ]; then
    if [ "$?" -ne 0 ]; then
        echo "No branches to delete"
        # return 3
    fi
    echo "Finished, remaining branches are:"
    git branch
}


# to execute, call:
# gitcb
