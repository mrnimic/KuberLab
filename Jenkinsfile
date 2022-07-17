pipeline {
    agent any
    stages {
        stage('Clone Git Project') {
            steps {
                git url: 'https://github.com/mrnimic/Pipeline_Test.git', branch: 'master'
            }
        }
    }
}