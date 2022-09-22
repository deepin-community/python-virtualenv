#!/bin/sh
# Common shunit2 tests, used by all python interpreters
# Usage: shunit2-tests.sh PYTHON
# Args:
#   PYTHON: The python interpreter to run tests against

PYTHON=$1
shift

SOURCE=$(pwd)
HOME=$AUTOPKGTEST_TMP/home
mkdir -p $HOME

virtualenv -p $PYTHON $AUTOPKGTEST_TMP/ve
VP=$AUTOPKGTEST_TMP/ve/bin/python

virtualenv -p $PYTHON --system-site-packages $AUTOPKGTEST_TMP/sysve
SYSVP=$AUTOPKGTEST_TMP/sysve/bin/python

testMPipHelp() {
	$VP -m pip
	assertTrue 'Execute bare pip' $?
}

testSystemPackagesNotAvailable() {
	$VP -c 'import six'
	assertFalse 'Import system module from regular VE' $?
	$VP -m pip freeze | grep -Fq six
	assertFalse 'pip freeze lists system module from regular VE' $?
}

testSystemPackagesAvailable() {
	$SYSVP -c 'import six'
	assertTrue 'Import system module from system-site-packages VE' $?
	$SYSVP -m pip freeze | grep -Fq six
	assertTrue 'pip freeze lists system module from system-site-packages VE' $?
}

testSetuptoolsAvailable() {
	$VP -c 'import setuptools'
	assertTrue 'Import setuptools from regular VE' $?
	$SYSVP -c 'import setuptools'
	assertTrue 'Import setuptools from system-site-packages VE' $?
}

. shunit2
