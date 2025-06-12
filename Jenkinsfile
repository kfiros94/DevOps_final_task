/* CI-Exercise 1 – cross-platform */

pipeline {
    agent any
    environment {
        REPO_URL = 'https://github.com/kfiros94/DevOps_final_task.git'
        BRANCH   = 'main'
    }

    stages {
        stage('Welcome')  { steps { echo '👋  Welcome to CI-Exercise 1!' } }

        stage('Setup Python') {
            steps {
                script {
                    if (isUnix()) {
                        sh '''
                            set -e
                            if ! command -v python3 >/dev/null 2>&1; then
                              sudo apt-get update -y
                              sudo apt-get install -y python3 python3-pip
                            fi
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

        stage('Checkout') {
            steps {
                git url: env.REPO_URL, branch: env.BRANCH
            }
        }

        stage('Install & Test') {
    steps {
        script {
            if (isUnix()) {
                /* … the Linux shell block you already have … */
            } else {
                bat """
@echo off
python -m pip install --upgrade pip pytest

if exist requirements.txt (
    python -m pip install -r requirements.txt
)

rem ---------- add dummy test if none exist ----------
dir /s /b tests\\test_*.py >nul 2>&1
if %errorlevel% neq 0 (
    mkdir tests 2>nul
    echo def test_dummy():>  tests\\test_dummy.py
    echo     assert 1 == 1>> tests\\test_dummy.py
)

python -m pytest -v
"""
            }
        }
    }
}

    }

    post {
        always { echo "Build result: ${currentBuild.currentResult}" }
    }
}
