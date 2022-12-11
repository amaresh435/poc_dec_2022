pipeline {
    agent  any
    tools {
      terraform 'terraform'
    }
    environment {
        credentials = file("POC-SA-ACCESS-KEY-FILE")
    }
    stages {
        stage('checkout') {
            steps {
                 script{
                        dir("terraform_gcp")
                        {
                            git branch: 'develop', changelog: false, poll: false, url: 'https://github.com/amaresh435/poc_dec_2022.git'
                        }
                    }
                }
            }

        stage('Plan') {
            steps {
                sh '''echo "$PWD"
                      #cd terraform_gcp
                      ls -lart
                      terraform init
                      terraform plan -out tfplan
                      terraform show -no-color tfplan > tfplan.txt
                      cat tfplan.txt
                      '''
            }
        }
        stage('Approval') {
           when {
               not {
                   equals expected: true, actual: params.autoApprove
               }
           }

           steps {
               script {
                    def plan = readFile 'terraform/tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
               }
           }
       }

        stage('Apply') {
            steps {
                sh "pwd;cd terraform/ ; terraform apply -input=false tfplan"
            }
        }
    }

  }
