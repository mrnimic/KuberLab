[masters]
masternode ansible_host=%{ for ip in master ~}
${ip}
%{ endfor ~}

[masters:vars]
cluster_name=${cluster_name}
vote_ecr_url=${vote_ecr}
result_ecr_url=${result_ecr}
worker_ecr_url=${worker_ecr}
seed_ecr_url=${seed_ecr}
