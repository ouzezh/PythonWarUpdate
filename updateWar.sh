#!/usr/bin/env sh
tomcatPath=$1
context=$2
filePath=$3

if [ -z "${tomcatPath}" ]
then
  echo "Usage: sh $0 [tomcatPath] [context] [filePath]"
  exit 1
elif [ ! -d "${tomcatPath}/webapps" ]
then
  echo "path not exists: ${tomcatPath}/webapps"
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

function processCount() {
  ps -ef | grep "$1" | grep -v "grep " | grep -v "$0" | wc -l
}

pc=$(processCount "${tomcatPath}")
if [ ${pc} -gt 0 ]
then
  sh ${tomcatPath}/bin/shutdown.sh

  for i in {1..60}
  do
    echo "check status $i time"
    pc=$(processCount "${tomcatPath}")
    if [ ${pc} -gt 0 ]
    then
      sleep 1s
    else
      break
    fi
  done

  pc=$(processCount "${tomcatPath}")
  if [ ${pc} -gt 0 ]
  then
    kill -9 $(ps -ef | grep "${tomcatPath}" | grep -v "grep " | grep -v "$0" | awk '{print $2}')
  fi
fi

rm -rf "${tomcatPath}/webapps/${context}"
if [ "${fileType}" = "war" ]
then
  unzip -o ${filePath} -d ${tomcatPath}/webapps/${context}
elif [ "${fileType}" = "tgz" ]
then
  mkdir -p ${tomcatPath}/webapps/${context}
  tar -xf ${filePath} -C ${tomcatPath}/webapps/${context}
else
  echo "fileType not support: ${fileType}"
  exit 1
fi

sh ${tomcatPath}/bin/startup.sh

for i in {1..60}
do
  echo "check status $i time"
  pc=$(processCount "${tomcatPath}")
  if [ ${pc} -le 0 ]
  then
    sleep 1s
  else
    break
  fi
done

processCount "${tomcatPath}"
if [ ${pc} -le 0 ]
then
  echo "startup error"
  exit 1
fi