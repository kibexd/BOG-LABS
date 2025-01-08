page 50130 "Admin Loan List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Posted Loan Repayments Ledger";
    Caption = 'All Loans';
    CardPageId = "Posted Loan Card";

    layout
    {
        area(Content)
        {
            repeater(Loans)
            {
                field("Loan ID"; Rec."Loan ID")
                {
                    ApplicationArea = All;
                }
                field("Member ID"; Rec."Member ID")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = All;
                    StyleExpr = RemainingAmountStyleExpr;
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
        RemainingAmountStyleExpr: Text;

    trigger OnAfterGetRecord()
    begin
        case Rec.Status of
            Rec.Status::Active:
                StatusStyleExpr := 'Attention';
            Rec.Status::Completed:
                StatusStyleExpr := 'Favorable';
            Rec.Status::Defaulted:
                StatusStyleExpr := 'Unfavorable';
        end;

        if Rec."Remaining Amount" > 0 then
            RemainingAmountStyleExpr := 'Attention'
        else
            RemainingAmountStyleExpr := 'Favorable';
    end;
}