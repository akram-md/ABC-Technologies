# abctechnologies code
# INDUSTRIAL GRADE PROJECT REPORT – I
This is the repo for Edureka Post Graduate Program in DevOps - Industrial Grade Project I (Batch 47)

Business Challenge Requirement
ABC technologies is a leading online retail store. ABC has recently acquired a large retails offline business store. The business store has large number of stores across the globe but is following conventional pattern of development and deployment. As a result, it has landed to great loss and are facing below challenges. 
• low available  
• low scalable  
• low Performance  
• Hard built and maintained  
• Developed and deployed is time consuming 

ABC will acquire the data from all these storage systems and plan to use it for analytics and prediction of the firm’s growth and sales prospect. In the first phase ABC has to create the servlets to Add a product and Display product details. Add servlet dependencies required to compile the servlets. Create an HTML page which will be used to add a product. Team is using git to keep all the source code.  

ABC has decided to use DevOps model and once source code is available in Github, we need to integrate it with Jenkins and provide continuous build generation for continuous Delivery, integrate with Ansible and Kubernetes for deployment. Use docker hub to pull and push images between ansible and Kubernetes.  

1.	Pre-requisites Setup (AWS EC2)
Make sure the following are installed on your system or cloud environment:
•	Java
•	Maven
•	Git bash (windows) or git installed on laptop
•	Jenkins
•	Docker
•	Ansible
•	Kubernetes (Minikube or EKS)
•	Prometheus
•	Grafana

2.	Project Set up
Git bash (windows) or git installed on local laptop

Pre-requisites: 
- Need to have Git bash (windows) or git installed on laptop
- Should have an account on github

Steps:
1.	Start the gitbash
2.	Goto the project codebase

3.	Initialize the project by using init
$ git init

4.	Add the project I by using add to track the contents
$ git add .

5.	Do the git status to see the untracked files in the staging area
$ git status

6.	Do the git commit –m to commit the files in the staging area
$ git commit -m "ABC Technologies"
 
7.	Check if all the files are tracked
$ git status
$ git log (First commit ABC Technologies is created)

Set Up GitHub Repository:
1.	Login into your github: https://github.com/akram-md
2.	Goto Repositories - > https://github.com/akram-md?tab=repositories -> Create a new repositories
3.	Named the repository as “ABC Technologies” and enter description as “ This is the repo for Edureka Post Graduate Program in DevOps - Industrial Grade Project I (Batch 47)” and then click on “Create Repository”

4.	Push an existing repository (codebase) of “ABC Technologies” from the local laptop (git) to the github 
URL of the Git Repo: https://github.com/akram-md/ABC-Technologies.git

Add the remote repository using the recommended step in the github (see below)
git remote add origin https://github.com/akram-md/ABC-Technologies.git
git branch -M main
git push -u origin main (local branch) (-u sets up tacking between local master/main and github master/main)
ABC-Technologies repo is created

Optional: 
During git push -u origin main, it may ask to enter the github user id and password to connect


3.	Jenkins CI Pipeline Setup on AWS EC2 Instance (Continuous Integration)

Project Tasks (Approach to Solve)
Task 1: Clone the project from git hub link shared in resources to your local machine. Build the code using maven commands. 
Task 2: Setup git repository and push the source code. Login to Jenkins 
1.	create a build pipeline containing a job each
•	One for compiling source code 
•	Second for testing source code 
•	Third for packing the code 
2.	Execute CICD pipeline to execute the jobs created in step1 
3.	Setup master-slave node to distribute the tasks in pipeline

