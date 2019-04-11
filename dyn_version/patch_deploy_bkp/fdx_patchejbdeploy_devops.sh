#!/bin/ksh
##
##
##
##
BRANCH_NAME=$1
JAR_VERSION=8.2.2-80665
EJB_PRE_EAR="preejb_fdEJB-$JAR_VERSION.jar"
EAR_FILE="fdEJB-$JAR_VERSION.jar"
EJB_DEPLOY="/opt/IBM/WebSphere/AppServer/bin"
JENKINS_BRANCH=Brokerage_Dynamic_Versioning_8_2_2
COMMON_LIB="/home/wasadmin/release/jenkinsworkspace/$JENKINS_BRANCH/fdxLib/common"
UTIL_JAR="/home/wasadmin/release/jenkinsworkspace/$JENKINS_BRANCH/fdUtil/target"
EXTERNAL_LIB="/home/wasadmin/release/external/lib"
#EAR_DIR="/var/lib/jenkins/workspace/$BRANCH_NAME/fdEJB/target"
EAR_DIR=/fdx/FDX_MVN_REPO_8_2_2/com/fd/brokerage/fdEJB/$JAR_VERSION


###
###

cd $EAR_DIR
mv $EAR_FILE $EJB_PRE_EAR

$EJB_DEPLOY/ejbdeploy.sh $EAR_DIR/preejb_fdEJB-$JAR_VERSION.jar /tmp/ $EAR_DIR/fdEJB-$JAR_VERSION.jar -cp $COMMON_LIB/log4j-core-2.8.2.jar:$COMMON_LIB/log4j-1.2-api-2.8.2.jar:$COMMON_LIB/log4j-api-2.8.2.jar:$UTIL_JAR/fdUtil-$JAR_VERSION.jar:$EXTERNAL_LIB/quickfixj-all-1.5.3.jar -nowarn


if [ $? -ne 0 ]
then
        echo "Ejb Deploy failed"
        exit 0
fi
sleep 15
##mkdir -p /var/lib/jenkins/workspace/$BRANCH_NAME/fdEJB/target/
cp $EAR_DIR/fdEJB-$JAR_VERSION.jar /home/wasadmin/release/jenkinsworkspace/$JENKINS_BRANCH/fdEJB/target/classes
cd /home/wasadmin/release/jenkinsworkspace/$JENKINS_BRANCH/fdEJB/target/classes
jar xf fdEJB-$JAR_VERSION.jar
if [ $? -ne 0 ]
then
        echo "EJB Stub step failed"
        exit 0
fi



chmod -R 777 /home/wasadmin/release/jenkinsworkspace/$JENKINS_BRANCH/fdDbProcedures/*.spxmi
##rm /var/lib/jenkins/workspace/$BRANCH_NAME/fdDbProcedures/*.spxmi.r*
if [ -f /home/wasadmin/release/jenkinsworkspace/$JENKINS_BRANCH/fdDbProcedures/*.spxmi.r* ];
then
        rm /home/wasadmin/release/jenkinsworkspace/$JENKINS_BRANCH/fdDbProcedures/*.spxmi.r*
        rm /home/wasadmin/release/jenkinsworkspace/$JENKINS_BRANCH/fdDbProcedures/*.spxmi.mine
fi
