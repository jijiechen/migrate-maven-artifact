#!/bin/bash

deps_proj='.deps-proj'
pom=$(./pom.sh $1 $2 $3)

rm -rf $deps_proj
mkdir $deps_proj
echo $pom > $deps_proj/pom.xml

mvn clean dependency:copy-dependencies -f $deps_proj/pom.xml -Dmdep.copyPom=true -Dmdep.useRepositoryLayout=true

cd ..



