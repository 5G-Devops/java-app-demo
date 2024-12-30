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
     string(name: 'Region', defaultValue: 'ap-south-1', description: 'name of the region')
} 
// Configuring access and secret keys (Without hardcoding in terraform scripts)
// for this we have to create credentials (secret text) for access and secret keys in jenkins
     environment{   
        ACCESS_KEY = credentials('')
        SECRET_KEY = credentials('')
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
        stage('mvnunittest: maven') {
            when { expression { params.Action == 'Create' } }
            steps {
                script{
                    unittest()
                }
            }
        }
        stage('mvn Intergration test: maven') {
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
        when { expression { params.Action == 'Create' } }
            steps {
               script{
                  imageScan("${params.dockerregistry}", "${params.imageName}", "${params.imageTag}")
               }
           }
        }
         stage('PublishDockerImageTodockerRegistry') {
            when { expression { params.Action == 'Create' } }
            steps {
               script{
                  imagePush("${params.dockerregistry}", "${params.imageName}", "${params.imageTag}")
               }
           }
        }
        stage('DockerImage CleanUp') {
            when { expression { params.Action == 'Create' } }
            steps {
               script{
                  DockerImageCleanUp("${params.dockerregistry}", "${params.imageName}", "${params.imageTag}")
               }
           }
        }
// CI part is Completed and now whave to create Infrastructure/EKS Cluster using Terraform for deploying application
        stage('Creating EKS Cluster: Terraform'){
            steps{
                script{
                    dir('eks_module') {  // Terraform scripts are placed in 'eks_module' in same repo, To switch to that repo use pipeline snippet generator "change current directory"
                  //  def REGION: "ap-south-1"

                   sh """ 
                      terrraform init
                      terraform plan -var 'access_key=$ACCESS_KEY' -var 'secret_key=$SECRET_KEY' -var 'region=${params.Region}' --var=./config/terraform.tfvars
                      terraform apply -var 'access_key=$ACCESS_KEY' -var 'secret_key=$SECRET_KEY' -var 'region=${params.Region}' --var=./config/terraform.tfvars --auto-approve
                   """
                   
   
                  }
                }
            }
        }
        
    } 
} 