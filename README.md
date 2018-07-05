# k8s-jenkins-toolbox

A toolbox container, meant to be used in Jenkinsfile's; kubectl and other YAML manipulation utilities.

Included:

- kubectl
- helm
- kubernetes-deploy
- jq
- yq
- curl/bash/git

It was mostly copied from [lachie83](https://github.com/lachie83/k8s-kubectl), thanks.

## Example Jenkinsfile fragment

This uses [kubernetes-cli](https://github.com/jenkinsci/kubernetes-cli-plugin) plugin to get a working KUBECONFIG.
You need to create a Credential of type Certificate (`k8s-cert-credentials` in this example) in Jenkins.

```groovy
node {
    ansiColor('xterm') {
        stage('Kubernetes Toolbox Example') {
            docker.image('rpardini/k8s-jenkins-toolbox:latest').inside() { // run block inside the toolbox container
                withKubeConfig(credentialsId: 'k8s-cert-credentials', serverUrl: 'https://some.k8s.server') { // create KUBECONFIG file
                    checkout scm // to get a git checkout inside the toolbox container
                    sh 'kubectl version' 
                    sh 'kubectl cluster-info'
                    sh 'helm --help'
                    sh 'kubernetes-deploy --help'
                    sh 'cat some/yaml/in/your/repo/file.yaml | yq -y .'
                }
            }
        }
    }
    /// ...  
}
```
