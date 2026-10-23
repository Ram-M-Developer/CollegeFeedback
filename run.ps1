if (Test-Path "C:\Users\ELCOT\.jdks\temurin-21.0.11") {
    $env:JAVA_HOME = "C:\Users\ELCOT\.jdks\temurin-21.0.11"
}
if ($env:JAVA_HOME) {
    $env:PATH = "$env:JAVA_HOME\bin;$env:PATH"
}

$mvnCmd = "mvn"
if (Test-Path "C:\Program Files\apache-maven-3.9.16\bin\mvn.cmd") {
    $mvnCmd = "C:\Program Files\apache-maven-3.9.16\bin\mvn.cmd"
}

Write-Host "[1/3] Building WAR package with Maven..." -ForegroundColor Cyan
& $mvnCmd clean package -DskipTests
if ($LASTEXITCODE -ne 0) {
    Write-Error "Maven build failed!"
    exit $LASTEXITCODE
}

Write-Host "[2/3] Deploying collegefeedback.war to Tomcat webapps..." -ForegroundColor Cyan
if (Test-Path ".tomcat\apache-tomcat-9.0.89\webapps\collegefeedback") {
    Remove-Item -Path ".tomcat\apache-tomcat-9.0.89\webapps\collegefeedback" -Recurse -Force
}
if (Test-Path ".tomcat\apache-tomcat-9.0.89\work\Catalina\localhost\collegefeedback") {
    Remove-Item -Path ".tomcat\apache-tomcat-9.0.89\work\Catalina\localhost\collegefeedback" -Recurse -Force
}
Copy-Item -Path "target\collegefeedback.war" -Destination ".tomcat\apache-tomcat-9.0.89\webapps\collegefeedback.war" -Force

Write-Host "[3/3] Starting Apache Tomcat 9..." -ForegroundColor Cyan
$catalinaHome = Join-Path $PSScriptRoot ".tomcat\apache-tomcat-9.0.89"
$env:CATALINA_HOME = $catalinaHome
$env:CATALINA_BASE = $catalinaHome

Start-Process -FilePath (Join-Path $catalinaHome "bin\startup.bat")

Write-Host "Application deployed successfully!" -ForegroundColor Green
Write-Host "URL: http://localhost:8080/collegefeedback/" -ForegroundColor Yellow
