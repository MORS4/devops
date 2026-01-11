## Scripts d’automatisation (GitHub)

Ces scripts permettent d’automatiser ce qui est normalement fait dans l’UI GitHub:
- Création d’une Pull Request `dev -> main`
- Création du webhook GitHub → Jenkins

### Prérequis
- PowerShell
- Un token GitHub **classic PAT** avec droits:
  - `repo` (pour PR + webhook)

Définir le token:
```powershell
$env:GITHUB_TOKEN = "<YOUR_TOKEN>"
```

### Créer la PR `dev -> main`
```powershell
./scripts/create_pr.ps1 -Repo "MORS4/devops" -Base "main" -Head "dev"
```

### Créer le webhook GitHub → Jenkins
```powershell
./scripts/create_webhook.ps1 -Repo "MORS4/devops" -JenkinsUrl "http://<JENKINS_HOST>:8080" -Secret "optional-secret"
```

