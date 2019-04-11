#!/bin/bash

##
## fdxPatch
## usage
##      fdxPatch <release> <patch tag>
## i.e. fdxPatch 6.3 FDX_6_3_0_2
##
. /home/wasadmin/.profile
source ./env_variables.sh

echo "----- Set Environment Variables -----"
if [ $# -ne 2 ]
then
        echo "Usage: $0 <release> <patch tag>"
        exit -1
fi

VERSION_NUMBER=8.2.2; export VERSION_NUMBER

RELEASE=$VERSION_NUMBER
PATCH_TAG=""

echo "------ Version number - $VERSION_NUMBER -----"
FDX_BUILD_HOME=/home/wasadmin/release
CORE_SOURCE_DIR=$FDX_BUILD_HOME/projects/fdx/$RELEASE/source
CORE_BUILD_DIR=$FDX_BUILD_HOME/projects/fdx/$RELEASE/build
MAVEN_REP=/fdx/FDX_MVN_REPO_8_2_2/com/fd/brokerage/

if [ ! -d $MAVEN_REP ]
then
        echo "Core Source Dir: [$MAVEN_REP] does not exists"
        exit -1
fi

##
##
##

##
## clean build dir
##

if [ -d /home/wasadmin/release/projects/fdx/$VERSION_NUMBER/build ]
then

cd /home/wasadmin/release/projects/fdx/$VERSION_NUMBER/build/
rm *.jar *.war *.ear *.zip
##cp /home/wasadmin/release/projects/fdx/$VERSION_NUMBER/fdDbProcedures.zip .
fi
echo "----- Cleaned up prev artifacts -----"
find $MAVEN_REP -name '*.jar' -exec cp {} $CORE_BUILD_DIR  \;
find $MAVEN_REP -name '*.war' -exec cp {} $CORE_BUILD_DIR  \;
find $MAVEN_REP -name '*.ear' -exec cp {} $CORE_BUILD_DIR  \;
find $MAVEN_WS -name 'fdAppConfigs.zip' -exec cp {} $CORE_BUILD_DIR  \;
find $MAVEN_WS -name 'fdStatic.zip' -exec cp {} $CORE_BUILD_DIR  \;
find $MAVEN_WS -name 'fdTemplates.zip' -exec cp {} $CORE_BUILD_DIR  \;
find $MAVEN_WS -name 'fdxLib.zip' -exec cp {} $CORE_BUILD_DIR  \;
echo "----- Copied Artifacts from :" $MAVEN_REP " to " $CORE_BUILD_DIR " -----"
cd $CORE_BUILD_DIR
 
#for file in *-0.0.1.jar ; do mv "$file" "${file%%-0.0.1.jar}.jar" ; done
#for file in *-0.0.1.ear ; do mv "$file" "${file%%-0.0.1.ear}.ear" ; done
#for file in *-0.0.1.war ; do mv "$file" "${file%%-0.0.1.war}.war" ; done

##chmod -R --silent 777 /var/lib/jenkins/workspace/FDX_MAVEN_8_2_0/fdStatic/portal
##chmod -R --silent 777 /var/lib/jenkins/workspace/FDX_MAVEN_8_2_0/fdStatic/portal



echo "----- Accessing Jenkins for last Successful build infomation -----"
wget --auth-no-challenge --user=nousdev --password=nousdev1234 http://10.20.40.166:8080/job/Brokerage_Dynamic_Versioning_8_2_2/lastSuccessfulBuild/buildNumber -O /home/wasadmin/release/projects/fdx/$VERSION_NUMBER/build/buildinfo.txt
echo "Release=$RELEASE" > /home/wasadmin/release/projects/fdx/$VERSION_NUMBER/build/buildinfo.properties
build_num=`cat /home/wasadmin/release/projects/fdx/$VERSION_NUMBER/build/buildinfo.txt`
echo "Build=$build_num" >> /home/wasadmin/release/projects/fdx/$VERSION_NUMBER/build/buildinfo.properties
cd /home/wasadmin/release/projects/fdx/$VERSION_NUMBER/build/
jar -uf fdWeb-*.war buildinfo.properties
current_build=`cat /home/wasadmin/release/projects/fdx/.buildNumber | grep $RELEASE`
echo "SED Command : "$current_build/$RELEASE
sed -i "s/$current_build/$RELEASE::$build_num/g" /home/wasadmin/release/projects/fdx/.buildNumber
echo "----- Successfully Completed -----"

chmod -R --silent 777 /fdx/FDX_MVN_REPO_8_2_2/com/fd/


exit 0

