pipeline{
    agent any
    stages{
        stage('Build'){
            agent{
                docker{
                    image 'node:21-alpine'
                    //Workspace Synchronization
                    reuseNode true
                }
            }
            //adding custom cache directory for npm
            environment{
                NPM_CONFIG_CACHE = "${WORKSPACE}/.npm"
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
