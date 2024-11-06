pipeline {
  agent {
    docker {
      image 'maven:v1'
      args '--user root -v /var/run/docker.sock:/var/run/docker.sock' // Mount Docker socket to access the host's Docker daemon
    }
  }
  stages {
    stage('Checkout') {
      steps {
        sh 'echo passed'
        // Checkout your repository
        git branch: 'main', url: 'https://github.com/Radhika-08/CI-CD-Pipeline.git'
      }
    }
    stage('Build and Test') {
      steps {
        sh 'ls -ltr' // List the files
        // Build the project and create a JAR file
        sh 'cd CI-CD-Pipeline && mvn clean package'
      }
    }
    stage('Static Code Analysis') {
      environment {
        SONAR_URL = "http://localhost:9000" 
      }
      steps {
        withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_AUTH_TOKEN')]) {
          sh 'cd CI-CD-Pipeline && mvn sonar:sonar -Dsonar.login=$SONAR_AUTH_TOKEN -Dsonar.host.url=${SONAR_URL}'
        }
      }
    }
    stage('Build and Push Docker Image') {
      environment {
        DOCKER_IMAGE = "maven:${BUILD_NUMBER}" 
        REGISTRY_CREDENTIALS = credentials('docker-cred')
      }
      steps {
        script {
          sh 'cd CI-CD-Pipeline && docker build -t ${DOCKER_IMAGE} .'
          def dockerImage = docker.image("${DOCKER_IMAGE}")
          docker.withRegistry('https://index.docker.io/v1/', "docker-cred") {
            dockerImage.push()
          }
        }
      }
    }
    stage('Update Deployment File') {
      environment {
        GIT_REPO_NAME = "CI-CD-Pipeline" 
        GIT_USER_NAME = "Radhika-08" 
      }
      steps {
        withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
          sh '''
            git config user.email "mansiagrawal7078@gmail.com" 
            git config user.name "Radhika-08" 
            BUILD_NUMBER=${BUILD_NUMBER}
            sed -i "s/maven:v1/maven:${BUILD_NUMBER}/g" CI-CD-Pipeline/Deployment.yml
            git add CI-CD-Pipeline/Deployment.yml
            git commit -m "Update deployment image to version ${BUILD_NUMBER}"
            git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:main
          '''
        }
      }
    }
  }
}
