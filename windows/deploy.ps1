
$deploy_repository=$args[0]
$resolve_repository=$args[1]

if (  ($deploy_repository -eq $null) -or ($deploy_repository -eq '') ) {
	Write-Host -ForegroundColor Red "A url of destination repository should be specified."
	exit 1
}

if ( ($resolve_repository -eq $null) -or ($resolve_repository -eq '') ) {
	$resolve_repository = $deploy_repository
}

function try_resolve($repo, $g, $a, $v){
	$g = $g.Replace(".", "/")
	$repo = $repo.TrimEnd("/");
	try {
		Invoke-WebRequest -UseBasicParsing -Uri "$repo/$g/$a/$v/$a-$v.pom" -TimeoutSec 30 -ErrorAction:Stop | Out-Null
		return 0
	}
	catch {
		return 1
	}
}

$dir = Split-Path $MyInvocation.MyCommand.Path
$deploy_settings = ''
if ( Test-Path "$dir\deploy-settings.xml" ) {
	$deploy_settings = '-s deploy-settings.xml '
}


Get-ChildItem -R ./.deps-proj/target/dependency/*.pom | % {
	$pom = $_.FullName  
	Write-Host "Analyzing $pom"

	[xml]$pomXml = Get-Content $pom

	$g = $pomXml.project.groupId
	$a = $pomXml.project.artifactId
	$v = $pomXml.project.version
	$pkg = $pomXml.project.packaging
	if( ($pkg -eq $null) -or ($pkg -eq '')){
		$pkg = 'jar'
	}

	$exists = (try_resolve $resolve_repository $g $a $v)
	if ($exists -eq 0){
		Write-Host "Skipping $g`:$a`:$v`: it is found in $resolve_repository"
	}
	else{
		Write-Host "Deploying $g`:$a`:$v to $deploy_repository"
		$file = [System.IO.Path]::Combine([System.IO.Path]::GetDirectoryName( $pom ),	[System.IO.Path]::GetFileNameWithoutExtension( $pom ) + ".$pkg")

		$deployCmd = "mvn deploy:deploy-file $deploy_settings'-Durl=$deploy_repository' '-Dfile=`"$file`"' '-DpomFile=`"$pom`"' '-DgeneratePom=false' '-DrepositoryId=deploy'"
		Invoke-Expression $deployCmd
		# Todo: What if only pom is available
	}

	Write-Host ''
}




