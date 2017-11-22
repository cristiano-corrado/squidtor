pipeline {
  agent {
    dockerfile {
      filename 'Dockerfile'
    }
    
  }
  stages {
    stage('DockerFile Compile') {
      steps {
        dockerShell()
      }
    }
  }
}