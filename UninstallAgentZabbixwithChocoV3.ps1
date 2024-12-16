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

                # Check if choco is installed
                $choco_install_ON = Test-Path "C:\ProgramData\chocolatey" #Verification d'installation de choco
                $zabbix_install_ON = Test-Path "C:\Program Files\Zabbix Agent" #Verification d'installation de Zabbix
                $smartmontools_install_ON = Test-Path "C:\Program Files\smartmontools" #Verification d'installation de smartmontools

                if (-not $choco_install_ON) { #si choco n'est installé -> installation
                    Write-Host "Installing choco on $RemoteComputer" -ForegroundColor Yellow
                    Set-ExecutionPolicy Bypass -Scope Process -Force
                    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
                } else { #si choco est installé -> upgrade
                    Write-Host "Upgrading choco on $RemoteComputer" -ForegroundColor Yellow
                    choco upgrade chocolatey
                }
                if ($smartmontools_install_ON) { #si smart est installé -> désinstallation
                    Write-Host "Uninstalling smartmontools on $RemoteComputer" -ForegroundColor Yellow
                    choco uninstall smartmontools -y --removedependencies
                } else {
                    Write-Host "No smartmontools in $RemoteComputer" -ForegroundColor Cyan
                }
                if ($zabbix_install_ON) { #si zabbix est installé -> désinstallation
                    Write-Host "Uninstalling Zabbix Agent on $RemoteComputer" -ForegroundColor Yellow
                    choco uninstall zabbix-agent2 -y --removedependencies
                } else {
                    Write-Host "No zabbix agent on $RemoteComputer" -ForegroundColor Cyan
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
