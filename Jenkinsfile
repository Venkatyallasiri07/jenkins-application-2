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
