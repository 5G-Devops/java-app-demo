@Library('Shared_lib') _
pipeline {
    agent any
    parameters {
     choice choices: ['create', 'delete'], description: 'choose create or delete', name: 'action'
     string defaultValue: 'radhagowthamhub', description: 'name of the docker registry ', name: 'userHub'
     string defaultValue: 'javaapp', description: ' name of the docker image', name: 'imageName'
     string defaultValue: 'v1', description: ' Tag of the docker image', name: 'imageTag'
     
}


    stages {

                    
        stage('scm') {
            when { expression { params.action == 'create' } }
            steps {
                gitcheckout(
                     branch: "main",
                    url: "https://github.com/5G-Devops/java-app-demo.git"
            )
            }
        }
        stage('mvnunittest') {
            when { expression { params.action == 'create' } }
            steps {
                script{
                    mvnTest()
                }
            }
        }
        stage('mvn Intergration test') {
            when { expression { params.action == 'create' } }
            steps {
                script{
                    mvnIntegration()
                }
            }
        }
        stage('StaticcodeAnalysis') {
            when { expression { params.action == 'create' } }
            steps {
                script{
                    Staticcodeanalysis()
                }
            }
        }
        stage('mavenBuild') {
            when { expression { params.action == 'create' } }
            steps {
                script{
                   mavenbuild()
                }
            }
        }
        stage('DockerBuild') {
            when { expression { params.action == 'create' } }
            steps {
                script{
                   dockerbuild("${params.userHub}", "${params.imageName}", "${params.imageTag}")
                }
            }
        }
       stage('Dockerimagescan') {
        when { expression { params.action == 'create' } }
            steps {
               script{
                  dockerImgscan("${params.userHub}", "${params.imageName}", "${params.imageTag}")
               }
           }
        }
        stage('PublishDockerImage2dockerHub') {
            when { expression { params.action == 'create' } }
            steps {
               script{
                  dockerPublish("${params.userHub}", "${params.imageName}", "${params.imageTag}")
               }
           }
        }
    }
}