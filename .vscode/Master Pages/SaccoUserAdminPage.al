page 50109 "Sacco User Admin"
{
    PageType = List;
    SourceTable = "Sacco User";
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Sacco User Administration';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = All;
                }
                field("Email"; Rec.Email)
                {
                    ApplicationArea = All;
                }
                field("User Role"; Rec."User Role")
                {
                    ApplicationArea = All;
                }
                field("Status"; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Password"; Rec.Password)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        // Set filter to show only Admin users
        Rec.SetRange("User Role", Rec."User Role"::Admin);
    end;
}
