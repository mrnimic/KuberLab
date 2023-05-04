[masters]
masternode ansible_host=%{ for ip in master ~}
${ip}
%{ endfor ~}

[masters:vars]
cluster_name=${cluster_name}

