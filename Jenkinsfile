pipeline {
    agent any

    stages {
        stage('scm') {
            steps {
                git branch: 'main', url: 'https://github.com/5G-Devops/java-app-demo.git'
            }
        }
    }
}