@Library('shared_lib') _
pipeline {
    agent any
    parameters {
        // choices: ['create', 'delete'], description: 'choose create or delete', name: 'action'
     choice(name: 'Action', choices: ['Create', 'Delete'], description: 'choose create or delete')
     // string defaultValue: 'radhagowthamhub', description: 'name of the docker registry ', name: 'userHub'
     string(name: 'dockerregistry', defaultValue: 'radhagowthamhub', description: 'name of the docker registry')
    // string defaultValue: 'javaapp', description: ' name of the docker image', name: 'imageName'
    string(name: 'imageName', defaultValue: 'javaapp', description: 'name of the docker imnage')
    // string defaultValue: 'v1', description: ' Tag of the docker image', name: 'imageTag'
     string(name: 'imageTag', defaultValue: 'v1', description: 'name of the docker image name')
} 
     tools {
        maven 'maven3'
     }


    stages {

                    
        stage('scm') {
            when { expression { params.Action == 'Create' } }
            steps {
                gitcheckout(
                 branch: "main",
                 url: "https://github.com/5G-Devops/java-app-demo.git"
                )
            }
        }
        stage('mvnunittest') {
            when { expression { params.Action == 'Create' } }
            steps {
                script{
                    unittest()
                }
            }
        }
        stage('mvn Intergration test') {
            when { expression { params.Action == 'Create' } }
            steps {
                script{
                    mvnintegrationTest()
                }
            }
        }
        stage('Staticcode Analysis: sonarqube') {
            when { expression { params.Action == 'Create' } }
            steps {
                script{
                    def SonarQubeCredentials = 'sonar-token'
                    staticCodeAnalysis(SonarQubeCredentials)
                }
            }
        }
        stage('Qualitygate Status check: sonarqube') {
            when { expression { params.Action == 'Create' } }
            steps {
                script{
                    def SonarQubeCredentials = 'sonar-token'
                    QualitygateStatus(SonarQubeCredentials)
                }
            }
        }
        stage('Push artifact to local/remote:nexus') {
            when { expression { params.Action == 'Create' } }
            steps {
                script{
                   MavenBuild()
                }
            }
        }
        
        stage('Docker Image Build') {
            when { expression { params.Action == 'Create' } }
            steps {
                script{
                   dockerBuild("${params.dockerregistry}", "${params.imageName}", "${params.imageTag}")
                }
            }
        }
      stage('Dockerimagescan') {
        when { expression { params.action == 'create' } }
            steps {
               script{
                  imageScan("${params.dockerregistry}", "${params.imageName}", "${params.imageTag}")
               }
           }
        }
      /*   stage('PublishDockerImage2dockerHub') {
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