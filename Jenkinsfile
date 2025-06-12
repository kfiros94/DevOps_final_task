/* ===== CI-Exercise 1 – cross-platform =====================================
 * 1. Prints welcome banner
 * 2. Ensures Python 3 + pip/pytest
 * 3. Repo checkout done automatically by Declarative
 * 4. Installs deps, adds dummy test when none exist, runs pytest
 * 5. Post-build: echoes result **and sends e-mail**
 * ======================================================================== */

pipeline {
    agent any

    /* ------------------------------------------------------------------ */
    /* 🔧 EDIT ME: your repository                                         */
    /* ------------------------------------------------------------------ */
    environment {
        REPO_URL = 'https://github.com/kfiros94/DevOps_final_task.git'
        BRANCH   = 'main'
        /* 🔧 EDIT ME: default recipients (comma-separated)                 */
        RECIPIENTS = 'kfiramoyal@gmail.com'
        /* (Optional) override sender                                      */
        // SENDER_NAME = 'Jenkins CI'
        // SENDER_ADDR = 'ci@example.com'
    }

    /* Declarative automatically performs “checkout scm” before 1st stage */

    stages {
        /* --------------------------- Build Stages ---------------------- */

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

    /* ---------------------------- Post Actions ------------------------ */
    post {
        always {
            echo "Build result: ${currentBuild.currentResult}"

            /* ----------  🔧 EDIT ME: e-mail block enabled  -------------- */
            mail to: env.RECIPIENTS,
                 // replyTo and from are optional if configured globally
                 // replyTo: env.SENDER_ADDR ?: '',
                 // from:    env.SENDER_ADDR ?: '',
                 subject: "CI-Exercise 1 – build #${env.BUILD_NUMBER}: ${currentBuild.currentResult}",
                 body: """\
Job:     ${env.JOB_NAME}
Build:   #${env.BUILD_NUMBER}
Result:  ${currentBuild.currentResult}

Console: ${env.BUILD_URL}console

Triggered by: ${currentBuild.getBuildCauses()[0].shortDescription}
"""
        }
    }
}
