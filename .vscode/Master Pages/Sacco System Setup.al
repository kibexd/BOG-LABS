page 50133 "Sacco System Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "General Ledger Setup";
    Caption = 'Sacco System Setup';
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(NumberSeries)
            {
                Caption = 'Number Series Setup';

                field("Loan Nos."; Rec."Loan Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series code for loan numbers';
                }
            }

            group(LoanSetup)
            {
                Caption = 'Loan Parameters';

                field(MinLoanAmount; MinLoanAmount)
                {
                    ApplicationArea = All;
                    Caption = 'Minimum Loan Amount';

                    trigger OnValidate()
                    begin
                        SaveSetup();
                    end;
                }
                field(MaxLoanAmount; MaxLoanAmount)
                {
                    ApplicationArea = All;
                    Caption = 'Maximum Loan Amount';

                    trigger OnValidate()
                    begin
                        SaveSetup();
                    end;
                }
                field(DefaultInterestRate; DefaultInterestRate)
                {
                    ApplicationArea = All;
                    Caption = 'Default Interest Rate (%)';
                    DecimalPlaces = 2;

                    trigger OnValidate()
                    begin
                        SaveSetup();
                    end;
                }
            }
        }
    }

    var
        MinLoanAmount: Decimal;
        MaxLoanAmount: Decimal;
        DefaultInterestRate: Decimal;

    trigger OnOpenPage()
    begin
        LoadSetup();
    end;

    local procedure LoadSetup()
    var
        Setup: Record "General Ledger Setup";
    begin
        if Setup.Get() then;
        // Load your custom settings here
    end;

    local procedure SaveSetup()
    var
        Setup: Record "General Ledger Setup";
    begin
        if Setup.Get() then begin
            // Save your custom settings here
            Setup.Modify();
        end;
    end;
}