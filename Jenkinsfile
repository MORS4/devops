pipeline {
  agent any

  environment {
    MVN_CMD = "mvn -B"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build & Test') {
      steps {
        script {
          def ws = pwd()
          if (isUnix()) {
            sh """
              set -e
              if command -v mvn >/dev/null 2>&1; then
                ${env.MVN_CMD} clean verify
              else
                echo "Maven not found; running build in Docker (maven image) ..."
                docker run --rm -v "${ws}:/app" -w /app maven:3.9.9-eclipse-temurin-17 mvn -B clean verify
              fi
            """
          } else {
            bat """
              @echo on
              where mvn >nul 2>nul
              if %ERRORLEVEL%==0 (
                ${env.MVN_CMD} clean verify
              ) else (
                echo Maven not found; running build in Docker (maven image) ...
                docker run --rm -v "%cd%:/app" -w /app maven:3.9.9-eclipse-temurin-17 mvn -B clean verify
              )
            """
          }
        }
      }
    }

    stage('Archive') {
      steps {
        archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
      }
    }

    stage('Deploy (docker compose)') {
      steps {
        script {
          try {
            def composeCmd = isUnix() ? "docker compose" : "docker compose"
            if (isUnix()) {
              // fallback for environments that only have docker-compose (v1)
              def hasComposeV2 = sh(script: 'docker compose version >/dev/null 2>&1; echo $?', returnStdout: true).trim() == "0"
              composeCmd = hasComposeV2 ? "docker compose" : "docker-compose"
            } else {
              // Windows runners usually have `docker compose`; fallback to `docker-compose` if present
              def hasComposeV2 = bat(script: "docker compose version >nul 2>nul\r\nif %ERRORLEVEL%==0 (echo 0) else (echo 1)", returnStdout: true).trim().endsWith("0")
              composeCmd = hasComposeV2 ? "docker compose" : "docker-compose"
            }

            if (isUnix()) {
              sh "docker --version"
              sh "${composeCmd} version || true"
              // Avoid conflicts with locally-running containers on the same Docker daemon
              sh "docker rm -f projet-devops-app >/dev/null 2>&1 || true"
              sh "${composeCmd} up -d --build"
              def isInDocker = sh(script: 'test -f /.dockerenv; echo $?', returnStdout: true).trim() == "0"
              def url = isInDocker ? "http://host.docker.internal:8080/" : "http://localhost:8080/"
              sh "curl -fsS ${url} | grep -F \"Bonjour et bon courage\""
            } else {
              bat "docker --version"
              bat "${composeCmd} version"
              bat "docker rm -f projet-devops-app >nul 2>nul"
              bat "${composeCmd} up -d --build"
              bat "powershell -NoProfile -Command \"(Invoke-WebRequest -UseBasicParsing http://localhost:8080/).Content\""
            }
          } catch (err) {
            echo "Deploy step skipped/failed (Docker not available or app not reachable): ${err}"
            currentBuild.result = currentBuild.result ?: 'UNSTABLE'
          }
        }
      }
    }
  }

  post {
    success {
      script {
        echo "Slack notify: skipped unless Jenkins Slack is configured (plugin + token + channel)."
      }
    }
    failure {
      script {
        echo "Slack notify: skipped unless Jenkins Slack is configured (plugin + token + channel)."
      }
    }
  }
}

