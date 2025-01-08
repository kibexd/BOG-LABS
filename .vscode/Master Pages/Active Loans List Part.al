page 50136 "Active Loans List Part"
{
    // Access = Internal;
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Repayment Journal";
    Caption = 'Active Loans';
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(ActiveLoans)
            {
                field("Loan ID"; Rec."Loan ID")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Monthly Repayment Amount"; Rec."Monthly Repayment Amount")
                {
                    ApplicationArea = All;
                }
                field("Repayment Period"; Rec."Repayment Period")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        FilterActiveLoans();
    end;

    trigger OnAfterGetRecord()
    begin
        StyleTxt := SetStyle();
    end;

    local procedure FilterActiveLoans()
    begin
        Rec.Reset();
        Rec.SetRange(Status, "Loan Repayment Status"::Active);
        // Only show loans, not repayments
        Rec.SetRange("Document Type", Rec."Document Type"::Application);
    end;

    local procedure SetStyle(): Text
    begin
        case Rec.Status of
            "Loan Repayment Status"::Active:
                exit('Favorable');
            "Loan Repayment Status"::Pending:
                exit('Ambiguous');
            "Loan Repayment Status"::Defaulted:
                exit('Unfavorable');
            "Loan Repayment Status"::Completed:
                exit('Standard');
            "Loan Repayment Status"::Repayment:
                exit('Attention');
        end;
    end;

    var
        StyleTxt: Text;
}
