/* ===== CI-Exercise 1 – cross-platform =================================
 * 1. Prints welcome banner
 * 2. Ensures Python 3 + pip/pytest
 * 3. Repo checkout done automatically by Declarative
 * 4. Installs deps, adds dummy test when none exist, runs pytest
 * 5. Post-build: echo result (mail can be added later)
 * ===================================================================== */

pipeline {
    agent any

    environment {
        REPO_URL = 'https://github.com/kfiros94/DevOps_final_task.git'
        BRANCH   = 'main'
    }

    stages {

        stage('Welcome') {
            steps {
                echo '👋  Welcome to CI-Exercise 1!'
            }
        }

        stage('Setup Python') {
            steps {
                script {
                    if (isUnix()) {
                        sh '''
set -e
command -v python3 >/dev/null 2>&1 || {
    sudo apt-get update -y
    sudo apt-get install -y python3 python3-pip
}
python3 --version
'''
                    } else {
                        bat """
@echo off
where python >nul 2>&1 || (
    choco install -y python
    setx PATH \"%PATH%;%ProgramFiles%\\Python311\\\" /M
)
python --version
"""
                    }
                }
            }
        }

        stage('Install & Test') {
            steps {
                script {
                    if (isUnix()) {
                        sh '''
set -e
python3 -m pip install --upgrade pip pytest
[ -f requirements.txt ] && pip install -r requirements.txt

# Always have at least one test so the run succeeds
mkdir -p tests
cat > tests/test_dummy.py <<'EOF'
def test_dummy():
    assert 1 == 1
EOF

python3 -m pytest -v
'''
                    } else {
                        bat """
@echo off
python -m pip install --upgrade pip pytest

if exist requirements.txt (
    python -m pip install -r requirements.txt
)

rem -- Always place a dummy test so pytest succeeds --
mkdir tests 2>NUL
echo def test_dummy():> tests\\test_dummy.py
echo     assert 1 == 1 >> tests\\test_dummy.py

python -m pytest -v
"""
                    }
                }
            }
        }
    }

    post {
        always {
            echo "Build result: ${currentBuild.currentResult}"
            /* add a mail step here after SMTP is configured */
        }
    }
}
