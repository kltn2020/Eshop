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
                echo $GIT_COMMIT
                script {
                    docker.build DOCKER_IMAGE + ":$BUILD_NUMBER"
                }
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
