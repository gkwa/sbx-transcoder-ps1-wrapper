$ErrorActionPreference = 'stop'
$WarningPreference = 'stop'
# $PSVersionTable

$cwd = (Get-Location).Path

$flist = @(Get-ChildItem -Path . -include *.actl3 -recurse)
foreach($actl3 in $flist)
{
    $basename = [io.Path]::GetFileNameWithoutExtension($actl3.fullname)
    $outpath = "{1}.mov" -f $actl3.DirectoryName, $basename
    $actl3_filename = [io.Path]::GetFileName($actl3.fullname)
    $mov = "${basename}.mov"
    $log = "${basename}.log"

    if(!(test-path "$outpath"))
    {
	for ($i=1; $i -le 4; $i++)
	{
	    if(test-path "$mov")
	    {
		$mlen = (Get-item $mov).length;
		if(1000 -gt $mlen/1kb){
		    "{0:N2}" -f ($mlen/1kb) + " KB" | Out-String
		}elseif(1000 -gt ($mlen/1mb)){
		    "{0:N2}" -f ($mlen/1mb) + " MB" | Out-String
		}else{
		    "{0:N2}" -f ($mlen/1gb) + " GB" | Out-String
		}
		if($mlen -lt 1kb)
		{
		    # if mov file is greater than 1kb then the transcode
		    # completed successfully and dont transcode again
		    break #breaks for loop
		}
	    }

	    & .\Transcoder.exe /file $actl3_filename /qt $mov >$log
	    ".\Transcoder.exe /file $actl3_filename /qt $mov /mf 1000 >$log" # show what its doing
	}
    }
}
