pipeline {
    agent {
        docker {
            image 'node:21-alpine'
            reuseNode true
        }
    }
    stages {
        stage('Build'){
            steps {
                echo 'With Docker'
                sh 'ls -la'
                sh 'node --version'
                sh 'npm --version'
                
                // This ensures Cache is stored inside the workspace
                sh '''
                    echo "Installing dependencies..."
                    mkdir -p .npm
                    npm ci --cache .npm
                    echo "Building the app..."
                    npm run build
                '''
            }

        }
        stage('Test'){
            steps{
                sh '''
                echo 'Testing'
                test -f build/index.html
                npm run test
            '''
            }
        }
    }
    post{
        always{
            sh 'mkdir test-results'
            junit 'test-results/junit.xml'
        }
    }

}
