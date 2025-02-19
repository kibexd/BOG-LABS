/// <summary>
/// Page Sacco User Card (ID 50101).
/// Displays detailed information for a single Sacco user.
/// </summary>
page 50140 "Sacco User Card"
{
    PageType = Card;
    SourceTable = "Sacco User";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the User ID';
                }
                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the User Name';
                }
                field("Email"; Rec."Email")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Email address';
                }
                field("User Role"; Rec."User Role")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the User Role';
                }
            }
            group("Personal Information")
            {
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the First Name';
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Last Name';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Phone Number';
                }
                field("Gender"; Rec."Gender")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Gender';
                }
                field("Location"; Rec."Location")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Location';
                }
            }
            group("Account Information")
            {
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the user is Active or Inactive';
                }
                field(Savings; Rec.Savings)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user''s savings amount';
                }
                field(LoanBalance; Rec.LoanBalance)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user''s loan balance';
                }
                field("Next Payment Date"; Rec."Next Payment Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the next payment date';
                }
            }
        }
    }
}