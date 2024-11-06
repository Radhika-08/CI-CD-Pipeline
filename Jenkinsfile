pipeline {
  agent {
    docker {
      image 'maven'
      args '--user root -v /var/run/docker.sock:/var/run/docker.sock' // Mount Docker socket for Docker access
   }
 }
stages {
    stage('Checkout') {
      steps {
        sh 'echo passed'
   }
 }
