pipeline{
    agent any
    stages{
        stage('Build'){
            agent{
                docker{
                    // lighter version: alpine
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
        stage('Unit Test'){
            agent{
                docker{
                    // lighter version: alpine
                    image 'node:21-alpine'
                    //Workspace Synchronization
                    reuseNode true
                }
            }
            steps{
                sh'''
                    test -f 'build/index.html'
                    echo "runing unit tests"
                    npm test
                '''
            }

        }
        stage('E2E'){
            agent{
                docker{
                    // lighter version: alpine
                    image 'mcr.microsoft.com/playwright:v1.39.0-jammy'
                    //Workspace Synchronization
                    reuseNode true
                }
            }
            environment{
                NPM_CONFIG_CACHE = "${WORKSPACE}/.npm"
            steps{
                sh'''
                    npm install serve
                    node_modules/.bin/serve -s build &
                    npx playwright test
                '''
            }

        }
    }
    //Java Unit - consolidated report , convenient
    post{
        always{ //contains test status(pass/fail, error messages, other relevant statistics
            junit 'test-results/junit.xml'
        }
    }
}
