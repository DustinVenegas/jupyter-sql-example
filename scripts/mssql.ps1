#require 
<#
.SYNOPSIS
Manage LocalDB for Microsoft SQL Server.
.DESCRIPTION
Helper functions for Microsoft SQL Server LocalDB.
.EXAMPLE
.\scripts\mssql.ps1 | Format-Table -AutoSize -Wrap
#>
param(
	[string]$instance = 'MSSQLLocalDB',
	[string]$odbcName = 'MSSQLLocalDBODBC'
)
begin {
	function Get-LatestODBCDriver {
		<#
		.SYNOPSIS
		Get the driver string for the most recent 'ODBC Driver for SQL Server' installed.
		#>
		param()
		# latest driver or error
		Get-OdbcDriver -Name 'ODBC Driver * for SQL Server' -Platform '64-bit' | Select-Object -ExpandProperty Name | Sort-Object -Descending | Select-Object -First 1
	}

	function New-MSSQLInstance {
		<#
		.SYNOPSIS
		Create a new MSSQL instance.
		#>
		[CmdletBinding()]
		param (
			# Name of the MSSQL instance.
			[Parameter(Mandatory)]
			[string]$instance
		)
		# create an instance
		SqlLocalDB.exe create $instance
	}

	function Test-MSSQLInstance {
		<#
		.SYNOPSIS
		Test for a specific MSSQL instance.
		#>
		[CmdletBinding()]
		param (
			# Name of the MSSQL instance.
			[Parameter(Mandatory)]
			[string]$instance
		)
		# search LocalDB instance names for an instance
		@(SqlLocalDB.exe info) -contains $instance
	}

	function Get-MSSQLConnStr {
		<#
		.SYNOPSIS
		Emits a sqlalchemy connection string for a MSSQL LocalDB instance.
		#>
		[CmdletBinding()]
		param(
			# Name of the MSSQL instance.
			[Parameter(Mandatory)]
			[String]$instance
		)

		$driver = Get-LatestODBCDriver
		if (-Not ($driver)) {
			throw 'Could not locate an ODBC Driver for SQL Server.'
		}

		# emit connection string
		$db = 'master'
		$encDriver = [System.Web.HTTPUtility]::UrlEncode($driver)

		Write-Output "mssql+pyodbc://@(localdb)\$instance/$db`?driver=$encDriver&trusted_connection=yes"
	}

	function New-ODBCDSN {
		<#
		.SYNOPSIS
		Creates an ODBC DSN for a MSSQL instance.
		#>
		[CmdletBinding()]
		param(
			# Name of the MSSQL instance.
			[Parameter(Mandatory)]
			[string]
			$instance,
			# Name of the ODBC DSN.
			[Parameter(Mandatory)]
			[string]
			$odbcName,
			[Parameter(Mandatory)]
			[string]
			$driver
		)

		$properties = @(
			'Trusted_Connection=yes',
			"Server=(localdb)\$instance")
		Add-OdbcDsn -Name $odbcName -DsnType User -Platform '64-bit' -DriverName $driver -SetPropertyValue $properties

		Write-Information "Created a new ODBC DSN with ODBC name: $odbcName, driver $driver"
		Write-Output "$odbcName"
	}

	$output = @{}
}
process {
	if (-not (Get-Command SqlLocalDB.exe)) {
		throw 'Expected LocalDB tool in PATH: SqlLocalDB.exe'
	}

	if (-not (Test-MSSQLInstance -instance $instance)) {
		New-MSSQLInstance -instance $instance
	}

	$driver = Get-LatestODBCDriver
	if (-not (Get-OdbcDsn -Name $odbcName)) {
		New-ODBCDSN -instance $instance -odbcName $odbcName -driver $driver
		$output['odbc-dsn-created'] = $true
	}

	$output['odbc-dsn-name'] = Get-OdbcDsn -Name $odbcName
	$output['odbc-driver'] = $driver
	$output['connstr'] = Get-MSSQLConnStr -instance $instance
}
end {
	Write-Output $output
}