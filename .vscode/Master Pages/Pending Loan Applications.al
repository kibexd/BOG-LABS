page 50123 "Pending Loan Applications"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Repayment Journal";
    Caption = 'Pending Loan Applications';
    SourceTableView = where(Status = const(Pending));
    CardPageId = "Loan Application Card";

    layout
    {
        area(Content)
        {
            repeater(Applications)
            {
                field("Loan ID"; Rec."Loan ID")
                {
                    ApplicationArea = All;
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
                field("Repayment Period"; Rec."Repayment Period")
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

    actions
    {
        area(Processing)
        {
            action(Approve)
            {
                ApplicationArea = All;
                Caption = '✓ Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    LoanPosting: Codeunit "Loan Repayment Posting";
                begin
                    if Confirm('Are you sure you want to approve this loan application?') then begin
                        Rec.Status := Rec.Status::Approved;
                        Rec.Modify();
                        LoanPosting.PostLoanApplication(Rec);
                        Message('Loan application approved successfully.');
                    end;
                end;
            }

            action(Reject)
            {
                ApplicationArea = All;
                Caption = '✗ Reject';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to reject this loan application?') then begin
                        Rec.Status := Rec.Status::Rejected;
                        Rec.Modify();
                        Message('Loan application rejected.');
                    end;
                end;
            }
        }
    }
}