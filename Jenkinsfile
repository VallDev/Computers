
pipeline {
    agent any

    environment {
        CURRENT_STAGE = ""
        STAGE_RESULT = 0

        REGISTRY_CREDENTIAL = "ecr:us-east-1:awscreds"
        COMPUTER_REGISTRY = "855149291285.dkr.ecr.us-east-1.amazonaws.com/computers-dpl-ecr-repo-img-andres"
        LINK_REGISTRY = "https://855149291285.dkr.ecr.us-east-1.amazonaws.com"

        CLUSTER = "COMPUTERS-DPL-FARGATE-CLUSTER"
        SERVICE = "computersapp"
    }

    stages {

       
            
        stage('Fetch code from Computers Repo') {
            steps {
                script {
                    CURRENT_STAGE = env.STAGE_NAME
                }
                echo '---------------STARTING PIPELINE---------------------'
                echo '---------------FETCHING CODE FROM DEV BRANCH---------'
                git branch: 'dev', url: 'https://github.com/VallDev/Computers.git'
            }
        }
            
        
        stage('Rebuilding Image, stopping and deleting previous image'){
            parallel{
                stage('Testing app - Unit testing') {
                    agent {
                        node {
                            label 'NODE-MICRO'
                            customWorkspace '/home/ubuntu/node'
                        }
                    }
                    steps{
                        script {
                            CURRENT_STAGE = env.STAGE_NAME
                        }
                        script{
                            echo '---------------TESTING GOLANG COMPUTERS APP-----------------'
                            def testResult = sh(returnStatus: true, script: "go test")
                            env.STAGE_RESULT = testResult
                            if (testResult == 0) {
                                echo "---------SUCCESS TESTING GOLANG COMPUTERS APP-----------------"
                                STAGE_RESULT = 0
                            } else {
                                error "---------FAILED TESTING GOLANG COMPUTERS APP-----------------"
                                STAGE_RESULT = 1
                            }
                        }
                    }
                }


                stage('SonarQube Analysis') {
                    environment {
                        scannerHome = tool 'sonar4.8'
                    }
                    steps {
                        script {
                            CURRENT_STAGE = env.STAGE_NAME
                        }

                        echo "---------CONNECTING TO SONARQUBE FOR CODE ANALYSIS-----------------"

                        withSonarQubeEnv('sonar') {
                        sh '''${scannerHome}/bin/sonar-scanner \
                            -Dsonar.projectKey=computer-go-project \
                            -Dsonar.projectName=computer-go-project \
                            -Dsonar.projectVersion=1.0 \
                            -Dsonar.sources=. \
                            -Dsonar.tests=. \
                            -Dsonar.test.inclusions=**/*_test.go'''
                        }
                    }       
                }
            }
        }        

        stage("Quality Gate") {
            steps {
                script {
                    CURRENT_STAGE = env.STAGE_NAME
                }

                echo "---------EVALUATING QUALITY GATE OF SONARQUBE-----------------"

                waitForQualityGate abortPipeline: true
            }
        }

        stage('Build Computers Image'){
            steps{
                script {
                    CURRENT_STAGE = env.STAGE_NAME
                }

                echo "-------------BUILDING DOCKER IMAGE---------------------"

                script{
                    dockerImage = docker.build( COMPUTER_REGISTRY + ":${BUILD_NUMBER}", ".")
                }
            }
        }

        stage('Upload Computers Image to ECR') {
            steps{
                script {
                    CURRENT_STAGE = env.STAGE_NAME
                }

                echo "-----------PUSHING DOCKER IMAGE TO ECR SERVICE OF AWS-----------------"

                script {
                    docker.withRegistry( LINK_REGISTRY, REGISTRY_CREDENTIAL) {
                        dockerImage.push("${BUILD_NUMBER}")
                        dockerImage.push('latest')
                    }
                }
            }
        }

        stage('Deploy to ECS') {
            steps {
                script {
                    CURRENT_STAGE = env.STAGE_NAME
                }

                echo "---------------DEPLOYING APPLICATION ON ECS SERVICE OF AWS-----------------"

                withAWS(credentials: 'awscreds', region: 'us-east-1') {
                    sh 'aws ecs update-service --cluster ${CLUSTER} --service ${SERVICE} --force-new-deployment'
                }
            }
        }
    }

    post{
        success {
            echo '-------------SENDING MESSAGE OF SUCCESS TO DISCORD CHANNEL ANDRES'                                                                                                                                             
            discordSend description: "(Pipeline) Computers API Project by Andrés -> Pipeline Succeded", footer: "Build Number:${BUILD_NUMBER}", link: env.BUILD_URL, result: currentBuild.currentResult, title: JOB_NAME, thumbnail:'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d7/Desktop_computer_clipart_-_Yellow_theme.svg/220px-Desktop_computer_clipart_-_Yellow_theme.svg.png' , webhookURL: 'https://discord.com/api/webhooks/1111022539993522296/Dyulm13hj0Clo0EBGxKK08Pzglal8GmARld80rXc-opc9O-jC_w_A74Q_rS3QbjtfUjU'
        }

        failure {
            echo '-------------SENDING MESSAGE TO DISCORD CHANNEL ANDRES'                                                                                                                                             
            discordSend description: "(Pipeline) Computers API Project by Andrés -> Fail in stage: ${CURRENT_STAGE}", footer: "Build Number:${BUILD_NUMBER}", link: env.BUILD_URL, result: currentBuild.currentResult, title: JOB_NAME, thumbnail:'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d7/Desktop_computer_clipart_-_Yellow_theme.svg/220px-Desktop_computer_clipart_-_Yellow_theme.svg.png' , webhookURL: 'https://discord.com/api/webhooks/1111022539993522296/Dyulm13hj0Clo0EBGxKK08Pzglal8GmARld80rXc-opc9O-jC_w_A74Q_rS3QbjtfUjU'
        }

    }
}
