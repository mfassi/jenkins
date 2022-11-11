pipeline {
    agent any

    environment {
        retryRuns = 0
    }

    stages {
        stage("Create dir") {
            steps {
                script {
                    sh ("""
                        rm -rf ./test_dir
                        mkdir test_dir    
                    """
                    )
                }
            }
        }

        stage("Test retry") {
            steps {
                sshagent(credentials: ['docker-ssh-container']) {
                    dir('./test_dir') {
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

                                    sh """#!/bin/bash -xe
                                    files=\$(ssh sshuser@devcon 'ls /home/sshuser/ | grep file')
                                    echo "\${files[@]}"
                                    exit 0
                                    """

                                    sh """#!/bin/bash -xe
                                    ls .
                                    /bin/bash ./scripts/deploy/test_retry.sh
                                    """
                                }
                            }
                        }
                    }

                    catchError(buildResult: 'SUCCESS', stageResult: 'UNSTABLE') {
                        sh("""
                            echo "[ERROR] - print error"
                            exit 1
                        """)
                    }
                }
            }
        }
        // stage ("Second step") {
        //     steps {
        //         script {
        //             catchError(buildResult: 'SUCCESS', stageResult:'UNSTABLE') {
        //                 sh """
        //                     echo "[ERROR] - La rama padre debería ser master. Rama padre actual es: origin/cor-20220809.dwk0111m ." > ./tests.log
        //                     echo "[ERROR] - Error en el formato del nombre de la rama. El formato correcto es: (evo,par,cor,ver)-yyyymmdd.descripción(hasta 20 caracteres)" >> ./tests.log
        //                     exit 1
        //                 """
        //             }
        //         }
        //     }

        // }
        // stage ("comment pr") {
        //     steps {
        //         script {
        //             sh '''
        //                 BB_URL="https://test.com"
        //                 APPLICACION="jenkins"
        //                 PR_ID="11"
        //                 RAMA_DESTINO='master'
        //                 curl -XPOST "${BB_URL}/projects/BITE/repos/${APLICACION}/pull-requests/${PR_ID}/comments" \
        //                 --header 'Authorization: Bearer NDAyODY0MTMwMzA2Ogzt8UTAqCMu/pdrSSg+SPVZ6But' \
        //                 --header 'Accept: application/json' \
        //                 --header 'Content-Type: application/json' \
        //                 -d "{\\"text\\": \\"Se han detectado los siguientes errores en la rama '"${RAMA_ORIGEN}"':\\n\$(sed 's/\$/\\\\n/' ./tests.log | tr -d '\\n')El proceso de merge continua... En breve estos errores supondrán la declinación automática de la PR.\\"}" 
        //             '''
        //         }
        //     }
        // }
    }
}