param (
    [Parameter(Mandatory=$true)]
    [string]$AssemblyFilter
)

try {
    # Get the path to the ngen executable dynamically
    $ngenPath = [System.IO.Path]::Combine([Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory(), "ngen.exe")

    # Check if ngen.exe exists
    if (-Not (Test-Path $ngenPath)) {
        Write-Host "Ngen.exe not found at $ngenPath. Make sure .NET Framework is installed."
        return
    }

    # Get a list of loaded assemblies
    $assemblies = [AppDomain]::CurrentDomain.GetAssemblies()

    # Filter assemblies based on the provided filter
    $filteredAssemblies = $assemblies | Where-Object { $_.FullName -ilike "$AssemblyFilter" }

    if ($filteredAssemblies.Count -eq 0) {
        Write-Host "No matching assemblies found for optimization."
        return
    }

    foreach ($assembly in $filteredAssemblies) {
        # Get the name of the assembly
        $name = [System.IO.Path]::GetFileName($assembly.Location)

        # Use Ngen to install the assembly
        Start-Process -FilePath $ngenPath -ArgumentList "install `"$($assembly.Location)`"" -Wait -WindowStyle Hidden
    }

    Write-Host "Assembly optimization for $AssemblyFilter complete."
} catch {
    Write-Host "An error occurred: $_"
}
