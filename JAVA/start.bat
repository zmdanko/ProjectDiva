@echo off

start cmd /c "title eureka && java -jar D:\develop\ProjectDiva\JAVA\ProjectDiva\eureka\target\Eureka-0.0.1-SNAPSHOT.jar"

TIMEOUT /T 10

start cmd /c "title config && java -jar D:\develop\ProjectDiva\JAVA\ProjectDiva\config\target\config-0.0.1-SNAPSHOT.jar"

TIMEOUT /T 30

start cmd /c "title gateway && java -jar D:\develop\ProjectDiva\JAVA\ProjectDiva\gateway\target\gateway-0.0.1-SNAPSHOT.jar"

start cmd /c "title service && java -jar D:\develop\ProjectDiva\JAVA\ProjectDiva\service\target\service-0.0.1-SNAPSHOT.jar"

start cmd /c "title downloader && java -jar D:\develop\ProjectDiva\JAVA\ProjectDiva\downloader\target\downloader-0.0.1-SNAPSHOT.jar"


