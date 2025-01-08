page 50117 "Member Loan History"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Repayment Journal";
    Caption = 'Loan History';
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(LoanHistory)
            {
                field("Loan ID"; Rec."Loan ID")
                {
                    ApplicationArea = All;
                    StyleExpr = StatusStyleExpr;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Loan Purpose"; Rec."Loan Purpose")
                {
                    ApplicationArea = All;
                }
                field("Repayment Period"; Rec."Repayment Period")
                {
                    ApplicationArea = All;
                }
                field("Monthly Repayment Amount"; Rec."Monthly Repayment Amount")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
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

    trigger OnOpenPage()
    var
        SaccoUserMgt: Codeunit "Sacco User Management";
        SaccoUser: Record "Sacco User";
    begin
        if SaccoUserMgt.GetCurrentUser(SaccoUser) then
            Rec.SetRange("Member ID", SaccoUser."User ID");
    end;

    trigger OnAfterGetRecord()
    begin
        case Rec.Status of
            Rec.Status::Pending:
                StatusStyleExpr := 'Attention';
            Rec.Status::Approved:
                StatusStyleExpr := 'Favorable';
            Rec.Status::Rejected:
                StatusStyleExpr := 'Unfavorable';
        end;
    end;
}
