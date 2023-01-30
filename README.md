# Kubernetes_Project

CI Pipeline Script -

node{
    
    stage('Git checkout'){
        git 'https://github.com/MSFaizi/Kubernetes_Project.git'
    }
    
    stage('sending docker file to Ansible server over SSH'){
        sshagent(['ansible_demo']) {
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.43.201'
            sh 'scp /var/lib/jenkins/workspace/pipeline-demo/* ubuntu@172.31.43.201:/home/ubuntu/'
        }
            
    }
    stage('Docker Build image'){
        sshagent(['ansible_demo']){
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.43.201 cd /home/ubuntu/'
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.43.201 docker image build -t $JOB_NAME:v1.$BUILD_ID .'
        }
    }
    stage('Docker image tagging'){
        sshagent(['ansible_demo']) {
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.43.201 cd /home/ubuntu/'
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.43.201 docker image tag $JOB_NAME:v1.$BUILD_ID shamimfaizi/$JOB_NAME:v1.$BUILD_ID '
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.43.201 docker image tag $JOB_NAME:v1.$BUILD_ID shamimfaizi/$JOB_NAME:latest'
            
            
        }
    }
    
    stage('push docker images to docker hub'){
        sshagent(['ansible_demo']) {
            withCredentials([string(credentialsId: 'dockerhub_passwd', variable: 'dockerhub_passwd')]) {
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.43.201 docker login -u shamimfaizi -p ${dockerhub_passwd} '
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.43.201 docker image push shamimfaizi/$JOB_NAME:v1.$BUILD_ID '
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.43.201 docker image push shamimfaizi/$JOB_NAME:latest '
                
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.43.201 docker image rm shamimfaizi/$JOB_NAME:v1.$BUILD_ID shamimfaizi/$JOB_NAME:latest $JOB_NAME:v1.$BUILD_ID'
            }
            
       }
    }
    stage('Copy files from Ansible to kubernetes server'){
        sshagent(['kubernetes_server']) {
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.44.120'
            sh 'scp /var/lib/jenkins/workspace/pipeline-demo/* ubuntu@172.31.44.120:/home/ubuntu/'
        }
    }
    
    stage('Kubernetes Deployment using ansible'){
        sshagent(['ansible_demo']) {
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.43.201 cd /home/ubuntu/'
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.43.201 ansible-playbook ansible.yml'
            
        }
    }
}
