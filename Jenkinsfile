pipeline{
    agent any

    environment {
        DOCKER_IMAGE = 'eshop-backend'
    }

    options {
        ansiColor('xterm')
    }

    stages{
        stage("build image docker"){
            steps {
                echo '****** Build and tag image ******'

                sh './jenkins/build.sh'
            }
        }
        stage("Deploy image docker"){
            steps {
                echo '****** Deploy image ******'

                sh './jenkins/deploy.sh'
            }
        }
    }
}
