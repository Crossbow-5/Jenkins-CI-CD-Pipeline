//Declarative Pipeline
def VERSION='1.0.0'
pipeline {
    agent none
    environment {
        PROJECT = "CI/CD pipeline - Jenkins"
    }
    stages {
     stage('For Parallel Stages') {
      parallel {
        stage('Deploy To Development') {
            agent { label 'DEV' }
            environment {
            DEV_AWS_ACCOUNT = "053490018989"    
            DEVDEFAULTAMI = "ami-02ff607219eb02f64"
            PACKER_ACTION = "NO" //YES or NO
            TERRAFORM_APPLY = "NO" //YES or NO
            ANSIBLE_ACTION = "NO" //YES or NO
            }
            when {
                branch 'development'
            }
            stages {
                stage('Perform Packer Build') {
                    when {
                        expression {
                            "${env.PACKER_ACTION}" == 'YES'
                        }
                    }
                    steps { //Assume Role in MasterAccount AWS Account
                        withAWS(role:'DevSecOpJenkinsAssumeRole', roleAccount:'053490018989', duration: 900, roleSessionName: 'jenkins-session') {
                            sh 'pwd'
                            sh 'ls -al'
                            sh 'packer init -force packer.pkr.hcl'
                            sh 'packer validate --var-file dev-vars.pkr.json packer.pkr.hcl'
                            sh 'packer build --var-file dev-vars.pkr.json packer.pkr.hcl | tee output.txt'
                            sh "tail -2 output.txt | head -2 | awk 'match(\$0, /ami-.*/) { print substr(\$0, RSTART, RLENGTH) }' > ami.txt"
                            sh "echo \$(cat ami.txt) > ami.txt"
                            script {
                                def AMIID = readFile('ami.txt').trim()
                                sh 'echo "" >> variables.tf'
                                sh "echo variable \\\"imagename\\\" { default = \\\"$AMIID\\\" } >> variables.tf"
                            }
                        }
                    }
                }
                stage('No Packer Build') {
                    when {
                        expression {
                            "${env.PACKER_ACTION}" == 'NO'
                        }
                    }
                    steps {
                        script {
                        echo VERSION //Passing Variable From Top
                        VERSION = "2.0.0";
                        echo VERSION //Passing Variable From Stage
                        }
                        sh 'pwd'
                        sh 'ls -al'
                        sh 'echo "" >> variables.tf'
                        sh "echo variable \\\"imagename\\\" { default = \\\"${env.DEVDEFAULTAMI}\\\" } >> variables.tf"
                    }
                }
                stage('Terraform Plan') {
                    when {
                        expression {
                            "${env.TERRAFORM_APPLY}" == 'YES'
                        }
                    }
                    steps {
                        withAWS(role:'DevSecOpJenkinsAssumeRole', roleAccount:'053490018989', duration: 900, roleSessionName: 'jenkins-session') {
                            script {
                            echo VERSION
                            }
                            sh 'rm -rf .terraform'
                            sh 'rm -f prod-backend.tf'
                            sh 'terraform init'
                            sh 'terraform validate'
                            sh 'terraform plan'
                        }
                    }
                }
                stage('Terraform Apply') {
                    when {
                        expression {
                            "${env.TERRAFORM_APPLY}" == 'YES'
                        }
                    }
                    steps {
                        withAWS(role:'DevSecOpJenkinsAssumeRole', roleAccount:'053490018989', duration: 900, roleSessionName: 'jenkins-session') {
                            sh 'rm -rf .terraform'
                            sh 'terraform init'
                            sh 'terraform apply --auto-approve'
                            sh 'cat invfile'
                        }
                    }
                }
                stage('Validate Ansible Playbook & Dry Run') {
                    when {
                        expression {
                            "${env.ANSIBLE_ACTION}" == 'YES'
                        }
                    }
                    steps {
                        sh 'sleep 15'
                        sh 'ansible-playbook -i invfile docker-swarm.yml --syntax-check'
                        //Used withCredentials for dry-run as ansible plugin dont have --check option.
                        withCredentials([file(credentialsId: 'LaptopKey', variable: 'ansiblepvtkey')]) {
                        sh "sudo cp \$ansiblepvtkey $WORKSPACE"
                        sh "ls -al"
                        sh "sudo ansible-playbook -i invfile docker-swarm.yml -u ubuntu --private-key=LaptopKey.pem --check"
                        }
                          
                    }
                }
                stage('Run Ansible Playbook') {
                    when {
                        expression {
                            "${env.ANSIBLE_ACTION}" == 'YES'
                        }
                    }
                    steps {
                        //sh 'ansible-playbook -i invfile docker-swarm.yml -u ansibleadmin --private-key=/var/lib/jenkins/logs/ansibleadminkey -vv'
                        ansiblePlaybook credentialsId: 'slave-credentials', disableHostKeyChecking: true, installation: 'Ansible', inventory: 'invfile', playbook: 'docker-swarm.yml'  
                    }
                }
                stage ('Dev DAST') {
                    when {
                        expression {
                            "${env.ANSIBLE_ACTION}" == 'YES'
                        }
                    }
                  options {
                   timeout(time: 2, unit: 'MINUTES') 
                  }
                  steps {
                     sh "echo \$(cat invfile | grep  '[0-9]' | head -1) > ip.txt"
                     script {
                     def IP = readFile('ip.txt').trim()
                     sh "echo ${IP}"
                     sh "sudo docker run -t zaproxy/zap-stable zap-baseline.py -t http://${IP}:8000 || true"
                     }
                    }
                }
                stage('Approval Step'){
                    steps{
                        sh "echo Please_Provide_Approval_To_Continue"  
                        //----------------send an approval prompt-------------
                        script {
                           env.APPROVE_DESTROY = input message: 'User input required',
                           parameters: [choice(name: 'Destroy?', choices: 'no\nyes', description: 'Choose "yes" if you want to perrform terraform destroy')]
                               }
                                //-----------------end approval prompt------------
                            }
                        }
                stage('Terraform Destroy') {
                    steps {
                        withAWS(role:'DevSecOpJenkinsAssumeRole', roleAccount:'053490018989', duration: 900, roleSessionName: 'jenkins-session') {
                            sh 'rm -f prod-backend.tf'
                            sh 'terraform init'
                            sh 'terraform destroy --auto-approve'
                        }
                    }
                }
            }
        }
        stage('Deploy To Production') {
            agent { label 'PROD' }
            environment {
            PROD_AWS_ACCOUNT = "009412611595"
            PRODEFAULTAMI = "ami-0dd78b4e293f79851"
            PACKER_ACTION = "YES" //YES or NO
            TERRAFORM_APPLY = "YES" //YES or NO
            ANSIBLE_ACTION = "YES" //YES or NO
            }
            when {
                branch 'production'
            }
            stages {
                stage('Perform Packer Build') {
                    when {
                        expression {
                            "${env.PACKER_ACTION}" == 'YES'
                        }
                    }
                    steps { //Assume Role in K8S AWS Account
                        withAWS(role:'DevSecOpJenkinsAssumeRole', roleAccount:'009412611595', duration: 900, roleSessionName: 'jenkins-session') {
                            echo "${env.BUILD_NUMBER}" //Accessing env variable way 1
                            sh "echo $BUILD_NUMBER" //Accessing env variable way 2
                            sh 'pwd'
                            sh 'ls -al'
                            sh 'packer init -force packer.pkr.hcl'
                            sh 'packer validate --var-file prod-vars.pkr.json packer.pkr.hcl'
                            sh 'packer build --var-file prod-vars.pkr.json packer.pkr.hcl | tee output.txt'
                            sh "tail -2 output.txt | head -2 | awk 'match(\$0, /ami-.*/) { print substr(\$0, RSTART, RLENGTH) }' > ami.txt"
                            sh "echo \$(cat ami.txt) > ami.txt"
                            script {
                                def AMIID = readFile('ami.txt').trim()
                                sh 'echo "" >> variables.tf'
                                sh "echo variable \\\"imagename\\\" { default = \\\"$AMIID\\\" } >> variables.tf"
                            }
                        }
                    }
                }
                stage('No Packer Build') {
                    when {
                        expression {
                            "${env.PACKER_ACTION}" == 'NO'
                        }
                    }
                    steps {
                        sh 'pwd'
                        sh 'ls -al'
                        sh 'echo "" >> variables.tf'
                        sh "echo variable \\\"imagename\\\" { default = \\\"${env.PRODEFAULTAMI}\\\" } >> variables.tf"
                    }
                }
                stage('Terraform Plan') {
                    when {
                        expression {
                            "${env.TERRAFORM_APPLY}" == 'YES'
                        }
                    }
                    steps {
                        withAWS(role:'DevSecOpJenkinsAssumeRole', roleAccount:'009412611595', duration: 900, roleSessionName: 'jenkins-session') {
                            sh 'rm -rf .terraform'
                            sh 'rm -f dev-backend.tf'
                            sh 'terraform init'
                            sh 'terraform validate'
                            sh 'terraform plan'
                        }
                    }
                }
                stage('Terraform Apply') {
                    when {
                        expression {
                            "${env.TERRAFORM_APPLY}" == 'YES'
                        }
                    }
                    steps {
                        withAWS(role:'DevSecOpJenkinsAssumeRole', roleAccount:'009412611595', duration: 900, roleSessionName: 'jenkins-session') {
                            sh 'rm -rf .terraform'
                            sh 'terraform init'
                            sh 'terraform apply --auto-approve'
                        }
                    }
                }
                stage('Validate Ansible Playbook & Dry Run') {
                    when {
                        expression {
                            "${env.ANSIBLE_ACTION}" == 'YES'
                        }
                    }
                    steps {
                        sh 'sleep 15'
                        sh 'ansible-playbook -i invfile docker-swarm.yml --syntax-check'
                        //Used withCredentials for dry-run as ansible plugin dont have --check option.
                        withCredentials([file(credentialsId: 'LaptopKey', variable: 'ansiblepvtkey')]) {
                        sh "sudo cp \$ansiblepvtkey $WORKSPACE"
                        sh "ls -al"
                        sh "sudo ansible-playbook -i invfile docker-swarm.yml -u ubuntu --private-key=LaptopKey.pem --check"
                        }
                          
                    }
                }
                stage('Run Ansible Playbook') {
                    when {
                        expression {
                            "${env.ANSIBLE_ACTION}" == 'YES'
                        }
                    }
                    steps {
                        //sh 'ansible-playbook -i invfile docker-swarm.yml -u ansibleadmin --private-key=/var/lib/jenkins/logs/ansibleadminkey -vv'
                        ansiblePlaybook credentialsId: 'slave-credentials', disableHostKeyChecking: true, installation: 'Ansible', inventory: 'invfile', playbook: 'docker-swarm.yml'  
                    }
                }
                stage ('Production DAST') {
                    when {
                        expression {
                            "${env.ANSIBLE_ACTION}" == 'YES'
                        }
                    }
                  options {
                    timeout(time: 2, unit: 'MINUTES') 
                  }
                  steps {
                     sh "echo \$(cat invfile | grep  '[0-9]' | head -1) > ip.txt"
                     script {
                     def IP = readFile('ip.txt').trim()
                     sh "echo ${IP}"
                     sh "sudo docker run -t zaproxy/zap-stable zap-baseline.py -t http://${IP}:8000 || true"
                     }
                    }
                }
                stage('Approval Step'){
                    steps{
                        sh "echo Please_Provide_Approval_To_Continue"  
                        //----------------send an approval prompt-------------
                        script {
                           env.APPROVE_DESTROY = input message: 'User input required',
                           parameters: [choice(name: 'Destroy?', choices: 'no\nyes', description: 'Choose "yes" if you want to perrform terraform destroy')]
                               }
                                //-----------------end approval prompt------------
                            }
                        }
                stage('Terraform Destroy') {
                    steps {
                        withAWS(role:'DevSecOpJenkinsAssumeRole', roleAccount:'009412611595', duration: 900, roleSessionName: 'jenkins-session') {
                            sh 'rm -f dev-backend.tf'
                            sh 'terraform init'
                            sh 'terraform destroy --auto-approve'
                            //sh 'false' //This will fail the stage.
                        }
                    }
                }
            }
        }

      }
    }
  }
    post {
      success {
          slackSend(color: 'good', message: "Pipeline Successfull: ${env.JOB_NAME} ${env.BUILD_NUMBER} ${env.BUILD_URL}") 
      }
      failure {
          slackSend(color: 'danger', message: "Pipeline Failed: ${env.JOB_NAME} ${env.BUILD_NUMBER} ${env.BUILD_URL}") 
      }
      aborted {
          slackSend(color: 'warning', message: "Pipeline Aborted: ${env.JOB_NAME} ${env.BUILD_NUMBER} ${env.BUILD_URL}")
      }
      always {
          echo "I always run."
      }
    }
}
