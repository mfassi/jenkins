pipeline {
    agent any

    environment {
        retryRuns = 0
    }

    stages {
        stage("Test retry") {
            steps {
                sshagent(credentials: ['docker-ssh-container']) {
                    script {

                        stageRetries = 2
                        echo "$stageRetries"
                        for (i in [1, 2]) {
                            env.retryCount = '0'
                            retry(stageRetries) {
                                retryCount = env.retryCount as Integer
                                echo "Attempt ${retryCount + 1}/$stageRetries"
                                
                                if (retryCount > 0 && retryCount < stageRetries) {
                                    echo "sleeping"
                                    sleep(time: 1, unit: 'SECONDS')
                                }

                                retryCount ++
                                echo "retryCount=$retryCount"
                                env.retryCount = retryCount as String

                                sh "./scripts/test_retry.sh"
                            }
                        }
                    }
                }
            }
        }
    }   
}