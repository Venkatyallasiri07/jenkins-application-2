pipeline{
    agent any
    stages{
        stage('Build'){
            agent{
                docker{
                    image 'node:21-alpine'
                    reuseNode true
                }
            }
            steps{
                sh '''
                    ls -la
                    node --version
                    npm --version
                    npm ci
                    ls -la
                    npm run build
                '''
            }
        }
    }
}
