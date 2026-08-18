pipeline {
    agent any

    environment {
        IMAGE_NAME = "ashmit359/cicd-demo-app"
        BUILD_TAG  = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Test') {
            steps {
                sh 'bash test.sh'
            }
        }

        stage('SonarQube Scan') {
            steps {
                withSonarQubeEnv('sonar-local') {
                    sh 'sonar-scanner -Dsonar.projectKey=cicd-demo-app -Dsonar.sources=.'
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t $IMAGE_NAME:$BUILD_TAG .'
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DUSER', passwordVariable: 'DPASS')]) {
                    sh '''
                        echo $DPASS | docker login -u $DUSER --password-stdin
                        docker push $IMAGE_NAME:$BUILD_TAG
                    '''
                }
            }
        }

        stage('Update Helm values') {
            steps {
                sh '''
                    sed -i "s/tag:.*/tag: \\"$BUILD_TAG\\"/" helm/cicd-demo-app/values.yaml
                    git config user.email "jenkins@local"
                    git config user.name "jenkins-bot"
                    git add helm/cicd-demo-app/values.yaml
                    git commit -m "chore: bump image tag to $BUILD_TAG"
                    git push origin main
                '''
            }
        }
    }
}
