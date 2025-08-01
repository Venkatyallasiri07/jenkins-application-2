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
                    npm ci
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

}
