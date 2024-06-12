pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'nexflare73/jenkinscheck'
        NEXT_VERSION = nextVersion()
        RANDOM_STRING = ''
    }
    stages {
        stage('Checkout') {
            steps {
                // Checkout code from the main branch
                git branch: 'main', url: 'https://github.com/csye7125-su24-team05/static-site', credentialsId: 'github-credentials'
            }
        }

        stage('Docker Init') {
            steps {
                script {
                    // Generate a random string
                    RANDOM_STRING = RandomStringGenerator.generate(10)
                    echo "Generated random string: ${RANDOM_STRING}"
                }
                withCredentials([usernamePassword(credentialsId: 'docker-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    echo 'Initializing...'
                    sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                    sh "docker buildx create --name ${RANDOM_STRING} --driver=docker-container --use"
                }   
            }
        }
        stage('Build and push Docker Image') {
            steps {
                script {
                    def version = sh(script: 'npx semantic-release --dry-run', returnStdout: true).split('\n').find { it.contains('The next release version is') }.split(' ').last().trim()
                    sh "docker buildx build --platform linux/amd64,linux/arm64 -t ${DOCKER_IMAGE}:v${NEXT_VERSION} -t ${DOCKER_IMAGE}:latest --builder ${RANDOM_STRING} --push ."
                }
            }
        }
    }
    post {
        always {
            // Cleanup
            sh "docker buildx rm ${RANDOM_STRING} -f"
            cleanWs()
        }
    }
}

// Groovy class for generating random strings
class RandomStringGenerator {
    static String generate(int length) {
        def charset = ('A'..'Z') + ('a'..'z')
        def random = new Random()
        return (1..length).collect { charset[random.nextInt(charset.size())] }.join('')
    }
}