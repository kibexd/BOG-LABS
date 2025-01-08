page 50124 "Loan Application Card"
{
    PageType = Card;
    SourceTable = "Loan Repayment Journal";
    Caption = 'Loan Application Card';
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
            }

            group(Tracking)
            {
                Caption = 'Tracking Information';
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    ApplicationArea = All;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
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
                Enabled = Rec.Status = Rec.Status::Pending;

                trigger OnAction()
                var
                    LoanPosting: Codeunit "Loan Repayment Posting";
                begin
                    if Confirm('Are you sure you want to approve this loan application?') then begin
                        Rec.Status := Rec.Status::Approved;
                        Rec.Modify();
                        LoanPosting.PostLoanApplication(Rec);
                        Message('Loan application approved successfully.');
                        CurrPage.Close();
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
                Enabled = Rec.Status = Rec.Status::Pending;

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to reject this loan application?') then begin
                        Rec.Status := Rec.Status::Rejected;
                        Rec.Modify();
                        Message('Loan application rejected.');
                        CurrPage.Close();
                    end;
                end;
            }
        }
    }

    var
        StatusStyleExpr: Text;

    trigger OnAfterGetRecord()
    begin
        // Set style based on status
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