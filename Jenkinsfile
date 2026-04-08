pipeline {
    agent any

    stages {
        stage('Checkout Code From Git') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/nxttha211/ttb-mobile-automation.git'
            }
        }

        stage('Run Test Automate') {
            steps {
                sh 'pip install -r requirements.txt'
                sh 'robot --outputdir results tests/'
            }
        }

        stage('Send Result To Jenkins') {
            steps {
                robot outputPath: 'results',
                      logFileName: 'log.html',
                      outputFileName: 'output.xml',
                      reportFileName: 'report.html'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'results/*', allowEmptyArchive: true
        }
    }
}
