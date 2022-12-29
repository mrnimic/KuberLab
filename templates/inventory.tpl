[masters]
masternode ansible_host=%{ for ip in master ~}
${ip}
%{ endfor ~}
