[masters]
masternode ansible_host=%{ for ip in master ~}
${ip}
%{ endfor ~}

[workers]
worker1 ansible_host=%{ for ip in worker1 ~}
${ip}
%{ endfor ~}
worker2 ansible_host=%{ for ip in worker2 ~}
${ip}
%{ endfor ~}