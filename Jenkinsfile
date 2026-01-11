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
            if (isUnix()) {
              sh "docker --version"
              sh "docker compose version"
              sh "docker compose up -d --build"
              sh "curl -fsS http://localhost:8080/ | grep -F \"Bonjour et bon courage\""
            } else {
              bat "docker --version"
              bat "docker compose version"
              bat "docker compose up -d --build"
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
        try {
          slackSend(color: 'good', message: "✅ ${env.JOB_NAME} #${env.BUILD_NUMBER} SUCCESS — ${env.BUILD_URL}")
        } catch (err) {
          echo "Slack notification skipped (plugin/credentials not configured): ${err}"
        }
      }
    }
    failure {
      script {
        try {
          slackSend(color: 'danger', message: "❌ ${env.JOB_NAME} #${env.BUILD_NUMBER} FAILED — ${env.BUILD_URL}")
        } catch (err) {
          echo "Slack notification skipped (plugin/credentials not configured): ${err}"
        }
      }
    }
  }
}

