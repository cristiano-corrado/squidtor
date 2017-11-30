pipeline {
    agent {
        docker {
            image 'urand0m/squidtor:latest' 
            args '-d --rm -h squidtor -p 3400:3400' 
        }
    }
    stages {
        stage('TestProxy') {
            steps {
                echo 'Hello HELLO'
            }
        }
    }
}
