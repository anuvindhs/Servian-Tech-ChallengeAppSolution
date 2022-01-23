# Servian Tech App Challenge 
----


## Technology Choices

#### App details
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white) ![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black) ![Go](https://img.shields.io/badge/go-%2300ADD8.svg?style=for-the-badge&logo=go&logoColor=white) ![Postgres](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white) ![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white) ![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)

#### Infrastructure
 - Amazon Elastic Container Service (ECS)
 - Amazon Elastic Load Balancing (ALB)
 - Amazon Relational Database Service (RDS)
 - Amazon Certificate Manager (ACM)
 - Amazon Route 53
 - Amazon Simple Storage Service (S3)
 - AWS Identity and Access Management (IAM)
 - Amazon Security Groups
#### CI/CD
 - Github for code
 - Code pipeline - Automate release
 - Codebuild - build container image 
 - ECR - Container Repository
#### IAC
- AWS CLI
#### Before Depolyment
Code Repo
-  ` git clone https://github.com/servian/TechChallengeApp.git `


Make changes to docker file
- ``RUN echo "./TechChallengeApp updatedb; ./TechChallengeApp serve" > trigger.sh
EXPOSE 8080 
ENTRYPOINT [ "/bin/sh", "trigger.sh"] ``

update DB config
-  update conf.toml

----
## Architecture
![](./assets/arch.png)

----


## IAC Deployment
<pre><code>

 wget https://raw.githubusercontent.com/anuvindhs/Servian-Tech-ChallengeAppSolution/main/assets/install.sh -q -O -| bash 
 </code></pre>


 <pre><code>

chmod u+x install.sh 
 </code></pre>

<pre><code>
./install.sh
 </code></pre>
 
-----------