<# Powershell for Rename Project
	
	This Script is used to rename machines, along with their autologin name and Its password
	This document was created on 6/18/2019
	
	#>
	
# Get Domain Credentials

$DomainCredential = Get-Credential

# Fetching CSV File for Rename Data

$computers = import-csv -Path "\\vappsserver\Appsserver\Jordan\ScriptCSV\Computers.CSV"

#Set Variables

Foreach ($computer in $computers){
$newname = $($computer.newname)
$oldname = $($computer.oldname)
Write-Host $newname $oldname

#Registry Change for auto Login Machines

	If (test-connection -ComputerName $Computers.oldname  -Count 1 -Quiet)
	{
  	Try { 
		 			$reg = Invoke-Command -ComputerName $Computers.oldname -ScriptBlock {
		 			Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultUserName" -Value $using:newname -Force
				    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultPassword" -Value Image1000 -Force
		  	  }
  		 } Catch{$_.Exception}
	}


# Rename Process

  foreach ($oldname in $computers){
  Rename-Computer -ComputerName $Computers.oldname -NewName $computers.newname -DomainCredential $DomainCredential -force -restart
  }
}
