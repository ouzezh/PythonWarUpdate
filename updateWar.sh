#!/usr/bin/env sh
tomcatPath=$1
fileName=$2

if [ -z "${tomcatPath}" ]
then
  echo "tomcatPath is null"
  exit 1
fi
if [ -z "${fileName}" ]
then
  echo "fileName is null"
  exit 1
fi

context=$(echo "${fileName}" | sed s/\\..*//)
fileType=$(echo "${fileName}" | sed s/.*\\.//)

if [ -z "${context}" ]
then
  echo "context is null"
  exit 1
fi

wp=$(pwd)
cd ${tomcatPath}

ps -ef | grep "${tomcatPath}" | grep -v "grep " | grep -v $0 && res=$? || res=$?
if [ ${res} -eq 0 ]
then
  sh bin/shutdown.sh
  sleep 10s
fi

rm -rf webapps/${context}/*
if [ "${fileType}" = "war" ]
then
  unzip -o $wp/upload/${fileName} -d webapps/${context}
elif [ "${fileType}" = "tgz" ]
then
  mkdir -p webapps/${context}
  tar -xf $wp/upload/${fileName} -C webapps/${context}
else
  echo "fileType not support: ${fileType}"
  exit 1
fi

sh bin/startup.sh
ps -ef | grep "${tomcatPath}" | grep -v "grep " | grep -v $0