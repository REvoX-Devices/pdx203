#!/bin/bash

echo
echo "--------------------------------------"
echo "     Evolution X (pdx203) Buildbot    "
echo "                  by                  "
echo "               SimplyRin              "
echo "--------------------------------------"
echo

set -e

BL=$PWD/evo_pdx203

initRepos() {
    if [ ! -d .repo ]; then
        echo "--> Initializing EvolutionX workspace"
        repo init -u https://github.com/Evolution-X/manifest -b tiramisu
        echo

        echo "--> Preparing local manifest"
        mkdir -p .repo/local_manifests
        cp $BL/manifest.xml .repo/local_manifests/evolution.xml
        echo
    fi
}

syncRepos() {
    echo "--> Syncing repos"
    repo sync -c --force-sync --no-clone-bundle --no-tags -j10
    echo
}

setupEnv() {
    echo "--> Setting up build environment"
    source build/envsetup.sh &>/dev/null
    mkdir -p $BD
    echo
}

buildVariant() {
    echo "--> Building evolution_pdx203"
    lunch evolution_pdx203-userdebug
    mka -j10 installclean
    mka evolution
    echo
}

START=`date +%s`
BUILD_DATE="$(date +%Y%m%d)"

initRepos
syncRepos
setupEnv
buildVariant

END=`date +%s`
ELAPSEDM=$(($(($END-$START))/60))
ELAPSEDS=$(($(($END-$START))-$ELAPSEDM*60))

echo "--> Buildbot completed in $ELAPSEDM minutes and $ELAPSEDS seconds"
echo
