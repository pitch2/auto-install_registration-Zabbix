import subprocess, sys, csv
from zabbix_api import ZabbixAPI
from datetime import datetime

#establish connection with Zabbix server 
zabbix_url = 'http://<IPSERVER>/zabbix/api_jsonrpc.php' # Your server and /api_jsonrpc.php
zabbix_user = '<USER>'  # Your user
zabbix_password = '<PWD>'  # password of user
#connect
zapi = ZabbixAPI(server=zabbix_url)
zapi.login(zabbix_user, zabbix_password)

#Function using API for add host
def send_API(host_name, host_ip, group_id, nom_DNS):
    try:
        host = zapi.host.create({
            'host': host_name,
            'interfaces': [{
                'type': 1,  # Type d'interface (1 = agent Zabbix)
                'main': 1,  # Interface principale
                'useip': 1,  # Utiliser le DNS (0 = utiliser DNS, 1 = utiliser IP)
                'ip': host_ip,  # Adresse IP de l'hôte
                'dns': nom_DNS,  # Nom DNS de l'hôte
                'port': '<PORT>',  # Port par défaut pour l'agent Zabbix
                }],
            'groups': [{'groupid': group_id}],
            'templates': [{'templateid': template_id}],
        })
        print(f"Hôte créé avec succès: {host}")
    except Exception as e:
        print(f"Erreur lors de la création de l'hôte: {e}")



# Read the docs for to find your ID
group_id = '<GROUPID>'  # ID host group
template_id = '<TEMPLATEID>'  # ID of template 

with open(r'liste.csv', newline='') as csv_file:
    reader = csv.reader(csv_file, delimiter=';')
    rows = list(reader)

    for i in range(len(rows[0])):
        host = rows[0][i].split(",")
        
        # Check if the split resulted in at least 2 elements
        if len(host) >= 2:
            name = host[0]
            ip = host[1]
            print(name, ip)
            
        send_API(name ,ip, group_id, name)
        print("OK",name, ip)
