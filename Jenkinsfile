pipeline {
    agent  any
    tools {
      terraform 'terraform'
    }
    environment {
        credentials = file('POC-SA-ACCESS-KEY-FILE')
    }
    stages {
        stage('checkout') {
            steps {
                 script{
                        dir("terraform")
                        {
                            git "https://github.com/amaresh435/poc_dec_2022.git"
                        }
                    }
                }
            }

        stage('Plan') {
            steps {
                sh "terraform init"
                sh "terraform plan -out tfplan"
                sh "terraform show -no-color tfplan > tfplan.txt"
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
