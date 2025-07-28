pipeline {
    agent any
    stages {
        stage('Build') {
            agent {
                docker {
                    image 'node:21-alpine'
                    reuseNode true
                }
            }
            environment {
                JAVA_OPTS = "-Dorg.jenkinsci.plugins.durabletask.BourneShellScript.HEARTBEAT_CHECK_INTERVAL=86400"
            }
            steps {
                echo 'With Docker'
                sh 'ls -la'
                sh 'node --version'
                sh 'npm --version'
                
                // Use npm install instead of npm ci for better compatibility
                sh '''
                    echo "Installing dependencies..."
                    npm install
                    echo "Building the app..."
                    npm run build
                '''
            }
        }
    }
}
