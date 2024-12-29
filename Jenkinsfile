@Library('shared_lib') _
pipeline {
    agent any
    parameters {
        // choices: ['create', 'delete'], description: 'choose create or delete', name: 'action'
     choice(name: 'Action', choices: ['Create', 'Delete'], description: 'choose create or delete')
    // string defaultValue: 'radhagowthamhub', description: 'name of the docker registry ', name: 'userHub'
    // string defaultValue: 'javaapp', description: ' name of the docker image', name: 'imageName'
    // string defaultValue: 'v1', description: ' Tag of the docker image', name: 'imageTag'
     
} 
     tools {
        maven 'maven3'
     }


    stages {

                    
        stage('scm') {
            when { expression { params.action == 'Create' } }
            steps {
                gitcheckout(
                 branch: "main",
                 url: "https://github.com/5G-Devops/java-app-demo.git"
                )
            }
        }
        stage('mvnunittest') {
            when { expression { params.action == 'Create' } }
            steps {
                script{
                    unittest()
                }
            }
        }
        stage('mvn Intergration test') {
            when { expression { params.action == 'Create' } }
            steps {
                script{
                    mvnintegrationTest()
                }
            }
        }
        stage('StaticcodeAnalysis') {
            when { expression { params.action == 'Create' } }
            steps {
                script{
                    def SonarQubeCredentials = 'sonar-token'
                    staticCodeAnalysis(SonarQubeCredentials)
                }
            }
        }
      /*   stage('mavenBuild') {
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
        */
    } 
} 