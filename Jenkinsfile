pipeline {
    agent {
        docker {
            image 'squidtor:latest' 
            args '-d --rm -h squidtor -p 3400:3400' 
        }
    }
}
