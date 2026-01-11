## Jenkins setup (PipeLine-NomPrenom)

### Prérequis Jenkins
- Jenkins installé + accès admin
- Plugins recommandés:
  - Pipeline
  - Git
  - GitHub (optionnel mais utile)
  - Slack Notification (pour `slackSend`)

### 1) Créer le job Pipeline
- **New Item** → **Pipeline**
- Nom: `PipeLine-NomPrenom`
- **Pipeline** → *Pipeline script from SCM*
  - SCM: Git
  - Repository URL: `https://github.com/MORS4/devops.git`
  - Branch Specifier: `*/main` (ou `*/dev` pour tester)
  - Script Path: `Jenkinsfile`

### 2) Webhook GitHub → Jenkins
- Dans GitHub: repo → **Settings → Webhooks → Add webhook**
  - Payload URL: `http://<JENKINS_URL>/github-webhook/`
  - Content type: `application/json`
  - Events: `Just the push event` (ou push + pull_request)
- Alternative: script PowerShell `scripts/create_webhook.ps1` (nécessite token GitHub)

### 3) Vue personnalisée (afficher uniquement *PipeLine*)
- **New View** → *List View*
- Nom (ex): `Pipelines`
- Filtre Regex: `.*PipeLine.*`

### 4) Slack
- Configurez le plugin Slack (workspace + token/credentials)
- Le `Jenkinsfile` envoie une notif en `post { success/failure }`

