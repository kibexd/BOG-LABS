page 50134 "Loan Repayment Page"
{
    PageType = List;
    SourceTable = "Posted Loan Repayments Ledger"; // Assuming this table holds the approved loans
    Caption = 'Loan Repayment';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Loan ID"; Rec."Loan ID")
                {
                    ApplicationArea = All;
                }
                field("Member ID"; Rec."Member ID")
                {
                    ApplicationArea = All;
                }
                field("Amount"; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = All;
                }
                field("Repayment Amount"; RepaymentAmount)
                {
                    ApplicationArea = All;
                    Caption = 'Enter Repayment Amount';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SubmitRepayment)
            {
                ApplicationArea = All;
                Caption = 'Submit Repayment';
                Image = Payment;

                trigger OnAction()
                var
                    LoanPosting: Codeunit "Loan Repayment Posting";
                    LoanRepaymentJournalRec: Record "Loan Repayment Journal"; // New record for Loan Repayment Journal
                begin
                    // Loop through the selected loans and process repayments
                    if Rec.FindSet() then begin
                        repeat
                            if RepaymentAmount > 0 then begin
                                // Initialize the Loan Repayment Journal record
                                LoanRepaymentJournalRec.Init();
                                LoanRepaymentJournalRec."Loan ID" := Rec."Loan ID";
                                LoanRepaymentJournalRec."Member ID" := Rec."Member ID";
                                LoanRepaymentJournalRec."Repayment Amount" := RepaymentAmount; // Use the entered repayment amount
                                LoanRepaymentJournalRec."Posting Date" := Today(); // Set the posting date

                                // Call the repayment posting procedure
                                if LoanPosting.PostRepayment(LoanRepaymentJournalRec) then
                                    Message('Repayment of %1 submitted for Loan ID: %2', RepaymentAmount, Rec."Loan ID");
                                // else
                                Error('Failed to post repayment for Loan ID: %1', Rec."Loan ID");
                            end;
                        until Rec.Next() = 0;
                    end;
                end;
            }
        }
    }

    var
        RepaymentAmount: Decimal; // Variable to hold the repayment amount
}
