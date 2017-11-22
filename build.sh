cd demo-be-rs
mvn clean package
cd ..
docker build -t demo-be-jboss7:20171122 .
