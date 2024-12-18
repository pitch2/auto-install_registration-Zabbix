$PClisting = [System.Collections.ArrayList]@()


if ($PClisting -ne $null)
{
    foreach ($RemoteComputer in $PClisting)
    {
        If (Test-Connection -ComputerName $RemoteComputer -Quiet)
        {
            try
            {
                Invoke-Command -ComputerName $RemoteComputer -ScriptBlock {

                    Set-ExecutionPolicy Unrestricted
                    choco feature enable -n=allowGlobalConfirmation

                    choco install smartmontools #Installation smartmontools
                    Write-Host "Smart is install on" $RemoteComputer-ForegroundColor Yellow

                    choco install zabbix-agent2 --no-progress --package-parameters "/LOGTYPE:file /LOGFILE: C:\Program Files\Zabbix Agent  \zabbix_agentd.log /SERVER:<IPSERVER> /LISTENPORT:<PORT> /SERVERACTIVE:<IPSERVER> /INSTALLFOLDER: C:\Program Files\Zabbix Agent /HOSTAME: $RemoteComputer /TLSCONNECT:psk /TLSACCEPT:psk /TLSPSKIDENTITY:<PSK_ID> /TLSPSKVALUE:<PSK_KEY> /ALLOWDENYKEY:AllowKey=system.run[*]"
                    Write-Host "Zabbix is install on" $RemoteComputer-ForegroundColor Yellow

                    #FOR NO PSK : choco install zabbix-agent2 --no-progress --package-parameters "/LOGTYPE:file /LOGFILE: C:\Program Files\Zabbix Agent  \zabbix_agentd.log /SERVER:<IPSERVER> /LISTENPORT:<PORT> /SERVERACTIVE:<IPSERVER> /INSTALLFOLDER: C:\Program Files\Zabbix Agent /HOSTAME: $RemoteComputer
                    Set-Content -Path 'C:\Program Files\Zabbix Agent\zabbix_agent2.d\plugins.d\smart.conf' -Value ((Get-Content -Path 'C:\Program Files\Zabbix Agent\zabbix_agent2.d\plugins.d\smart.conf') -replace '# Plugins.Smart.Path=','Plugins.Smart.Path=C:\Program Files\smartmontools\bin\smartctl.exe') #changement de conf du fichier zabbix -> smart

                    Write-Host "Task successfully completed on: " $RemoteComputer -ForegroundColor Green
                }
            }
            catch
            {
                Write-Host "Something was getting wrong: " $RemoteComputer-ForegroundColor Red
            }
        }
        else
        {
        Write-Host "Can't connect to PC: " $RemoteComputer -ForegroundColor Red
        }        
    }
}
