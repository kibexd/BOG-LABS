report 50100 "Member List Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Member List Report.rdl';
    Caption = 'Member List Report';

    dataset
    {
        dataitem("Sacco User"; "Sacco User")
        {
            DataItemTableView = where("User Role" = const(Member));
            column(User_ID; "User ID")
            {
            }
            column(First_Name; "First Name")
            {
            }
            column(Last_Name; "Last Name")
            {
            }
            column(Email; Email)
            {
            }
            column(Phone_No_; "Phone No.")
            {
            }
            column(Status; Status)
            {
            }
            column(Location; Location)
            {
            }
        }
    }
}