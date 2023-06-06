
pipeline {
    agent any

    environment {
        //PREVIOUS_BUILDN = "${BUILD_NUMBER.toInteger() - 1}"
        PREVIOUS_BUILDN = "0"
        CURRENT_STAGE = ""
        TEST_RESULT = 0

        REGISTRY_CREDENTIAL = "ecr:us-east-1:awscreds"
        COMPUTER_REGISTRY = "855149291285.dkr.ecr.us-east-1.amazonaws.com/computers-go-img-andres"
        LINK_REGISTRY = "https://855149291285.dkr.ecr.us-east-1.amazonaws.com"
    }

    stages {

        stage('Parallel stage to fetch code and file verification'){
            parallel{
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

                stage('File verification') {
                    steps {
                        script {
                            CURRENT_STAGE = env.STAGE_NAME
                        }
                        echo '----------------FILE .tar VERIFICATION---------------'
                        sh '''
                            TAR_DIR=./computers-go.tar
                            if [ -e $TAR_DIR ]; then
                                rm ./computers-go.tar
                                echo "-------------.tar FILE HAS BEEN SUCCESSFULLY DELETED-"
                            else
                                echo "-------------.tar FILE DOES NOT EXIST--------------"
                            fi
                        '''
                    }
                }
            }
        }

        stage('Testing app - Unit testing') {
            steps{
                script {
                    CURRENT_STAGE = env.STAGE_NAME
                }
                script{
                    echo '---------------TESTING GOLANG COMPUTERS APP-----------------'
                    def testResult = sh(returnStatus: true, script: "go test")
                    env.TEST_RESULT = testResult
                    //env.TEST_RESULT = sh(returnStatus: true, script: "go test")   //sh('go test')
                    //env.TEST_RESULT = testResult
                    echo "-------HERE TEST_RESULT VAR------"
                    echo "${env.TEST_RESULT}"
                    echo "${env.CURRENT_STAGE}"
                    if (testResult == 0) {
                        // Agregar acciones adicionales en caso de éxito
                        echo "---------SUCCESS TESTING GOLANG COMPUTERS APP-----------------"
                        TEST_RESULT = 0
                    } else {
                        error "---------FAILED TESTING GOLANG COMPUTERS APP-----------------"
                        TEST_RESULT = 1
                    }
                }
            }
        }


        stage('SonarQube Analysis') {
            environment {
                scannerHome = tool 'sonar4.8'
            }
            steps {
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

        stage("Quality Gate") {
            steps {
                //timeout(time: 1, unit: 'MINUTES') {
                    // Parameter indicates whether to set pipeline to UNSTABLE if Quality Gate fails
                    // true = set pipeline to UNSTABLE, false = don't
                    waitForQualityGate abortPipeline: true
                //}
            }
        }

        /*stage('Building Go app and Docker image') {
            steps {
                script {
                    CURRENT_STAGE = env.STAGE_NAME
                }
                echo '---------------BUILDING DOCKER IMAGE-----------------'
                sh 'docker build --network=host -t computers-go:${BUILD_NUMBER} .'
            }
        }

        stage('Saving Image') {
            steps {
                script {
                    CURRENT_STAGE = env.STAGE_NAME
                }
                echo '---------------SAVING IMAGE IN .tar FILE-------------'
                sh 'docker save computers-go -o computers-go.tar'
            }
        }*/


        stage('Build Computers Image'){
            steps{
                script{
                    dockerImage = docker.build( COMPUTER_REGISTRY + ":${BUILD_NUMBER}", ".")
                }
            }
        }

        stage('Upload Computers Image to ECR') {
            steps{
                script {
                    docker.withRegistry( LINK_REGISTRY, REGISTRY_CREDENTIAL) {
                        dockerImage.push("${BUILD_NUMBER}")
                        dockerImage.push('latest')
                    }
                }
            }
        }

        /*stage('Deploy in VM') {
            steps {
                script {
                    CURRENT_STAGE = env.STAGE_NAME
                }
                echo '---------------DEPLOYING APP-------------------------'
                sh 'scp -v -o StrictHostKeyChecking=no computers-go.tar andres@192.168.0.10:/home/andres/ImagesToRun'
            }
        }


        stage('Rebuilding Image, stopping and deleting previous image'){
            parallel{
                stage('Stopping and Deleting previous Image') {
                    steps {
                        script {
                            CURRENT_STAGE = env.STAGE_NAME
                        }
                        //echo '-------------GETTING NUMBER OF IMAGE TAG--------'
                        //sh " ssh andres@192.168.10 'cd ImagesToRun && ls -la && PREVIOUS_BUILDN=\$(cat build-number) && echo \$PREVIOUS_BUILDN\' "
                        echo '-------------STOPING SERVICE OF PREVIOUS IMAGE--'
                        sh  " ssh andres@192.168.0.10 'cd ImagesToRun && docker stop \$(docker ps -q --filter ancestor=computers-go:\$(cat build-number))'" 
                        echo '-------------DELETING PREVIOUS IMAGE------------'
                        sh  "ssh andres@192.168.0.10 'cd ImagesToRun && docker image rmi computers-go:\$(cat build-number)' " 
                     }
                }

                stage('Rebuilding the image from .tar format') {
                    steps {
                        script {
                            CURRENT_STAGE = env.STAGE_NAME
                        }
                        echo '----------------CHANGING .tar FILE TO A DOCKER IMAGE--'
                        sh "ssh andres@192.168.0.10 'cd ImagesToRun && docker load -i computers-go.tar'"
                    }       
                }
            }
        }

        stage('Runing Docker Image and Saving Tag') {
            steps {
                script {
                    CURRENT_STAGE = env.STAGE_NAME
                }
                echo '---------------RUNING DOCKER IMAGE-------------------'
                sh "ssh andres@192.168.0.10 'cd ImagesToRun && docker run -d -p 8080:8080 -t computers-go:${BUILD_NUMBER}'"
                echo '-------------SAVING NUMBER OF IMAGE TAG----------'
                sh  "ssh andres@192.168.0.10 'cd ImagesToRun && echo ${BUILD_NUMBER} > build-number' " 

            }
        }*/
    }

    post{
        
        always{
            script{
            echo '-------------SENDING MESSAGE TO DISCORD CHANNEL ANDRES' 
            //def testResult = env.TEST_RESULT
            if (TEST_RESULT == 0) {
               // echo '-------------SENDING MESSAGE TO DISCORD CHANNEL ANDRES'                                                                                                                                             
               discordSend description: "(Pipeline) Computers API Project by Andrés -> Pipeline Succeded or Stopped", footer: "Build Number:${BUILD_NUMBER}", link: env.BUILD_URL, result: currentBuild.currentResult, title: JOB_NAME, thumbnail:'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d7/Desktop_computer_clipart_-_Yellow_theme.svg/220px-Desktop_computer_clipart_-_Yellow_theme.svg.png' , webhookURL: 'https://discord.com/api/webhooks/1111022539993522296/Dyulm13hj0Clo0EBGxKK08Pzglal8GmARld80rXc-opc9O-jC_w_A74Q_rS3QbjtfUjU'
            } else {
                //echo '-------------SENDING MESSAGE TO DISCORD CHANNEL ANDRES'                                                                                                                                             
                discordSend description: "(Pipeline) Computers API Project by Andrés -> Fail in stage: ${CURRENT_STAGE}", footer: "Build Number:${BUILD_NUMBER}", link: env.BUILD_URL, result: currentBuild.currentResult, title: JOB_NAME, thumbnail:'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d7/Desktop_computer_clipart_-_Yellow_theme.svg/220px-Desktop_computer_clipart_-_Yellow_theme.svg.png' , webhookURL: 'https://discord.com/api/webhooks/1111022539993522296/Dyulm13hj0Clo0EBGxKK08Pzglal8GmARld80rXc-opc9O-jC_w_A74Q_rS3QbjtfUjU'
                //echo "-------AQUI TEST_RESULT ${TEST_RESULT}"
            }
            echo '-------------------------FINISHING PIPELINE-------------'
        }
           /* echo '-------------SENDING MESSAGE TO DISCORD CHANNEL ANDRES'                                                                                                                                             
            discordSend description: "Computers API Project by Andrés -> Fail in stage: ${CURRENT_STAGE}", footer: "Build Number:${BUILD_NUMBER}", link: env.BUILD_URL, result: currentBuild.currentResult, title: JOB_NAME, thumbnail:'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d7/Desktop_computer_clipart_-_Yellow_theme.svg/220px-Desktop_computer_clipart_-_Yellow_theme.svg.png' , webhookURL: 'https://discord.com/api/webhooks/1111022539993522296/Dyulm13hj0Clo0EBGxKK08Pzglal8GmARld80rXc-opc9O-jC_w_A74Q_rS3QbjtfUjU'
            echo '---------------FINISHING PIPELINE--------------------'
        */}
    }
}
