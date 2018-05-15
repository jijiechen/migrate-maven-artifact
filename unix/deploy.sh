#!/bin/bash

deploy_repository=$1
resolve_repository=$2

if [ "$deploy_repository" = "" ]; then
	RED='\033[0;31m'
	RESET='\033[0m'
	echo -e "${RED}A url of destination repository should be specified.${RESET}"
	exit 1
fi 

if [ "$resolve_repository" = "" ]; then
	resolve_repository=$deploy_repository
fi 

try_resolve(){
	repo=$1
	g=$2
	a=$3
	v=$4


	g=$( echo $g | sed -e "s/\./\//g" )
	curl --fail -L -I "${repo%/}/$g/$a/$v/$a-$v.pom" >/dev/null 2>&1
	echo $?
}

initialized=0
deploy_settings=''
if [ -f "deploy-settings.xml" ]; then
	deploy_settings='-s deploy-settings.xml'
fi

for pom in $(find ./.deps-proj/target/dependency/ -name '*.pom' 2> /dev/null); do
	echo "Analyzing $pom"
	if [ initialized = 0 ]; then
		initialized=1
		mvn help:evaluate -Dexpression="project.groupId" -f $pom
	fi

	g=$(grep -v '\[' <( mvn help:evaluate -Dexpression="project.groupId" -f $pom 2>/dev/null ))
	a=$(grep -v '\[' <( mvn help:evaluate -Dexpression="project.artifactId" -f $pom 2>/dev/null ))
	v=$(grep -v '\[' <( mvn help:evaluate -Dexpression="project.version" -f $pom 2>/dev/null ))
	pkg=$(grep -v '\[' <( mvn help:evaluate -Dexpression="project.packaging" -f $pom 2>/dev/null ))

	exists=$( try_resolve $resolve_repository $g $a $v )
	if [ "$exists" = "0" ]; then
		echo "Skipping $g:$a:$v: it is found in $resolve_repository"
	else
		echo "Deploying $g:$a:$v to $deploy_repository"
		mvn deploy:deploy-file $deploy_settings -Durl=$deploy_repository -Dfile="${pom%.pom}.$pkg" -DpomFile="$pom" -DgeneratePom=false -DrepositoryId=deploy
		# Todo: What if only pom is available
	fi

	echo ''
done



