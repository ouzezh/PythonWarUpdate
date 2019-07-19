export token=$(echo -n "UuQjLlru4SOuGGLKWn1cGH0YeBZQlFfD"$(date +%Y-%m-%d_%H) | md5sum | cut -d ' ' -f1)
res=$(curl 'http://10.202.49.167:8081/update?tomcatPath=/usr/local/tomcat&fileName=context.war' -X POST -H "token: ${token}" -H 'Content-Type: multipart/form-data' -F "fileUpload=@target/context.war")
echo $res | egrep "{\\\"status\\\":\s*1}"