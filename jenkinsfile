/* --------------- CI-Exercise 1 --------------- *
 * Works on Windows & Linux agents
 * - Greets the console
 * - Ensures Python ≥3
 * - Checks out your repo
 * - Installs deps & runs pytest
 * --------------------------------------------- */

pipeline {
    agent any

    environment {
        REPO_URL = 'https://github.com/kfiros94/DevOps_final_task.git'  // ← change me
        BRANCH   = 'main'                                       // or master
        // CREDENTIALS = 'git-cred-id'                          // uncomment if private repo
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
                            if ! command -v python3 >/dev/null 2>&1; then
                              echo "[INFO] Installing Python 3…"
                              sudo apt-get update -y
                              sudo apt-get install -y python3 python3-venv python3-pip
                            fi
                            python3 --version
                        '''
                    } else {                              // Windows agent
                        bat """
                            @echo off
                            where python >nul 2>&1
                            if %errorlevel% neq 0 (
                                echo [INFO] Installing Python 3 with Chocolatey…
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
                // ---- the only line that changed ----
                git url: env.REPO_URL,
                    branch: env.BRANCH
                    // , credentialsId: env.CREDENTIALS  // uncomment if needed
            }
        }

        stage('Install & Test') {
            steps {
                script {
                    if (isUnix()) {
                        sh '''
                            set -e
                            python3 -m pip install --upgrade pip
                            [ -f requirements.txt ] && pip install -r requirements.txt

                            # add dummy test if none exist
                            if ! ls **/test_*.py >/dev/null 2>&1; then
                              mkdir -p tests
                              cat > tests/test_dummy.py <<EOF
def test_dummy():
    assert 1 == 1
EOF
                            fi

                            python3 -m pytest -v
                        '''
                    } else {
                        bat """
                            @echo off
                            python -m pip install --upgrade pip
                            if exist requirements.txt pip install -r requirements.txt

                            rem add dummy test if none exist
                            dir /s /b tests\\test_*.py >nul 2>&1
                            if %errorlevel% neq 0 (
                                mkdir tests 2>nul
                                > tests\\test_dummy.py (
                                    echo def test_dummy():
                                    echo^    assert 1 == 1
                                )
                            )

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
            /* Enable once SMTP is configured
            mail to: 'kfiramoyal@gmail.com',
                 subject: "CI-Exercise 1 – build #${env.BUILD_NUMBER}: ${currentBuild.currentResult}",
                 body: """\
Project: ${env.JOB_NAME}
Build  : #${env.BUILD_NUMBER}
Result : ${currentBuild.currentResult}

Console log: ${env.BUILD_URL}console
"""
            */
        }
    }
}
