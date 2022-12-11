pipeline {
    agent  any
    tools {
      terraform 'terraform'
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
                sh '''
                      echo "$PWD"
                      #cd terraform_gcp
                      ls -lart
                      terraform init
                      #terraform plan -out tfplan
                      terraform plan -no-color -compact-warnings  -lock-timeout=40m -out=plan_to_deploy.plan
                      #terraform plan -lock=false
                      #terraform show -no-color tfplan > tfplan.txt
                      #cat tfplan.txt
                  '''
            }
        }
        stage('Approval') {
           steps {
               script {
                    def plan = readFile 'plan_to_deploy.plan'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
               }
           }
       }
        stage('Apply') {
            steps {
                sh "terraform apply -auto-approve -lock-timeout=40m plan_to_deploy.plan"
            }
        }
    }

  }
