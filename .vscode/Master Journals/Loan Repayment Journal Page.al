page 50115 "Loan Repayment Journal Page"
{
    PageType = List;
    UsageCategory = Administration;
    ApplicationArea = All;
    SourceTable = "Loan Repayment Journal";
    Caption = 'Loan Repayment Journal';

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
                field("Repayment Date"; Rec."Repayment Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing) // This is the action area for your actions
        {
            action(PostLoanRepayment)
            {
                Caption = 'Post Loan Repayment';
                Image = Post;
                ApplicationArea = All;

                trigger OnAction()
                var
                    LoanRepaymentJournalRec: Record "Loan Repayment Journal";
                    PostedLoanLedgerRec: Record "Posted Loan Repayments Ledger";
                    ConfirmDelete: Boolean; // Confirmation variable
                begin
                    if Rec.FindSet() then begin
                        repeat
                            // Validate repayment amount
                            if Rec."Repayment Amount" <= 0 then begin
                                Error('Repayment amount must be greater than zero.');
                                exit;
                            end;

                            // Insert into Posted Loan Repayments Ledger
                            PostedLoanLedgerRec.Init();
                            PostedLoanLedgerRec."Repayment ID" := Rec."Repayment ID";
                            PostedLoanLedgerRec."Member ID" := Rec."Member ID";
                            PostedLoanLedgerRec."Loan ID" := Rec."Loan ID";
                            PostedLoanLedgerRec."Repayment Amount" := Rec."Repayment Amount";
                            PostedLoanLedgerRec."Posted Date" := Today();
                            PostedLoanLedgerRec.Insert();

                            // Ask for confirmation before deleting
                            ConfirmDelete := Confirm('Do you want to delete this record from Loan Repayment Journal?');
                            if ConfirmDelete then
                                Rec.Delete(); // Delete only if confirmed
                        until Rec.Next() = 0;
                    end;
                end;
            }
        }
    }
}
