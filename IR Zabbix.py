import subprocess, sys, csv
from zabbix_api import ZabbixAPI

#establish connection with Zabbix server 
zabbix_url = 'http://xxxx/zabbix/api_jsonrpc.php' # Your server and /api_jsonrpc.php
zabbix_user = 'xxxx'  # Your user
zabbix_password = 'xxxx'  # password of user
#connect
zapi = ZabbixAPI(server=zabbix_url)
zapi.login(zabbix_user, zabbix_password)

#Function using API for add host
def send_API(host_name, host_ip, group_id, template_id, n_DNS):
    try:
        host = zapi.host.create({
            'host': host_name,
            'interfaces': [{
                'type': 1,  # Type d'interface (1 = agent Zabbix)
                'main': 1,  # Interface principale
                'useip': 0,  # Utiliser le DNS (0 = utiliser DNS, 1 = utiliser IP)
                'ip': host_ip,  # Adresse IP de l'hôte
                'dns': n_DNS,  # Nom DNS de l'hôte
                'port': 'xxxx',  # Port par défaut pour l'agent Zabbix
                }],
            'groups': [{'groupid': group_id}],
            'templates': [{'templateid': template_id}],
        })
        print(f"Hôte créé avec succès: {host}")
    except Exception as e:
        print(f"Erreur lors de la création de l'hôte: {e}")




# Read the docs for to find your ID
group_id = '23'  # ID host group
template_id = '10637'  # ID of template 



with open(r'xxxx\liste.csv', newline='') as csv_file:
    reader = csv.reader(csv_file, delimiter=',')
    rows = list(reader)

    for i in range(len(rows)):

        name = rows[i][0].split(";")[1].split(".")[0]
        ip = rows[i][0].split(";")[0]
        n_i = rows[i][0].split(";")[1].split(".")[0], rows[i][0].split(";")[0]

        f = open("cible.txt", "w")
        f.write(name)
        f.close

        f = open("logs.txt", "a")
        f.write(f"Start install of {n_i}\n")
        f.close

        #install Zabbix agent with powershell script
        p = subprocess.Popen(["powershell.exe", r"xxxx\InstallAgentZabbix2WithChocoV3.ps1"], stdout=sys.stdout) #location of PS1 script
        p.wait()

        f = open("logs.txt", "a")
        f.write("   Install is good\n")
        f.close

        send_API(rows[i][0].split(";")[1].split(".")[0], rows[i][0].split(";")[0], group_id, template_id, rows[i][0].split(";"))

        f = open("logs.txt", "a")
        f.write("   Registre in Zabbix\n")
        f.close

        f = open("logs.txt", "a")
        f.write(f"{n_i} is finish\n")
        f.write("\n\n\n")
        f.close

        print(f"{n_i} ,is finish")
    
    f = open("logs.txt", "a")
    f.write(f"----------------------------------FINISH SESSION------------------------------------\n\n\n\n")
    f.close










        

