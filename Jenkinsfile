pipeline{
    agent any
    stages{
        environment{
            NETLIFY_SITE_ID = '9a836635-14fd-4315-a544-3e1903dd31c2'
        }
        /*
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
                //ci will acts as install with more compatibility to ci pipeline
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
        */
        stage('Tests'){
            parallel{
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
                        //checking the file existence and running unit tests 
                        sh'''
                            test -f 'build/index.html' 
                            echo "runing unit tests"
                            npm test
                        '''
                    }
                        //Java Unit - consolidated report , convenient
                    post{
                        always{ //contains test status(pass/fail, error messages, other relevant statistics)
                            junit 'jest-results/junit.xml'
                        }    
                    }

                }
                stage('E2E'){
                    agent{
                        docker{
                            // lighter version for playwright
                            image 'mcr.microsoft.com/playwright:v1.39.0-jammy'
                            //Workspace Synchronization
                            reuseNode true
                        }
                    }
                    // The Playwright Docker image runs processes as a non-root user (UID 980). npm's default cache directory is /.npm (root-owned inside container), so npm tries to create /.npm and gets permission denied. Result: npm ERR! chmod mkdir /.npm → stage aborts.
                    // Making npm use a workspace-local cache (not /.npm) inside the Playwright container
                    // environment { NPM_CONFIG_CACHE = ".npm" } tells npm to use ./.npm inside workspace — writable by the non-root user used by the Playwright image.
                    environment{
                        NPM_CONFIG_CACHE = "${WORKSPACE}/.npm"
                    }
                    steps{
                        // & and sleep will help to avoid endless loop
                        //Playwright Test comes with a few built-in reporters for different needs and ability to provide custom reporters. The easiest way to try out built-in reporters is to pass --reporter command line option.
                        sh'''
                            npm install serve
                            node_modules/.bin/serve -s build &
                            sleep 10
                            npx playwright test --reporter=html
                        '''
                    }
                    post{
                        always{
                            //used for pipeline syntax to publish html reports
                            publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Playwright HTML Report', reportTitles: '', useWrapperFileDirectly: true])
                        }
                    }                    

                }                
                
            }
        }
        stage('Deploy'){
            agent{
                docker{
                    // lighter version: alpine
                    image 'node:21-alpine'
                    //Workspace Synchronization
                    reuseNode true
                }
            }
            steps{
                //ci will acts as install with more compatibility to ci pipeline
                sh '''
                    npm install -g netlify-cli
                    node_modules/.bin/netlify --version
                    echo "Deploying to production, Site Id: $NETLIFY_SITE_ID"
                '''
            }
        }

    }

}
