/* ===== CI-Exercise 1  –  cross-platform ================================
 * 1.  Prints a welcome banner
 * 2.  Makes sure Python 3 + pip/pytest exist
 * 3.  (Repo is auto-checked-out by Declarative SCM)
 * 4.  Installs requirements, adds a dummy test, runs pytest
 * 5.  Post-build: echo the result   (add mail step later if you like)
 * ===================================================================== */

pipeline {
    agent any

    environment {
        REPO_URL = 'https://github.com/kfiros94/DevOps_final_task.git'  // for your reference
        BRANCH   = 'main'
    }

    /* Declarative automatically performs    *
     *  “checkout scm” before the first stage */

    stages {

        stage('Welcome') {
            steps { echo '👋  Welcome to CI-Exercise 1!' }
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

# Always ensure at least one test so pytest passes
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
mkdir tests 2>nul
echo def test_dummy():>  tests\\test_dummy.py
echo     assert 1 == 1>> tests\\test_dummy.py

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
            /* Once SMTP is configured you can enable a mail step here */
        }
    }
}
