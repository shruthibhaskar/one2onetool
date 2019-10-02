
pipeline {
  environment {
    registry = "104466/molregistry"
    registryCredential = 'dockerhubcreds'
    dockerImage = ''
    envDataFile = ''
  }
  agent any
  tools {nodejs "node" }
  stages {
    stage('Cloning Git') {
      steps {
        git 'https://github.com/shruthibhaskar/one2onetool.git'
      }
    }
    stage('Branch check') {
      steps {
        script {
          def scmValues = checkout scm
          echo "Branch name : ${env.BRANCH_NAME}"
          echo "scmValue GIT_BRANCH : ${scmValues.GIT_BRANCH}"
    
          if ( scmValues.GIT_BRANCH.contains('master')){
            echo "branch master-production"
            envDataFile = 'Questions.json'
              echo "envDataFile : ${envDataFile}"
          } else {
            echo "branch staging"
            envDataFile = 'Questions-test.json'
            echo "envDataFile : ${envDataFile}"
          }
        }
      }
    }
    stage('Build MOL') {
       steps {
         sh 'npm install'
       }
    }
    stage('Test MOL') {
      steps {
        sh 'npm test'
      }
    }
    stage('Build Docker Image') {
      steps{
        script {
          dockerImage = docker.build registry + ":$BUILD_NUMBER"
        }
      }
    }
    stage('Push Image - Dockerhub') {
      steps{
         script {
            docker.withRegistry( '', registryCredential ) {
            dockerImage.push()
          }
        }
      }
    }
    stage('Image Cleanup') {
      steps{
        script {
          sh "docker inspect --format '{{ .Config.Image }}' mol-one2one"
          def dockerImage = sh(returnStdout: true, script: "docker inspect --format '{{ .Config.Image }}' mol-one2one").trim()
          println("dockerImage: ${dockerImage}")

          sh "docker stop mol-one2one"
          sh "docker rm mol-one2one"
          
          sh "docker rmi ${dockerImage}"
        }
      }
    }
    stage('Update MOL') {
      steps{
         script {
           sh "docker run -dit --name mol-one2one -p 3000:3000 --env DATA_FILE='$envDataFile' '$registry:$BUILD_NUMBER'"
        }
      }
    }
  }
 post {
    success {
      emailext body: """<p>SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
      <p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>""", recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
    }
    failure {
      emailext body: """<p>FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
      <p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>""", recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
    }
  }
}