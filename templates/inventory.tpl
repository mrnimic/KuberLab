[masters]
masternode ansible_host=%{ for ip in master ~}
${ip}
%{ endfor ~}

[masters:vars]
cluster_name=${cluster_name}
backend_ecr_url=${backend_ecr}
frontend_ecr_url=${frontend_ecr}

