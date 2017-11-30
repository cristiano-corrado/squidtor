pipeline {
    agent none
    stages {
        stage('Back-end') {
            agent {
                docker { image 'urand0m/squidtor:latest' 
                         args '-h squidtor -p 3400:3400'
                       }
            }
            steps {
                sh 'id'
            }
        }
        stage('Front-end') {
            agent any
                
            
            steps {
                sh 'id'
            }
        }
    }
}