Pre requisites
•	Need to create a Jenkins server (Public Cloud like AWS, Azure, GCP or use laptop and create VM on your laptop using oracle virtual box)
•	Jenkins needs to be installed on the server (Follow Jenkins Installation Instructions: https://www.jenkins.io/doc/book/installing/linux/)
•	Configure Jenkins
•	Install plugins that are required to perform CI - git, maven
•	Install git plugin on Jenkins (by default it will install if we choose install suggested plugins)
•	Install maven as well (maven can be installed as a plugin OR we can install maven directly on server and use it via shell)


Git install on AWS EC2
sudo apt install git –y
git –version

Maven install on AWS EC2
sudo apt install maven -y
mvn –version

Jenkins install on AWS EC2
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins


Starting a Jenkins
- Enable the Jenkins service to start at boot with the command:
o	sudo systemctl enable Jenkins

- Starting the Jenkins service with the command:
o	sudo systemctl start Jenkins

- Check the status of the Jenkins service using the command:
o	sudo systemctl status jenkins


Configure Jenkins
Pre requisites
Set the security group in AWS EC2 to set Jenkins to listen on port 8080 under security group in AWS EC2
Launch the Jenkins URL: http://3.98.131.118:8080/

Creating a CI Pipeline in Jenkins
CI -> Download (cloning), compile, unit test, package (war folder)

Create a Pipeline:
1.	New Item > Pipeline
2.	In Pipeline section, select "Pipeline script from SCM"
3.	Choose Git, enter repository URL
4.	For Script Path, enter "Jenkinsfile"

Jenkinsfile (created in project root):
pipeline {
    agent any
    stages {
        stage('Task 1: Code Checkout (Clone)') {
            steps {
                git branch: 'main', url: 'https://github.com/akram-md/ABC-Technologies'
            }
        }
        stage('Task 2: Code Compile (Build)') {
            steps {
                sh 'mvn clean compile'
            }
        }
        stage('Task 2: Unit Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Task 2: Code Package') {
            steps {
                sh 'mvn package'
            }
        }
    }
}

To use the Jenkins master-slave (agent) setup in the existing pipeline, we need to assign specific stages to run on the slave node, which is useful for load distribution (e.g., running Maven builds or Docker builds on a different node).
Let’s take:
•	We have set up a slave node labeled: maven-slave
•	We want Task 2 (Build, Test, Package) to run on the slave
•	Jenkins master handles cloning (lightweight job)

Updated Jenkinsfile with Master-Slave Setup (for Task 2, Step 3)
pipeline {
    agent none  // We’ll define agents per stage
    stages {

        stage('Task 1: Code Checkout (Clone)') {
            agent { label 'master' }  // This runs on the master
            steps {
                git branch: 'main', url: 'https://github.com/akram-md/ABC-Technologies'
            }
        }

        stage('Task 2: Code Compile (Build)') {
            agent { label 'maven-slave' }  // Runs on slave node
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('Task 2: Unit Test') {
            agent { label 'maven-slave' }  // Runs on slave node
            steps {
                sh 'mvn test'
            }
        }

        stage('Task 2: Code Package') {
            agent { label 'maven-slave' }  // Runs on slave node
            steps {
                sh 'mvn package'
            }
        }

    }
}


4.	Docker Containerization on AWS EC2 Instance
(Continuous Deployment with Jenkins and Docker)

Project Tasks (Approach to Solve)

Task 3:  Write a Docket file Create an Image and container on docker host. Integrate docker host with Jenkins. Create CI/CD job on Jenkins to build and deploy on a container  
1.	Enhance the packagejob created in step 1 of task 
2.	2 to create a docker image 2. In the docker image add code to move the war file to tomcat server and build the image

Steps:
Deployment-> Deploy in a server (virtual machine, ec2 instance)

Optional:
Terraform to create an ec2 instance on AWS
Ansible Playbook to deploy the package (war) file on that server

Main.tf  Should be uploaded on Github
sh ‘terraform init’
sh ‘terraform plan’
sh ‘terraform apply –auto-approve’

Ansible Playbook
deploy.yaml  Playbook push it on Github (going to deploy the ear package on the ec2 instance created by using terraform)
Inventory file  
sh ‘ansible-playbook –i inv deploy.yaml’

Pre requisites
•	Need to install docker
•	Need to write a dockerfile
•	Create an account on dockerhub / Should know your dockerhub credentials
•	Store your dockerhub credentials on Jenkins
•	Install docker pipeline plugin
•	Jenkins should have permission to execute docker commands

Install Docker on AWS EC2 Instance
Follow docker Installation Instructions on ubuntu: https://docs.docker.com/engine/install/ubuntu/

1.	Install using the apt repository

sudo apt update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

2.	Install the Docker packages
$sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

3.	Verify that the installation is successful by running the hello-world image
$sudo docker run hello-world

4.	Setting up Dockerhub
-	Create an account on dockerhub / Should know your dockerhub credentials
https://hub.docker.com/repositories/mdakram2989

-	Make sure that Jenkins should have permission to execute docker commands

To resolve permission issue with Jenkins, change the permission of the ownership of /var/run/docker.sock to root permission, see below

5.	Store your dockerhub credentials on Jenkins
Steps:
1.	Go to dashboard of Jenkins: http://3.98.131.118:8080/
2.	Click on Manage Jenkins
3.	Go to Credential
4.	Store scoped to Jenkins  Click on global
5.	Add credentials
6.	Enter the dockerhub user name and password and give the ID to your dockerhub credentials that will be used in the docker push image.

6.	Install docker pipeline plugin
Procedure of building docker image and launching it as a container

Example Procedure:
1.	dockerfile
2.	docker build –t mdakram2989/abc_tech:v1 .  Create the image on my local machine
3.	docker login with
-	user name
-	password
4.	// docker tag abc_tech:v1 mdakram2989/abctech:v1 (do tagging while docker build itself)
5.	docker push mdakram2989/abc_tech:v1
6.	docker run –itd –P mdakram2989/abc_tech:v1

pipeline {
    agent any
    stages {
        stage('Task 1: Code Checkout (Clone)') {
            steps {
                git branch: 'main', url: 'https://github.com/akram-md/ABC-Technologies'
            }
        }
        stage('Task 2: Code Compile (Build)') {
            steps {
                sh 'mvn clean compile'
            }
        }
        stage('Task 2: Unit Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Task 2: Code Package') {
            steps {
                sh 'mvn package'
            }
        }
		stage('Task 3: Build Docker Image') {
		 	steps {
		 		//unstash 'build-artifacts'  // Retrieve the WAR file from stash
				sh 'cp /var/lib/jenkins/workspace/$JOB_NAME/target/ABCtechnologies-1.0.war /var/lib/jenkins/workspace/$JOB_NAME/abc.war'
		 		sh 'docker build -t mdakram2989/abc_tech:$BUILD_NUMBER .'
				//sh 'docker tag abc_tech:$BUILD_NUMBER mdakram2989/abc_tech:$BUILD_NUMBER .'
		 	}
		 }
		 stage('Task 3: Push Docker Image') {
		 	steps {
				withDockerRegistry([ credentialsId: "dockerhub", url: "" ])
				{
		 		sh 'docker push mdakram2989/abc_tech:$BUILD_NUMBER'
				}
		 	}
		 }
		 stage('Task 3: Deploy on a container') {
		 	steps {
		 		sh 'docker run -itd -P mdakram2989/abc_tech:$BUILD_NUMBER'
		 	}
		 }
    }
}


Docker image push to Jenkins and deployed on the dockerhub, see below

See that mdakram2989/abc_tech deployed in the hub.docker.com
https://hub.docker.com/repositories/mdakram2989

Verified the docker image and docker container is created in AWS EC2 instance.

PS: Add 32768 port number to the security group of the AWS EC2 instance to access the apache tomcat server and then access the package abc.war on the tomcat server

5.	Deploy with Kubernetes K8s and Ansible Playbook on AWS EC2 Instance (Orchestrator)

Project Tasks (Approach to Solve)

Task 4: Integrate Docker host with Ansible. Write ansible playbook to create Image and create container. Integrate Ansible with Jenkins. Deploy ansible-playbook. CI/CD job to build code on ansible and deploy it on docker container  
1.	Deploy Artifacts on Kubernetes 
2.	Write pod, service, and deployment manifest file 
3.	Integrate Kubernetes with ansible  
4.	Ansible playbook to create deployment and service

a.	Kubernetes Deployment & Service Files

Set up Kubernetes cluster
-	We can use Minikube for local testing or EKS on AWS
-	Configure kubectl to connect to the cluster

Kubernetes cluster in AWS using EKS (Elastic Kubernetes Service)
Prerequisites:
-	AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli –update

Confirm the installation with the following command.
$aws –version

-	kubectl (Kubernetes CLI): https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

1.	Download the latest release with the command:
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

2.	Validate the binary (optional): Download the kubectl checksum file:
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

3.	Validate the kubectl binary against the checksum file:
echo "$(cat kubectl.sha256)  kubectl" | sha256sum –check

4.	Install kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

5.	Test to ensure the version you installed is up-to-date:
kubectl version --client

-	eksctl (for EKS cluster creation): 
-	https://docs.aws.amazon.com/eks/latest/eksctl/what-is-eksctl.html
-	https://eksctl.io/installation/

eksctl for unix: To download the latest release, run:
# for ARM systems, set ARCH to: `arm64`, `armv6` or `armv7`
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"

# (Optional) Verify checksum
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check

tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz

$sudo install -m 0755 /tmp/eksctl /usr/local/bin && rm /tmp/eksctl

$eksctl version


Step-by-Step: Create EKS Cluster and Deploy App

Step 1: Configure AWS CLI
$aws configure

Enter your:
-	AWS Access Key ID
-	Secret Access Key
-	Region (e.g., ca-central-1)
-	Output format (default: json)

Step 2: Create EKS Cluster Using eksctl
$eksctl create cluster \
--name abc-tech-cluster \
--version 1.28 \
--region ca-central-1 \
--nodegroup-name abc-tech-nodes \
--node-type t3.medium \
--nodes 2 \
--nodes-min 1 \
--nodes-max 3 \
--managed

This will take 10–15 minutes. Once complete, your kubeconfig will be set automatically.

Step 3: Verify Connection to the Cluster
kubectl get nodes

we should see 2 nodes in Ready status

Integrate Kubernetes with Jenkins
Add a stage in your pipeline to: Jenkinsfile
-	Apply the Kubernetes manifests using kubectl
-	Verify deployment status

Create Kubernetes manifests YAML files
Write deployment.yaml: 

abc_tech_deployment.yaml file
apiVersion: apps/v1
kind: Deployment
metadata:
  name: abc-tech
  labels:
    app: abc-tech
spec:
  replicas: 3
  selector:
    matchLabels:
      app: abc-tech
  template:
    metadata:
      labels:
        app: abc-tech
    spec:
      containers:
      - name: abc-tech
        image: mdakram2989/abc_tech:{{ build_number }}
        ports:
        - containerPort: 8080
        imagePullPolicy: Always

Write service.yaml:
apiVersion: v1
kind: Service
metadata:
  name: abc-tech-service
spec:
  type: NodePort 
  selector:
    app: abc-tech
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
      nodePort: 30080

Step 4: Apply the Deployment and Service Files
First, navigate to the directory where the files are located:
cd ~/Desktop/your-yaml-folder

Apply Deployment
kubectl apply -f abc_tech_deployment.yaml

Apply Service
kubectl apply -f abc_tech_service.yaml

Step 5: Check Resources
kubectl get deployments
kubectl get pods
kubectl get svc

If your service.yaml is of type LoadBalancer, you'll get an external IP after a few minutes:
kubectl get svc abc-tech-service

PS: To delete the cluster
eksctl delete cluster --name abc-tech-cluster --region ca-central-1

Deploy to Kubernetes in Jenkins
Image: mdakram2989/abc_tech:3

Jenkinsfile
pipeline {
    agent any
    stages {
        stage('Task 1: Code Checkout (Clone)') {
            steps {
                git branch: 'main', url: 'https://github.com/akram-md/ABC-Technologies'
            }
        }
        stage('Task 2: Code Compile (Build)') {
            steps {
                sh 'mvn clean compile'
            }
        }
        stage('Task 2: Unit Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Task 2: Code Package') {
            steps {
                sh 'mvn package'
            }
        }
		stage('Task 3: Build Docker Image') {
		 	steps {
		 		//unstash 'build-artifacts'  // Retrieve the WAR file from stash
				sh 'cp /var/lib/jenkins/workspace/$JOB_NAME/target/ABCtechnologies-1.0.war /var/lib/jenkins/workspace/$JOB_NAME/abc.war'
		 		sh 'docker build -t mdakram2989/abc_tech:$BUILD_NUMBER .'
				//sh 'docker tag abc_tech:$BUILD_NUMBER mdakram2989/abc_tech:$BUILD_NUMBER .'
		 	}
		 }
		 stage('Task 3: Push Docker Image') {
		 	steps {
				withDockerRegistry([ credentialsId: "dockerhub", url: "" ])
				{
		 		sh 'docker push mdakram2989/abc_tech:$BUILD_NUMBER'
				}
		 	}
		 }
		 stage('Task 3: Deploy on a container') {
		 	steps {
		 		sh 'docker run -itd -P mdakram2989/abc_tech:$BUILD_NUMBER'
		 	}
		 }
		 stage('Task 4: Deploy to kubernetes k8s]') {
		 	steps {
				sh "sed -i 's/abc_tech:latest/abc_tech:$BUILD_NUMBER/g' abc_tech_deployment.yaml"
		 		sh 'kubectl apply -f abc_tech_deployment.yaml'
		 	}
		 }
    }
}


b.	Ansible Playbook to pull Docker image and create container:
Ansible: Install
sudo apt install ansible

Write a playbook to:
•	Pull the Docker image from registry
•	Deploy the container to your target servers
•	playbook name: docker-deploy.yml (Ansible Playbook for EKS + App Deployment)

---
- name: Build and Deploy Docker Container
  hosts: docker_hosts
  become: yes
  vars:
    push_to_registry: true  # Default value
    container_name: "abc_app"
    image_name: "mdakram2989/abc_tech"
    build_number: "{{ lookup('env', 'BUILD_NUMBER') }}"
    app_port: 8080
    host_port: 8080

  tasks:
    - name: Create build directory
      file:
        path: "/tmp/build"
        state: directory
        mode: '0755'

    - name: Copy and rename WAR file
      copy:
        src: "{{ workspace }}/target/ABCtechnologies-1.0.war"
        dest: "/tmp/build/abc_tech.war"
        remote_src: no 

    - name: Copy Dockerfile
      copy:
        src: "{{ workspace }}/Dockerfile"
        dest: "/tmp/build/Dockerfile"
        remote_src: no

    - name: Build Docker image
      community.docker.docker_image:
        name: "{{ image_name }}:{{ build_number }}"
        build:
          path: "/tmp/build"
          dockerfile: "Dockerfile"
        source: build
        force_source: yes

    - name: Clean up build directory
      file:
        path: "/tmp/build"
        state: absent

    - name: Authenticate
      docker_login:
        username: "{{ registry_username }}"
        password: "{{ registry_password }}"
      when: push_to_registry

    - name: Push image
      docker_image:
        name: "{{ image_name }}:{{ build_number }}"
        push: yes
      when: push_to_registry

    - name: Run container
      docker_container:
        name: "{{ container_name }}"
        image: "{{ image_name }}:{{ build_number }}"
        ports:
          - "{{ host_port }}:{{ app_port }}"
        state: started
        restart_policy: unless-stopped

Integrate Ansible with Jenkins 

•	Add a stage in your pipeline to execute the Ansible playbook
•	Configure Ansible in Jenkins or on your Jenkins server (Jenkinsfile for Provisioning EKS & Deploying App)

This Jenkins pipeline will:
•	Create an EKS cluster with eksctl
•	Apply your deployment and service YAMLs

Expects:
•	AWS CLI configured
•	eksctl, kubectl, and Docker installed
•	YAML files stored in the Git repo under /k8s/ folder

Jenkinsfile

pipeline {
    agent any
    stages {
        stage('Task 1: Code Checkout (Clone)') {
            steps {
                git branch: 'main', url: 'https://github.com/akram-md/ABC-Technologies'
            }
        }
        stage('Task 2: Code Compile (Build)') {
            steps {
                sh 'mvn clean compile'
            }
        }
        stage('Task 2: Unit Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Task 2: Code Package') {
            steps {
                sh 'mvn package'
            }
        }
		
		// Task [Task 3 - Build Docker Image + Task 3 - Deploy on a container] has been enhanced in [Task 4  - Ansible Docker Build, Push and Deploy]
		
	//	stage('Task 3: Build Docker Image') {
	//	 	steps {
	//	 		//unstash 'build-artifacts'  // Retrieve the WAR file from stash
	//			sh 'cp /var/lib/jenkins/workspace/$JOB_NAME/target/ABCtechnologies-1.0.war /var/lib/jenkins/workspace/$JOB_NAME/abc.war'
	//	 		sh 'docker build -t mdakram2989/abc_tech:$BUILD_NUMBER .'
	//			//sh 'docker tag abc_tech:$BUILD_NUMBER mdakram2989/abc_tech:$BUILD_NUMBER .'
	//	 	}
	//	 }
	//	 stage('Task 3: Push Docker Image') {
	//	 	steps {
	//			withDockerRegistry([ credentialsId: "dockerhub", url: "" ])
	//			{
	//	 		sh 'docker push mdakram2989/abc_tech:$BUILD_NUMBER'
	//			}
	//	 	}
	//	 }
	//	 stage('Task 3: Deploy on a container') {
	//	 	steps {
	//	 		sh 'docker run -itd -P mdakram2989/abc_tech:$BUILD_NUMBER'
	//	 	}
	//	 }
	//	stage('Task 4: Deploy to kubernetes k8s]') {
	//	 	steps {
	//			sh "sed -i 's/abc_tech:latest/abc_tech:$BUILD_NUMBER/g' abc_tech_deployment.yaml"
	//	 		sh 'kubectl apply -f abc_tech_deployment.yaml'
	//	 	}
	//	 }
		 
		 stage('Task 4 - Ansible Docker Build, Push and Deploy') {
			agent any
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub',
                        usernameVariable: 'REGISTRY_USER',
                        passwordVariable: 'REGISTRY_PASS'
                    )
                ]) {
                    ansiblePlaybook(
                        playbook: "${WORKSPACE}/ansible/docker-deploy.yml",
                        inventory: "${WORKSPACE}/ansible/inventory.ini",
                        extras: """
                            -e 'registry_username=${REGISTRY_USER}'
                            -e 'registry_password=${REGISTRY_PASS}'
                            -e 'workspace=${WORKSPACE}'
                            -e 'build_number=${BUILD_NUMBER}'
                            -e 'push_to_registry=true' 
                            -e 'ansible_python_interpreter=/usr/bin/python3'
                        """.stripIndent(),
                        colorized: true
                    )
                }
            }
        }

		stage('Task 4 - Ansible K8s Deploy') {
			agent any
			steps {
				ansiblePlaybook(
					playbook: "${WORKSPACE}/ansible/k8s-deploy.yml",
					inventory: "${WORKSPACE}/ansible/inventory.ini",
					extras: """
						-e 'workspace=${WORKSPACE}'
						-e 'build_number=${BUILD_NUMBER}'
					"""
				)
			}
		}

   }
}


