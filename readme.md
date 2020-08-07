# 使用Python更新tomcat应用

- 一、启动程序

start.sh

- 二、更新war

```
export token=$(echo -n "UuQjLlru4SOuGGLKWn1cGH0YeBZQlFfD"$(date +%Y-%m-%d_%H) | md5sum | cut -d ' ' -f1)
res=$(curl 'http://localhost:8080/update?tomcatPath=/usr/local/tomcat&fileName=context.war' -X POST -H "token: ${token}" -H 'Content-Type: multipart/form-data' -F "file=@target/context.war")
echo $res | egrep "{\\\"status\\\":\s*1}"
```