#!/usr/bin/env sh
tp={tomcat_path}
context={web_context}
wp=$(pwd)

cd $tp

ps -ef | grep -v "grep " | grep "$tp"
if [ $? -eq 0 ]
then
  sh bin/shutdown.sh
  sleep 10s
fi

rm -rf webapps/${context}.war webapps/${context}
cp $wp/swap.war webapps/${context}.war

sh bin/startup.sh
ps -ef | grep -v "grep " | grep "$tp"