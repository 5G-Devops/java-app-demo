@Library('Shared_lib') _
pipeline {
    agent any

    stages {
        stage('scm') {
            steps {
                gitcheckout(
                     branch: "main",
                    url: "https://github.com/5G-Devops/Java_application.git"
            )
            }
        }
    }
}