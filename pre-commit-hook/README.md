### Task: Create a script for git pre-commit hook using Gitleaks for secret checks
### Junior 
Release pre-commit hook script with locally installed gitleak
Note: used in WSL2 
Install brew to speed up other installations
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```
Install Gitleaks
```
brew install gitleaks
```
Install pre-commit
```
brew install pre-commit
```
Add a pre-commit configuration:
Create a file named .pre-commit-config.yaml at the root of your repository with the following content:
```
repos:
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.16.1
    hooks:
      - id: gitleaks
```
Install the git hook scripts
```
pre-commit install
```
Now you can commit your changes.
``` git commit -m "test"
...
Detect hardcoded secrets.....
....
```
### Middle & Senior
Release pre-commit hook script with automatic gitleaks installation depending on the OS, with the enable option using git config and the installation based on "curl pipe sh" (Senior level)
Clone this file to your local repository
```
curl -L0 https://raw.githubusercontent.com/ng-n/kbot/../README.md
cp pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```
That's all. You can now perform git add <filename> and git commit -m "message" actions.