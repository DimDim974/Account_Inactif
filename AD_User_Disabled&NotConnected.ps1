import-module ActiveDirectory
$DateToday = Get-Date -Format dd-MM-yyyy
$nb_mois = 6
$date_du_jour =  Get-Date 
$date_diff =$date_du_jour.addmonths(0-$nb_mois)

# $ADUserDisabled = Get-ADUser -Filter {Enabled -eq "false"} -Properties *
$Domain = read-host "Enter the domain, for exemple : DC=France,DC=local, please"

$ADUserDisabled = Search-ADaccount -UsersOnly -AccountInactive -searchbase $Domain 

$Info=@()

foreach($ADUser_D in $ADUserDisabled)
{
    $Object = New-Object PSObject
	$Object | add-member NoteProperty "Nom Complet" ($ADUser_D.DisplayName)
    $Object | add-member NoteProperty "NameUser" ($ADUser_D.Name)
    $Object | add-member NoteProperty "Login" ($ADUser_D.SamAccountName)
    $Object | add-member NoteProperty "DistinguishedName" ($ADUser_D.DistinguishedName)
    $Object | add-member NoteProperty "Enabled" ($ADUser_D.Enabled)
    $Object | add-member NoteProperty "Connection" ($ADUser_D.LastLogonDate)
    $Object | add-member NoteProperty "ID" ($ADUser_D.SID)
    if ($ADUser_D.LastLogonDate -le $date_diff)
    {
        $Object | add-member NoteProperty "Status" "Oui"
    }
    else
    {
        $Object | add-member NoteProperty "Status" "Non"
    }
}
$Info += $Object
$Info | Export-Excel C:\Tools\AD_Users_Inactif_$DateToday.xlsx -WorksheetName 'Utilisateur'

#Get-ADUser -Filter {Enabled -eq "true"} -Properties *