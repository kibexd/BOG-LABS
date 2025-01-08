report 50104 "Reports Test 1"
{
    ApplicationArea = All;
    Caption = 'Reports Test 1';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Test Report.RDL';
    DefaultLayout = RDLC;
    dataset
    {
        dataitem(SaccoUser; "Sacco User")
        {
            column(Email; Email)
            {
            }
            column(FirstName; "First Name")
            {
            }
            column(Gender; Gender)
            {
            }
            column(Image; Image)
            {
            }
            column(LastName; "Last Name")
            {
            }
            column(LoanBalance; "Loan Balance")
            {
            }
            column(UserID; "User ID")
            {
            }
            column(UserName; "User Name")
            {
            }
            column(UserRole; "User Role")
            {
            }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
}