6.	Continuous Monitoring using Prometheus and Grafana on AWS EC2 Instance
Project Tasks (Approach to Solve)

Task 5: Using Prometheus monitor the resources like CPU utilization: Total Usage, Usage per core, usage breakdown, Memory, Network on the instance by providing the end points in local host. Install node exporter and add URL to target in Prometheus. Using this data login to Grafana and create a dashboard to show the metrics.

Set up monitoring
a.	Install Prometheus on AWS EC2 server
b.	Install Node Exporter on target servers
c.	Configure Prometheus to scrape metrics from Node Exporter
d.	Install Grafana and connect it to Prometheus
e.	Create dashboards in Grafana to monitor:
- CPU usage
- Memory usage
- Network metrics
- Application performance

Download and install Prometheus:
wget https://github.com/prometheus/prometheus/releases/download/v2.47.0/prometheus-2.47.0.linux-amd64.tar.gz
tar -xvf prometheus-2.47.0.linux-amd64.tar.gz
cd prometheus-2.47.0.linux-amd64


Configure Prometheus (prometheus.yml)

global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'node_exporter'
    static_configs:
      - targets: ['localhost:9100']

Start Prometheus:
./prometheus --config.file=prometheus.yml &
Verify: Open http://<EC2-Public-IP>:9090 in your browser. http://3.98.131.118:9090

