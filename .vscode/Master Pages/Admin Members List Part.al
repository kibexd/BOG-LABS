page 50128 "Admin Members List Part"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Sacco User";
    Caption = 'Members List';

    layout
    {
        area(Content)
        {
            repeater(Members)
            {
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = All;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = All;
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = All;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    StyleExpr = StatusStyleExpr;
                }
            }
        }
    }

    var
        StatusStyleExpr: Text;

    trigger OnAfterGetRecord()
    begin
        if Rec.Status = Rec.Status::Active then
            StatusStyleExpr := 'Favorable'
        else
            StatusStyleExpr := 'Unfavorable';
    end;
}