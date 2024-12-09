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
                    choco install smartmontools
                    #choco install zabbix-agent2 --package-parameters "/LOGTYPE:file /LOGFILE: C:\Program Files\Zabbix Agent  \zabbix_agentd.log /SERVER:<IPSERVER> /LISTENPORT:<PORT> /SERVERACTIVE:<IPSERVERORPROXY> /INSTALLFOLDER: C:\Program Files\Zabbix Agent /HOSTAME: $RemoteComputer /TLSCONNECT:psk /TLSACCEPT:psk /TLSPSKIDENTITY:<PSKNAME> /TLSPSKVALUE:<PSKKEY> /ALLOWDENYKEY:AllowKey=system.run[*]"
                    choco install zabbix-agent2 --package-parameters "/LOGTYPE:file /LOGFILE: C:\Program Files\Zabbix Agent  \zabbix_agentd.log /SERVER:<IPSERVER> /LISTENPORT:<PORT> /SERVERACTIVE:<IPSERVERORPROXY> /INSTALLFOLDER: C:\Program Files\Zabbix Agent /HOSTAME: $RemoteComputer"
                    Set-Content -Path 'C:\Program Files\Zabbix Agent\zabbix_agent2.d\plugins.d\smart.conf' -Value ((Get-Content -Path 'C:\Program Files\Zabbix Agent\zabbix_agent2.d\plugins.d\smart.conf') -replace '# Plugins.Smart.Path=','Plugins.Smart.Path=C:\Program Files\smartmontools\bin\smartctl.exe')
                }
            }
            catch
            {
                Write-Host "Something was getting wrong: " $RemoteComputer-ForegroundColor Red
            }
            Write-Host "Task successfully completed on: " $RemoteComputer -ForegroundColor Green
        }
        else
        {
        Write-Host "Can't connect to PC: " $RemoteComputer -ForegroundColor Red
        }        
    }
}
