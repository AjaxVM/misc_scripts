#!/bin/bash

# This script can be called from any git repo
# or the function can be added to a bash_profile to use the gitcb alias in any git repo

# This script will try to checkout develop, and if it can't find, fall back to master
# if it cannot reach either, exits
# once on the nearest root branch (develop or master) the script:
# 1) pulls for most recent
# 2) collects branches merged to root
# 3) deletes all branches (except a root branch)
# exiting if any of the steps fails

function gitcb() {
    git checkout develop
    can_develop="$?"
    can_master=0
    if [ "$can_develop" -ne 0 ]; then
        git checkout master
        can_master="$?"
    fi

    if [[ "$can_develop" -ne 0 && "$can_master" -ne 0 ]]; then
        echo "Cannot checkout to root (master or develop)"
        return 1
    fi

    git pull
    can_pull="$?"

    if [ "$can_pull" -ne 0 ]; then
        echo "Cannot pull most recent from root"
        return 2
    fi

    branches=$(git branch --merged | egrep -v "(^\*|master|dev)") # | xargs git branch -d
    can_delete="$?"

    if [ "$can_delete" -ne 0 ]; then
        echo "No branches to delete"
        return 0
    fi

    echo "$branches" | xargs git branch -d

    if [ "$can_delete" -ne 0 ]; then
        echo "Cannot delete branches"
        return 3
    fi
    echo "Finished, remaining branches are:"
    git branch
}

gitcb