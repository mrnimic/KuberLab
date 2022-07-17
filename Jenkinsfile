pipeline {
    agent any
    environment {
#        registry = "cloud.canister.io:5000/hosseinkarjoo/flask"
    }
    stages {
        stage('Clone Git Project') {
            steps {
                git url: 'https://github.com/mrnimic/Pipeline_Test.git', branch: 'master'
            }
        }
#        stage('build'){
#            steps{
#                sh'docker build -t ${registry}:${BUILD_NUMBER} -t ${registry}:latest .'
#            }
#        }
    }
}