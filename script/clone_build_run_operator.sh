#!/bin/bash

AUTHOR_LINK=`jq -r '.refs[0].pulls[0].author_link' <<< $${CLONEREFS_OPTIONS} | tr -d '[:space:]'`
PULL_SHA=`jq -r '.refs[0].pulls[0].sha' <<< $${CLONEREFS_OPTIONS} | tr -d '[:space:]'`

echo "using author link ${AUTHOR_LINK}"
echo "using pull sha ${PULL_SHA}"
# get branch ref of the fork the PR was created from
BRANCH_REF=`curl ${AUTHOR_LINK}/toolchain-e2e.git/info/refs?service=git-upload-pack --output - 2>/dev/null | grep -a ${PULL_SHA} | awk '{print $$2}'`
echo "detected branch ref ${BRANCH_REF}"
# check if a branch with the same ref exists in the user's fork of ${REPO_NAME} repo
REMOTE_E2E_BRANCH=`curl ${AUTHOR_LINK}/${REPO_NAME}.git/info/refs?service=git-upload-pack --output - 2>/dev/null | grep -a ${BRANCH_REF} | awk '{print $$2}'`
echo "branch ref of the user's fork: \"${REMOTE_E2E_BRANCH}\" - if empty then not found"
# check if the branch with the same name exists, if so then merge it with master and use the merge branch, if not then use master
if [[ -n "${REMOTE_E2E_BRANCH}" ]]; then
    # retrieve the branch name
    BRANCH_NAME=`echo ${BRANCH_REF} | awk -F'/' '{print $$3}'`
    # add the user's fork as remote repo
    git --git-dir=${E2E_REPO_PATH}/.git --work-tree=${E2E_REPO_PATH} remote add external ${AUTHOR_LINK}/${REPO_NAME}.git
    # fetch the branch
    git --git-dir=${E2E_REPO_PATH}/.git --work-tree=${E2E_REPO_PATH} fetch external ${BRANCH_REF}
    # merge the branch with master
    git --git-dir=${E2E_REPO_PATH}/.git --work-tree=${E2E_REPO_PATH} merge FETCH_HEAD
fi

make -C ${E2E_REPO_PATH} build

${E2E_REPO_PATH}/build/_output/bin/${REPO_NAME}
