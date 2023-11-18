[masters]
masternode ansible_host=%{ for ip in master ~}
${ip}
%{ endfor ~}

[masters:vars]
cluster_name=${cluster_name}
backend_ecr_url=${backend_ecr}
hr_ecr_url=${hr_ecr}
questionnaire_ecr_url=${questionnaire_ecr}
triage_ecr_url=${triage_ecr}
unifier_ecr_url=${unifier_ecr}
webapp_ecr_url=${webapp_ecr}
enterprise_ecr_url=${enterprise_ecr}

