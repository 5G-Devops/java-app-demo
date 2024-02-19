@Library('Shared_lib') _
pipeline {
    agent any
    parameters {
     choice choices: ['create/delete'], description: 'choose create or delete', name: 'action'
}


    stages {

          when { expression { params.action == 'create' } }
                    
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
        stage('mvn Intergration test') {
            steps {
                script{
                    mvnIntegration()
                }
            }
        }
        stage('StaticcodeAnalysis') {
            steps {
                script{
                    Staticcodeanalysis()
                }
            }
        }
        stage('mavenBuild') {
            steps {
                script{
                   mavenbuild()
                }
            }
        }
        stage('DockerBuild') {
            steps {
                script{
                   dockerbuild()
                }
            }
        }
       stage('Dockerimagescan') {
            steps {
               script{
                  dockerImgscan()
               }
           }
        }
        stage('PublishDockerImage2dockerHub') {
            steps {
               script{
                  dockerPublish()
               }
           }
        }
    }
}