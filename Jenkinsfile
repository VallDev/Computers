
pipeline {
    agent any

    /*tools {
        maven "MAVEN3"
        jdk "OracleJDK8"
    }*/

    triggers {
        githubPush(branch: 'dev')
    }

    stages {
        stage('Fetch code from Computers Repo') {
            steps {
                echo '---------------STARTING PIPELINE---------------------'
                echo '---------------FETCHING CODE FROM DEV BRANCH---------'
                git branch: 'dev', url: 'https://github.com/VallDev/Computers.git'
            }
        }

        stage('File verification') {
            steps {
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

                //sh 'mvn install -DskipTests'
            }

            /*post {
                success {
                    echo 'Now Archiving it...'
                    */
                    //archiveArtifacts artifacts: '**/target/*.war'
            /*    }
            }*/
        }

        stage('Building Go app and Docker image') {
            steps {
                echo '---------------BUILDING DOCKER IMAGE-----------------'
                sh 'docker build --network=host -t computers-go:${BUILD_NUMBER} .'
                //sh 'mvn test'
            }
        }

        stage('Saving Image') {
            steps {
                echo '---------------SAVING IMAGE IN .tar FILE-------------'
                sh 'docker save computers-go -o computers-go.tar'
            }
        }

        stage('Deploy in VM') {
            steps {
                echo '---------------DEPLOYING APP-------------------------'
                sh 'scp -v -o StrictHostKeyChecking=no computers-go.tar andres@192.168.0.10:/home/andres/ImagesToRun'
            }
        }

        stage('Rebuilding the image from .tar format') {
            steps {
                echo '----------------CHANGING .tar FILE TO A DOCKER IMAGE--'
                sh "ssh andres@192.168.0.10 'cd ImagesToRun && docker load -i computers-go.tar'"
            }
        }

        stage('Runing Docker Image') {
            steps {
                echo '---------------RUNING DOCKER IMAGE-------------------'
                sh "ssh andres@192.168.0.10 'cd ImagesToRun && docker run -d -p 8080:8080 -t computers-go:${BUILD_NUMBER}'"

            }
        }
    }

    post{
        always{
            echo '-------------SENDING MESSAGE TO DISCORD CHANNEL ANDRES'                                                                                                                                             
                discordSend description: 'Jenkins Pipeline Build of Andres', footer: 'Un footer', image: '', link: 'env.BUILD_URL', result: 'currentBuild.currentResult', scmWebUrl: '', thumbnail: '', title: 'env.JOB_NAME', webhookURL: 'https://discord.com/api/webhooks/1105616252824731648/dT1ofLIfQVe-Zr5KYMslzrTij-k08lRUyQoD9I1zDqSCbJye7kGQEr3s3lY9nmB1XTcx'
                echo '---------------FINISHING PIPELINE--------------------'
        }
    }
}
