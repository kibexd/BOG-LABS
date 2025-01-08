page 50125 "Posted Loan Card"
{
    PageType = Card;
    SourceTable = "Posted Loan Repayments Ledger";
    Caption = 'Posted Loan Details';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General Information';
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    StyleExpr = StatusStyleExpr;
                }
                field("Member ID"; Rec."Member ID")
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

            group(LoanDetails)
            {
                Caption = 'Loan Details';
                field(Amount; Rec.Amount)
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
            }

            part(PaymentHistory; "Member Payment History")
            {
                ApplicationArea = All;
                Caption = 'Payment History';
                SubPageLink = "Loan ID" = field("Loan ID");
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