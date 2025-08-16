pipeline{
    agent any
    environment{
        //adding custom cache directory for npm
        // The Playwright Docker image runs processes as a non-root user (UID 980). npm's default cache directory is /.npm (root-owned inside container), so npm tries to create /.npm and gets permission denied. Result: npm ERR! chmod mkdir /.npm → stage aborts.
        // Making npm use a workspace-local cache (not /.npm) inside the Playwright container
        // environment { NPM_CONFIG_CACHE = ".npm" } tells npm to use ./.npm inside workspace — writable by the non-root user used by the Playwright image.
        NPM_CONFIG_CACHE = "${WORKSPACE}/.npm"
        //To set a writable configuration directory
        //This will redirect the configuration files to the workspace, where the Jenkins user has full write permissions.
        XDG_CONFIG_HOME = "${WORKSPACE}/.config"
        NETLIFY_SITE_ID = '9a836635-14fd-4315-a544-3e1903dd31c2'
        NETLIFY_AUTH_TOKEN = credentials('jenkins-token')
        REACT_APP_VERSION = "1.0.$BUILD_ID"
    }
    stages{
        stage('Build'){
            agent{
                docker{
                    // lighter version: alpine
                    image 'node:20-bookworm-slim'
                    //Workspace Synchronization
                    reuseNode true
                }
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
                            // custom playwright
                            image 'playwright-docker'
                            //Workspace Synchronization
                            reuseNode true
                        }
                    }
                    steps{
                        // & and sleep will help to avoid endless loop
                        //Playwright Test comes with a few built-in reporters for different needs and ability to provide custom reporters. The easiest way to try out built-in reporters is to pass --reporter command line option.
                        sh'''
                            serve -s build &
                            sleep 10
                            npx playwright test --reporter=html
                        '''
                    }
                    post{
                        always{
                            // used for pipeline syntax to publish html reports
                            // needs to maintain unique reportName, when publishing multiple HTML reports
                            publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Playwright Local', reportTitles: '', useWrapperFileDirectly: true])
                        }
                    }                    

                }                
                
            }
        }
        stage('Deploy Staging'){
            agent{
                docker{
                    // lighter version for playwright
                    image 'playwright-docker'
                    //Workspace Synchronization
                    reuseNode true
                }
            }
            environment{
                // setting up the target environment as production, for after-deploy testings
                CI_ENVIRONMENT_URL = 'STAGING_URL_TO_BE_SET'
            }
            steps{
                // & and sleep will help to avoid endless loop
                //Playwright Test comes with a few built-in reporters for different needs and ability to provide custom reporters. The easiest way to try out built-in reporters is to pass --reporter command line option.
                sh'''
                    echo 'checking netlify version Installed from dockerfile'
                    netlify --version
                    echo "deploying to production, site id: $NETLIFY_SITE_ID"
                    netlify status
                    netlify deploy --dir=build --json > stage-deploy-output.json
                    CI_ENVIRONMENT_URL=$(node-jq -r '.deploy_url' stage-deploy-output.json)
                    echo 'above is staging deployment status'
                    echo 'post staging-deployment tests'
                    npx playwright test --reporter=html
                '''
            }
            post{
                always{
                    // used for pipeline syntax to publish html reports
                    // needs to maintain unique reportName, when publishing multiple HTML reports
                    publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Staging E2E', reportTitles: '', useWrapperFileDirectly: true])
                }
            }                    

        }

        stage('Approval'){
            steps{
                timeout(time: 10, unit: 'MINUTES') {
                    input cancel: 'Reject', message: 'Do you wish to deploy to production', ok: 'Yes, i am sure!'
            }
            }
            
        }
        stage('Deploy Prod'){
            agent{
                docker{
                    // lighter version for playwright
                    image 'playwright-docker'
                    //Workspace Synchronization
                    reuseNode true
                }
            }
            environment{
                // setting up the target environment as production, for after-deploy testings
                CI_ENVIRONMENT_URL = 'https://incomparable-youtiao-ba54e4.netlify.app'
            }
            steps{
                // & and sleep will help to avoid endless loop
                //Playwright Test comes with a few built-in reporters for different needs and ability to provide custom reporters. The easiest way to try out built-in reporters is to pass --reporter command line option.
                sh'''
                    echo 'checking netlify version Installed from dockerfile'
                    netlify --version
                    echo "deploying to production, site id: $NETLIFY_SITE_ID"
                    netlify status
                    netlify deploy --dir=build --prod
                    echo 'above is prod deployment status'
                    echo 'post deployment tests...'
                    npx playwright test --reporter=html
                '''
            }
            post{
                always{
                    //used for pipeline syntax to publish html reports
                    // needs to maintain unique reportName, when publishing multiple HTML reports
                    publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Prod E2E', reportTitles: '', useWrapperFileDirectly: true])
                }
            }                    

        }  
    }

}
