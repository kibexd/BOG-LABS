page 50127 "Pending Loans List Part"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Repayment Journal";
    Caption = 'Pending Loans';
    SourceTableView = where(Status = const(Pending));

    layout
    {
        area(Content)
        {
            repeater(PendingLoans)
            {
                field("Loan ID"; Rec."Loan ID")
                {
                    ApplicationArea = All;
                    StyleExpr = 'Attention';
                }
                field("Member ID"; Rec."Member ID")
                {
                    ApplicationArea = All;
                }
                field("Member Name"; Rec."Member Name")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Loan Purpose"; Rec."Loan Purpose")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Monthly Repayment Amount"; Rec."Monthly Repayment Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}