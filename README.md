## Auto-install and registration in Zabbix

## Lire les id de templates et  de groups en python

**Pour groups**
```python
host_groups = zapi.group.get({
    "output": "extend"
})

# Ensure the response is a list
if isinstance(host_groups, list):
    for group in host_groups:
        print(f"Group ID: {group['groupid']}, Name: {group['name']}")
else:
    print("Unexpected response format:", host_groups)
```

**Pour templates**
```python
templates = zapi.template.get({
    "output": "extend"
})

# Verify if the response is a list and iterate through it
if isinstance(templates, list):
    for template in templates:
        print(f"Template ID: {template['templateid']}, Name: {template['name']}")
else:
    print("Unexpected response format:", template)

```

### Pour le python
Nous prenons en entrer un CSV

> NOM_DNS,IP;NOM_DNS,IP...

En python nous créons une liste avec le CSV (le script est fais pour les CSV en ligne unique).


Cette version est donc plus légère, elle permet de produire moins de bug et de simplifier la chose au final.
Même si nous devons le faire en plusieurs étapes. La chose est plus ergonomique et rapide.

Voici les étapes qu'il faut suivre : 
1. <span style="background:#b1ffff">Désinstallation des agents possiblement présent avec `choco uninstall zabbix-agent2 -y --removedependencies` avec choco</span>
2. <span style="background:#b1ffff">Installation de Zabbix + smart (+ changement de fichier de conf) avec choco </span>
3. <span style="background:#9254de">Ajout des postes sur Zabbix (en ajoutant la clé PSK en sélection collective)</span>
4. <span style="background:#d4b106">Vérification après 20 min des bonnes remonté.</span>

<span style="background:#b1ffff">Les deux premières étapes</span> sont sur votre post qui contrôle choco (à définir par GPO)
<span style="background:#9254de">Ensuite le script python</span> qui envoie par API vers le Zabbix les nouveaux hosts
<span style="background:#d4b106">Et enfin une vérification</span> (agent en vert, informations cohérentes...)

---

