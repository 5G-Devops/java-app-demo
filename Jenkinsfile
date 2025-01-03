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
    string(name: 'Cluster', defaultValue: 'demo-cluster', description: 'name of the EKS-Cluster')
} 
// Configuring access and secret keys (Without hardcoding in terraform scripts)
// for this we have to create credentials (secret text) for access and secret keys in jenkins
     environment{   
        ACCESS_KEY = credentials('ACCESS_KEY')
        SECRET_KEY = credentials('SECRET')
     }
     tools {
        maven 'maven3'
        terraform 'terraform'
     }


    stages {

                    
        stage('scm') {
            when { expression { params.Action == 'create' } }
            steps {
                gitcheckout(
                 branch: "main",
                 url: "https://github.com/5G-Devops/java-app-demo.git"
                )
            }
        }
        stage('mvnunittest: maven') {
            when { expression { params.Action == 'create' } }
            steps {
                script{
                    unittest()
                }
            }
        }
        stage('mvn Intergration test: maven') {
            when { expression { params.Action == 'create' } }
            steps {
                script{
                    mvnintegrationTest()
                }
            }
        }
        stage('Staticcode Analysis: sonarqube') {
            when { expression { params.Action == 'create' } }
            steps {
                script{
                    def SonarQubeCredentials = 'sonar-token'
                    staticCodeAnalysis(SonarQubeCredentials)
                }
            }
        }
        stage('Qualitygate Status check: sonarqube') {
            when { expression { params.Action == 'create' } }
            steps {
                script{
                    def SonarQubeCredentials = 'sonar-token'
                    QualitygateStatus(SonarQubeCredentials)
                }
            }
        }
        stage('Push artifact to local/remote:nexus') {
            when { expression { params.Action == 'create' } }
            steps {
                script{
                   MavenBuild()
                }
            }
        }
        
        stage('Docker Image Build') {
            when { expression { params.Action == 'create' } }
            steps {
                script{
                   dockerBuild("${params.dockerregistry}", "${params.imageName}", "${params.imageTag}")
                }
            }
        }
      stage('Dockerimagescan') {
        when { expression { params.Action == 'create' } }
            steps {
               script{
                  imageScan("${params.dockerregistry}", "${params.imageName}", "${params.imageTag}")
               }
           }
        }
         stage('PublishDockerImageTodockerRegistry') {
            when { expression { params.Action == 'create' } }
            steps {
               script{
                  imagePush("${params.dockerregistry}", "${params.imageName}", "${params.imageTag}")
               }
           }
        }
        stage('DockerImage CleanUp') {
            when { expression { params.Action == 'create' } }
            steps {
               script{
                  DockerImageCleanUp("${params.dockerregistry}", "${params.imageName}", "${params.imageTag}")
               }
           }
        }
// CI part is Completed and now whave to create Infrastructure/EKS Cluster using Terraform for deploying application
        stage('Creating EKS Cluster: Terraform'){
            when { expression { params.Action == 'create' } }
            steps{
                script{
                    dir('eks_module') {  // Terraform scripts are placed in 'eks_module' in same repo, To switch to that repo use pipeline snippet generator "change current directory"
                  //  def REGION: "ap-south-1"

                   sh """ 
                      terraform init
                      terraform plan -var 'access_key=$ACCESS_KEY' -var 'secret_key=$SECRET_KEY' -var 'region=${params.Region}' --var-file=./config/terraform.tfvars
                      terraform apply -var 'access_key=$ACCESS_KEY' -var 'secret_key=$SECRET_KEY' -var 'region=${params.Region}' --var-file=./config/terraform.tfvars --auto-approve
                   """
                   
   
                  }
                }
            }
        }
        // Connect to the EKS Cluster
        stage('Connect to the EKS cluster'){
            when { expression { params.Action == 'create' } }
            steps{
                script{
                    sh """
                    aws configure set aws_access_key_id $ACCESS_KEY
                    aws configure set aws_secret_key_id $SECRET_KEY
                    aws configure set aws_region ${params.Region}
                    aws eks --region ${params.Region} update-kubeconfig --name ${'Cluster'}
                    kubectl get nodes
                     
                    """
                }
            }
        }
        stage('Deployment on EKS Cluster'){
            when { expression {  params.action == 'create' } }
            steps{
                script{
                  
                  def apply = false

                  try{
                    input message: 'please confirm to deploy on eks', ok: 'Ready to apply the config ?'
                    apply = true
                  }catch(err){
                    apply= false
                    currentBuild.result  = 'UNSTABLE'
                  }
                  if(apply){

                    sh """
                      kubectl apply -f .
                    """
                  }
                }
            }
        }   
    } 
} 
