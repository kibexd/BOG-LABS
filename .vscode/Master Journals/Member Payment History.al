page 50118 "Member Payment History"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Posted Loan Repayments Ledger";
    Caption = 'Payment History';
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    SourceTableView = where("Entry Type" = const(Repayment));

    layout
    {
        area(Content)
        {
            repeater(PaymentHistory)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    StyleExpr = StatusStyleExpr;
                }
                field("Loan ID"; Rec."Loan ID")
                {
                    ApplicationArea = All;
                }
                field("Repayment Amount"; Rec."Repayment Amount")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Description"; Rec.Description)
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
        // Set style based on status
        case Rec.Status of
            Rec.Status::Active:
                StatusStyleExpr := 'Attention';
            Rec.Status::Completed:
                StatusStyleExpr := 'Favorable';
            Rec.Status::Defaulted:
                StatusStyleExpr := 'Unfavorable';
        end;

        // Set style for remaining amount
        if Rec."Remaining Amount" > 0 then
            RemainingAmountStyleExpr := 'Attention'
        else
            RemainingAmountStyleExpr := 'Favorable';
    end;
}

