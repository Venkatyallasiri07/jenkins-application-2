pipeline {
    agent any
    stages {
        stage('Build') {
            agent{
                docker{ 
                    image 'node:21-alpine'
                    reuseNode true
                }    
            }
            steps {
                echo 'With Docker'
                sh 'ls -la'
                sh 'node --version'
                sh 'npm --version'
                sh 'npm  ci'
                sh 'npm run build'
                
            }
        }
    }
}