Setup Node Exporter on host

wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz
tar -xvf node_exporter-1.6.1.linux-amd64.tar.gz
cd node_exporter-1.6.1.linux-amd64

Configure Prometheus to Scrape Node Exporter:
Update prometheus.yml:

global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'node'
    static_configs:
    - targets: ['localhost:9100']

Restart Prometheus:
pkill prometheus
./prometheus --config.file=prometheus.yml &

Install and Configure Grafana
- Add Prometheus as data source.
- Import dashboards for CPU, Memory, Network, etc.

sudo apt-get install -y apt-transport-https
sudo apt-get install -y software-properties-common wget
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt-get update
sudo apt-get install grafana

Start the Grafana
sudo systemctl start grafana-server
sudo systemctl enable grafana-server

Grafana Dashboard:
- Access http://3.98.131.118:3000 (default login: admin/admin)
- Add Prometheus data source (http://3.98.131.118:9090)
- Import dashboard ID 315 for Kubernetes monitoring

Connect Grafana to Prometheus
1. Add Prometheus as a Data Source:
-	In Grafana UI, go to Configuration > Data Sources.
-	Select Prometheus.
-	Set URL:  http://3.98.131.118:9090
-	Click Save & Test.
2. Import a Dashboard:
-	Go to Create > Import.
-	Use Dashboard ID 1860 (Node Exporter Full dashboard).
-	Select Prometheus as the data source.
-	Click Import.

Check Monitoring:
- Prometheus: http://3.98.131.118:9090
- Grafana: http://3.98.131.118:3000

Verification: Verify Metrics in Grafana
- Check Application:
kubectl get services
- Access the external IP for abc-tech
See dashboards for:
-	CPU Usage (total, per core, breakdown)
-	Memory Utilization
-	Network I/O
-	Disk Usage
