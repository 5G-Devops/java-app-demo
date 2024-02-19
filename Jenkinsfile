@Library('Shared_lib') _
pipeline {
    agent any
    parameters {
        string{name: 'ImageName', description: "name of the docker build", defaultValue: 'javaapp'}
        string{name: 'ImageTag', description: "tag of the docker build", defaultValue: 'v1'}
        string{name: 'DockerHubUser', description: "name of the application", defaultValue: 'radhagowthamhub'}
  //      choice {name:'action', choices: 'create/delete', description: 'choose create/delete'}
  //  }

    stages {

  //      when { experssion { params.action == 'create' } }

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
                   dockerbuild( "${params.ImageName}", "${params.ImageTag}", "${params.DockerHubUser}")
                }
            }
        }
  //      stage('Dockerimagescan') {
   //         steps {
    //            script{
    //               dockerImgscan()
     //           }
        //    }
        }
    }
}