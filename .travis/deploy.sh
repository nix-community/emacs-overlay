#!/bin/bash

set -e

REPO=$(git config remote.origin.url)

if [ -n "$TRAVIS_BUILD_ID" ]; then
    # When running on Travis we need to use SSH to deploy to GitHub
    #
    # The following converts the repo URL to an SSH location,
    # decrypts the SSH key and sets up the Git config with
    # the correct user name and email (globally as this is a
    # temporary travis environment)
    #
    # Set the following environment variables in the travis configuration (.travis.yml)
    #
    #   DEPLOY_BRANCH    - The only branch that Travis should deploy from
    #   GIT_NAME         - The Git user name
    #   GIT_EMAIL        - The Git user email
    #
    echo GIT_NAME: $GIT_NAME
    echo GIT_EMAIL: $GIT_EMAIL

    if [ "$TRAVIS_BRANCH" != "$DEPLOY_BRANCH" ]; then
        echo "Travis should only deploy from the DEPLOY_BRANCH ($DEPLOY_BRANCH) branch"
        exit 0
    fi

    if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
        echo "Travis should not deploy from pull requests"
        exit 0
    fi

    # Switch both git and https protocols as we don't know which travis
    # is using today (it changed in the past!)
    REPO=${REPO/git:\/\/github.com\//git@github.com:}
    REPO=${REPO/https:\/\/github.com\//git@github.com:}

    # Add SSH key to SSH agent
    chmod 600 $SSH_KEY
    eval `ssh-agent -s`
    ssh-add $SSH_KEY

    git config --global user.name "$GIT_NAME"
    git config --global user.email "$GIT_EMAIL"

    # Set a rw remote
    git remote set-url origin $REPO

    # Checkout master
    git fetch origin
    git checkout master

    # Add changes
    git add repos/

    # Commit changes
    git commit -m "Built from commit $REV"

    # Push changes
    git push $REPO $TARGET_BRANCH
fi
