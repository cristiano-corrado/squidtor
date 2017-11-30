
pipeline {
  agent none
   stages {
     stage('Build') {
      agent {
       docker {
        image 'urand0m/squidtor:latest'
         args '--rm -h squidtor -p 3400:3400'     
       }
       steps {
           sh 'id'
        }
      }
    }
    
      stage('Test Proxy') {
        steps {
          sh 'which curl && curl -x 127.0.0.1:3400'
      }
    }
  }
}
