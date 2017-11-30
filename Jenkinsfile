pipeline {
    agent none
    stages {
        stage('Back-end') {
            agent {
                docker { image 'urand0m/squidtor:latest' }
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
