@Library('Shared_lib') _
pipeline {
    agent any
    parameters{

        choice{name:'action', choices: 'create/delete', description: 'choose create/delete'}
    }

    stages {

        when { experssion { params.action == 'create' } }
        
        stage('scm') {
            steps {
                gitcheckout(
                     branch: "main",
                    url: "https://github.com/5G-Devops/java-app-demo.git"
            )
            }
        }
        stage('mvnunittest') {
            steps {
                script{
                    mvnTest()
                }
            }
        }
    }
}