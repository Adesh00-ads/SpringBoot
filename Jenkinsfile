pipeline {
  agent any
  parameters {
    string 'JDK_VERSION'
    choice name: 'BUILD' ,choices: ['DEV','TEST','PROD']
    password name: 'DB_PASSWORD', defaultValue: 'test', description: 'db pwd'
    test name: 'DESC'
    booleanParam name: 'DEPLOY', description: 'do you want to deploy'
  }
  stages {
    stage("print") {
      steps {
       echo '${params.JDK_VERSION}'
       echo '${params.BUILD}'
       echo '${params.DB_PASSWORD}'
       echo '${params.DESC}'
       echo '${DEPLOY}'
      }
    }

  }
}