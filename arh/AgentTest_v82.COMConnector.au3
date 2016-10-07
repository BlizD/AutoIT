$oShell = ObjCreate("v82.COMConnector")
$Agent=$oShell.ConnectAgent("oai-03");
$Klasters=$Agent.GetClusters();
$BaseName="PlanB"
;~ $Agent.Authenticate($Klasters[0],"DumpIB", "dumpday")
;~ Exit

For $Klaster In $Klasters
	$Name="DumpIB"
	$PSD="dumpday"
	$Agent.Authenticate($Klaster,"", "")
	$Proceses=$Agent.GetWorkingProcesses($Klaster)
	For $Process In $Proceses
		$Port=$Process.MainPort
        $WorkingProcess= $oShell.ConnectWorkingProcess("oai-03:" & $Port)
        $WorkingProcess.AddAuthentication($Name,$PSD)
		$InfoBase=""
		$Bases=$Agent.GetInfoBases($Klaster)
		For $Base in $Bases
			if $Base.Name=$BaseName Then
				$InfoBase=$Base
				ExitLoop
			EndIf
		Next
		if $InfoBase="" Then
			MsgBox(0, "Error", "База не обнаружена")
		EndIf
;~ 		MsgBox(0, "Error", $InfoBase)
		$Sessions=$Agent.GetInfoBaseSessions($Klaster, $InfoBase)
		For $Session in $Sessions 
			$Agent.TerminateSession($Klaster, $Session)
		Next
;~ 		$Connections=$Agent.GetInfoBaseConnections($Klaster, $InfoBase)
;~ 		For $Connection in $Connections 
;~ 			$WorkingProcess.Disconnect($Connection)
;~ 		Next		
	Next	
Next