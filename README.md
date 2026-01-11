# Projet DevOps — Mini Projet

**Nom & Prénom :** _À REMPLACER (Nom Prénom)_

## Objectif
Application Java/Maven simple + CI/CD avec **GitHub Actions**, **Jenkins**, **Docker** et **docker-compose**.

## Application
- **Message**: `Bonjour et bon courage dans votre projet en DevOps`
- **Type**: API REST Spring Boot
  - `GET /` retourne le message

## Démarrage local

### Prérequis
- Java 17+
- Maven 3.9+

### Lancer les tests + build
```bash
mvn -B clean verify
```

### Lancer l’application
```bash
mvn -B spring-boot:run
```
Puis ouvrir `http://localhost:8080/`

## Docker

### Build + run (Dockerfile)
```bash
docker build -t projet-devops-app .
docker run --rm -p 8080:8080 projet-devops-app
```

### docker-compose
```bash
docker compose up --build
```

## Git / GitHub (checklist demandée)

### 1) Repo local
```bash
git init
git checkout -b main
git add .
git commit -m "init: spring boot app + ci/cd"
```

### 2) Repo GitHub
- Créez un repo: `Projet-DevOps-NomPrenom`
- Liez le remote (remplacez l’URL):
```bash
git remote add origin https://github.com/<USER>/Projet-DevOps-NomPrenom.git
git push -u origin main
```

### 3) Branche `dev` + PR
```bash
git checkout -b dev
git push -u origin dev
```
- Faites quelques commits sur `dev`
- Ouvrez une Pull Request `dev -> main`

## GitHub Actions
- Workflow: `.github/workflows/ci.yml`
- Déclenchement: `push` et `pull_request` sur `main` et `dev`

## Jenkins
- Pipeline: `Jenkinsfile`
- Stages: Checkout → Build/Test → Archive → Deploy (docker-compose) → Notify Slack

## Rapport
Un modèle est fourni: `docs/REPORT_TEMPLATE.md`

