function Set-KeystoreDefaultStore {
	#.ExternalHelp Keystore.psm1-Help.xml
	[CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'ByName')]
	param (
		[Parameter(Mandatory, ParameterSetName = 'ByName')]
		[ValidateNotNullOrEmpty()]
		[string]$Name,

		[Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'ByObject')]
		[KeystoreStore]$Store
	)

	begin {
		Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
		$ErrorActionPreference = 'Stop'
	}

	process {
		try {
			if ($PSCmdlet.ParameterSetName -eq 'ByObject') {
				$Name = $Store.Name
			} else {
				if ($null -eq ($Store = Get-KeystoreStore -Name $Name)) {
					throw "The store '$Name' does not exist."
				}
			}

			if ($Script:Settings.DefaultStore -eq $Store.Name) {
				Write-Verbose "The store '$Name' is already set as the default."
			} else {
				$target = "Keystore store '$($Store.Name)' ($($Store.Path))"
				if ($PSCmdlet.ShouldProcess($target, 'Set as default')) {
					$Script:Settings = Import-Configuration
					$Script:Settings.DefaultStore = $Store.Name
					$Script:Settings | Export-Configuration
				}
			}
		} catch {
			$PSCmdlet.ThrowTerminatingError($_)
		}
	}

	end {
		$ErrorActionPreference = 'Continue'
	}
}