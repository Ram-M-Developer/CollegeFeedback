@echo off
setlocal
if exist "C:\Users\ELCOT\.jdks\temurin-21.0.11" (
    set "JAVA_HOME=C:\Users\ELCOT\.jdks\temurin-21.0.11"
)
if defined JAVA_HOME (
    set "JRE_HOME=%JAVA_HOME%"
    set "PATH=%JAVA_HOME%\bin;%PATH%"
)

set "MVN_CMD=mvn"
if exist "C:\Program Files\apache-maven-3.9.16\bin\mvn.cmd" (
    set "MVN_CMD=C:\Program Files\apache-maven-3.9.16\bin\mvn.cmd"
)

echo [1/3] Building WAR package with Maven...
call "%MVN_CMD%" clean package -DskipTests
if errorlevel 1 (
    echo [ERROR] Maven build failed.
    exit /b 1
)

echo [2/3] Deploying collegefeedback.war to Tomcat webapps...
if exist ".tomcat\apache-tomcat-9.0.89\webapps\collegefeedback" (
    rd /s /q ".tomcat\apache-tomcat-9.0.89\webapps\collegefeedback"
)
if exist ".tomcat\apache-tomcat-9.0.89\work\Catalina\localhost\collegefeedback" (
    rd /s /q ".tomcat\apache-tomcat-9.0.89\work\Catalina\localhost\collegefeedback"
)
copy /Y "target\collegefeedback.war" ".tomcat\apache-tomcat-9.0.89\webapps\collegefeedback.war"

echo [3/3] Starting Apache Tomcat 9...
set "CATALINA_HOME=%~dp0.tomcat\apache-tomcat-9.0.89"
set "CATALINA_BASE=%~dp0.tomcat\apache-tomcat-9.0.89"
call "%CATALINA_HOME%\bin\catalina.bat" start

echo Application deployed successfully!
echo URL: http://localhost:8080/collegefeedback/
