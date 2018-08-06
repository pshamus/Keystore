function Remove-KeystoreAccessGroup {
	#.ExternalHelp Keystore.psm1-Help.xml
	[CmdletBinding(SupportsShouldProcess)]
	param (
		[Parameter(Mandatory, ValueFromPipeline)]
		[KeystoreAccessGroup]$InputObject
	)

	process {
		try {
			$ErrorActionPreference = 'Stop'

			$accessGroupName = $InputObject.Name
			if ($accessGroupName -eq 'Self') {
				throw "The access group 'Self' is built-in and cannot be altered."
			}

			$target = "Keystore access group '$accessGroupName'"
			if ($PSCmdlet.ShouldProcess($target, 'Remove')) {
				$Settings = Get-KeystoreConfiguration
				$Settings.AccessGroups.Remove($accessGroupName)
				if ($InputObject.IsDefault) {
					Write-Verbose "Resetting default access group to 'Self'"
					$Settings.DefaultAccessGroup = 'Self'
				}
				$Settings | Export-Configuration
			}
		}
		catch {
			$PSCmdlet.ThrowTerminatingError($_)
		}
		finally {
			$ErrorActionPreference = 'Continue'
		}
	}
}