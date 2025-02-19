report 50105 "Sacco Users Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './SaccoUsersReport.rdl';

    dataset
    {
        dataitem(SaccoUser; "Sacco User")
        {
            column(UserID; "User ID") { }
            column(UserName; "User Name") { }
            column(Email; Email) { }
            column(UserRole; "User Role") { }
            column(FirstName; "First Name") { }
            column(LastName; "Last Name") { }
            column(PhoneNo; "Phone No.") { }
            column(Status; Status) { }
            column(Location; Location) { }
            column(Savings; Savings) { }
            column(LoanBalance; LoanBalance) { }
            column(RegistrationTime; "Registration Time") { }
            column(CompanyName; CompanyProperty.DisplayName()) { }
        }
    }
}