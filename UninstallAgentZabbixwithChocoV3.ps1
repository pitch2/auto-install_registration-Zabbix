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
                    #installation de choco
                    $choco_install_ON = Test-Path "C:\ProgramData\chocolatey"
                    $zabbix_install_ON =  Test-Path "C:\Program Files\Zabbix Agent"
                    $smartmontools_install_ON = Test-Path "C:\Program Files\smartmontools"
                    if ($choco_install_ON -eq 'False') 
                        {
                            #installation choco
                            Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
                        }
                    else
                        {
                            #maj choco
                            choco upgrade chocolatey
                        }

                    if ($smartmontools_install_ON -eq 'True')
                    # desinstallation choco
                        {
                            choco uninstall smartmontools -y --removedependencies
                        }

                    if ($zabbix_install_ON -eq 'True')
                    # desinstallation choco
                        {
                            choco uninstall zabbix-agent2 -y --removedependencies 
                        }   
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
