pipeline {
    agent any
    parameters {
        choice(name: 'OS', choices: ['linux', 'darwin', 'windows', 'all'], description: 'Pick OS')
        choice(name: 'ARCH', choices: ['amd64', 'arm64'], description: "Pick ARCH")
    }
    environment {
        REPOSITORY = "https://github.com/ng-n/kbot"
        BRANCH = "main"
        PATH = "/usr/local/go/bin:${env.PATH}"
    }
    stages {
        stage('Example') {
            steps {
                echo "Build for platform ${params.OS}"
                echo "Build for arch: ${params.ARCH}"
            }
        }

        stage('clone'){
            steps{
                echo "Cloning repository..."
                git branch: "${BRANCH}", url: "${REPOSITORY}"
            }
        }

        stage('test'){
            steps {
                echo "Testing kbot code..."
                sh "make test"
            }
        }

        stage('build'){
            steps{
                echo "Setting kbot..."
                sh "make build TARGETOS=${params.OS} TARGETARCH=${params.ARCH}"
            }
        }

        stage('image'){
            steps{
                echo "Bulding docker image"
                sh "make image"
            }
        }

        stage('push'){
            steps{
                echo "Pushing docker image..."
                script {
                    docker.withRegistry('','dockerhub'){
                        sh 'make push'
                    }
                }
            }
        }

    }
}
