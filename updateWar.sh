#!/usr/bin/env sh
tomcatPath=$1
context=$2
filePath=$3

if [ -z "${tomcatPath}" ]
then
  echo "tomcatPath is null"
  exit 1
elif [ -z "${context}" ]
then
  echo "context is null"
  exit 1
elif [ -z "${filePath}" ]
then
  echo "filePath is null"
  exit 1
fi

fileType=$(echo "${filePath}" | sed s/.*\\.//)

ps -ef | grep "${tomcatPath}" | grep -v "grep " | grep -v $0 && res=$? || res=$?
if [ ${res} -eq 0 ]
then
  sh ${tomcatPath}/bin/shutdown.sh
  sleep 10s
fi

rm -rf ${tomcatPath}/webapps/${context}/*
if [ "${fileType}" = "war" ]
then
  unzip -o ${filePath} -d ${tomcatPath}/webapps/${context}
elif [ "${fileType}" = "tgz" ]
then
  mkdir -p webapps/${context}
  tar -xf ${filePath} -C ${tomcatPath}/webapps/${context}
else
  echo "fileType not support: ${fileType}"
  exit 1
fi

sh bin/startup.sh
ps -ef | grep "${tomcatPath}" | grep -v "grep " | grep -v $0