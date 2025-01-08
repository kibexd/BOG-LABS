page 50116 "Posted Loan Repayments Ledger"
{
    PageType = List;
    UsageCategory = Administration;
    ApplicationArea = All;
    SourceTable = "Posted Loan Repayments Ledger";
    Caption = 'Posted Loan Repayments Ledger';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Repayment ID"; Rec."Repayment ID")
                {
                    ApplicationArea = All;
                }
                field("Member ID"; Rec."Member ID")
                {
                    ApplicationArea = All;
                }
                field("Loan ID"; Rec."Loan ID")
                {
                    ApplicationArea = All;
                }
                field("Repayment Amount"; Rec."Repayment Amount")
                {
                    ApplicationArea = All;
                }
                field("Posted Date"; Rec."Posted Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
