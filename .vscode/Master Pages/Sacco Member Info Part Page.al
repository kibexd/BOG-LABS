page 50114 "Sacco Member Info Part"
{
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(MemberInfo)
            {
                Caption = 'Member Information';

                field(CurrentSavings; GetCurrentSavings())
                {
                    ApplicationArea = All;
                    Caption = 'Your Savings Balance';
                    Editable = false;
                    Style = Favorable;
                }
                field(LoanBalance; GetLoanBalance())
                {
                    ApplicationArea = All;
                    Caption = 'Your Loan Balance';
                    Editable = false;
                    Style = Favorable;
                }
                field(NextPayment; GetNextPaymentDate())
                {
                    ApplicationArea = All;
                    Caption = 'Next Payment Due';
                    Editable = false;
                }
            }
        }
    }

    local procedure GetCurrentSavings(): Decimal
    var
        SaccoMember: Record "Sacco Member";
    begin
        if SaccoMember.Get(UserId) then
            exit(SaccoMember.SavingsBalance)
        else
            exit(0);
    end;

    local procedure GetLoanBalance(): Decimal
    var
        SaccoMember: Record "Sacco Member";
    begin
        if SaccoMember.Get(UserId) then
            exit(SaccoMember.LoanBalance)
        else
            exit(0);
    end;

    local procedure GetNextPaymentDate(): Text[30]
    var
        SaccoMember: Record "Sacco Member";
    begin
        if SaccoMember.Get(UserId) then begin
            if SaccoMember.NextPaymentDate <> 0D then
                exit(Format(SaccoMember.NextPaymentDate))
            else
                exit('No payment due');
        end else
            exit('No payment due');
    end;
}