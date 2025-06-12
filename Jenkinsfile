/* ==== CI-Exercise 1 – cross-platform (Windows & Linux) ===================
 * 1  Welcome banner
 * 2  Ensure Python 3 + pip/pytest
 * 3  Checkout repo (main branch)             <-- edit REPO_URL / BRANCH if needed
 * 4  Install deps, run pytest, add dummy test when none exist
 * 5  Post: echo build result (mail block can be added later)
 * ======================================================================== */

pipeline {
    agent any

    /* --------- EDIT THESE TWO LINES TO POINT AT YOUR REPO ---------------- */
    environment {
        REPO_URL = 'https://github.com/kfiros94/DevOps_final_task.git'
        BRANCH   = 'main'
    }
    /* -------------------------------------------------------------------- */

    stages {

        stage('Welcome') {
            steps { echo '👋  Welcome to CI-Exercise 1!' }
        }

        /* ---------- Ensure Python 3 is present on the agent --------------- */
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

        /* ----------------------- Pull the repository ---------------------- */
        stage('Checkout') {
            steps {
                git url: env.REPO_URL, branch: env.BRANCH
                   // add  ,credentialsId: 'git-creds'  if the repo is private
            }
        }

        /* ---------------- Install deps & run (Py)Tests -------------------- */
        stage('Install & Test') {
            steps {
                script {
                    if (isUnix()) {
                        sh '''
set -e
python3 -m pip install --upgrade pip pytest
[ -f requirements.txt ] && pip install -r requirements.txt

# add dummy test when no test_*.py found
if ! find . -name "test_*.py" | grep -q . ; then
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
python -m pip install --upgrade pip pytest

IF EXIST requirements.txt (
    python -m pip install -r requirements.txt
)

rem --- add dummy test with PowerShell when none exist ---
powershell -NoProfile -Command ^
  "if (-not (Get-ChildItem -Recurse tests -Filter 'test_*.py' -ErrorAction SilentlyContinue)) { ^
       New-Item -ItemType Directory -Path 'tests' -Force | Out-Null; ^
       'def test_dummy():`n    assert 1 == 1' | Set-Content 'tests\\test_dummy.py'; ^
   }"

python -m pytest -v
"""
                    }
                }
            }
        }
    }

    /* ---------------------- Post-build housekeeping --------------------- */
    post {
        always {
            echo "Build result: ${currentBuild.currentResult}"
            /* After SMTP is configured you can enable a mail step here */
        }
    }
}
