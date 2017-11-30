pipeline {
    agent {
        docker {
            image 'urand0m/squidtor:latest' 
            args '--rm -h squidtor -p 3400:3400' 
        }
    }
    stages {
        stage('Build') {
            steps {
                echo 'curl -x 127.0.0.1:3400 wtfismyip.com/json'
            }
        }
    }
}
