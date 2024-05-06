# Obtain the csv file
$file = Read-Host "Enter CSV path"

$file = Import-Csv $file | Sort-Object -Property * -Unique

#obtain values from file
foreach ($User in $file)
{
    $fname = $User.Firstname
    $lname = $User.Lastname
    $dept = $User.Department
    $role = $User.Role
    $username = ($fname + $lname).ToLower()
    $email = $username + '@' + 'org.net'
    $temppass = (convertto-securestring ("Pa$$w0rd!") -AsPlainText -Force) 

    #check if user exists
    if (Get-ADUser -F {name -eq $username})
    {
        Write-Warning "user $fname $lname exists"
    }

    #create the user
    else
    {
    	#create user
	    New-ADUser -Name $username -AccountPassword $temppass -ChangePasswordAtLogon $true -Department $dept -DisplayName $fname -EmailAddress $email -GivenName $fname -Surname $lname -Enabled $True
    }

    #check if department group exists
    if (Get-ADGroup -F {name -eq $dept})
    {
        Write-Warning "group $dept exists"
    }

    #create group
    else
    {
        New-ADGroup -GroupScope Universal -Name $dept
    }

    #add user to group
    Add-ADGroupMember -Identity $dept -Members $username
}
