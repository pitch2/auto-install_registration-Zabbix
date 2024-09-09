$PClisting = [System.Collections.ArrayList]@('')
$cible_txt = Get-Content xxx\cible.txt
$PClisting.Add($cible_txt)

if ($PClisting -ne $null)
{
    foreach ($item in $PClisting)
    {
        try
        {
        # Create new remote PS session object
        $s= New-PSSession -ComputerName $item 
        $packageName="zabbix-agent2"

        Invoke-Command -Session $s -ScriptBlock { 
       
    
        function SetParamsMSI_AgentZabbix2 {
	        param(
		        [Parameter(Mandatory=$true, Position=0)][string] $installFolder,
		        [Parameter(Mandatory=$true, Position=1)][string] $hostname
	        )
           
                $a="/LOGTYPE:file /LOGFILE:"+ "'" + $installFolder + "\zabbix_agentd.log" + "'" + " /SERVER:xxxx /LISTENPORT:xxxx /SERVERACTIVE:xxxx /INSTALLFOLDER:"+ "'" + $installFolder + "'" +" /HOSTNAME:"+ "'" + $hostname + "'" + " /TLSCONNECT:psk /TLSACCEPT:psk /TLSPSKIDENTITY:xxxxx /TLSPSKVALUE:xxxxx /ALLOWDENYKEY:AllowKey=system.run[*] /SKIP:fw" #change the XXXX
                $ParamsList='--package-parameters='+$a
                
                $o=$ParamsList 
            return $o
        }
            
        if (-not (Test-Path -LiteralPath “C:\Program Files\Zabbix Agent")) 
        {
            choco feature enable -n=allowGlobalConfirmation
            
            $packageArgs=SetParamsMSI_AgentZabbix2 “C:\Program Files\Zabbix Agent" $using:item 

            choco install $using:packageName $packageArgs
    
            $exitCode = $LASTEXITCODE
            choco feature disable -n=allowGlobalConfirmation    
        }
        }    
        
        # Clean session disconnection
        Disconnect-PSSession -Session $s 

        Write-Host "Successfully deployed package: " $packageName + " on: " $item  -ForegroundColor Cyan
        }
        catch{
            $Error[0].Exception.Message
            Write-Host "Something was getting wrong with: " $exitCode + " on: " $item  -ForegroundColor Red
        } 
    }
}