pageextension 50100 "General Ledger Setup Page Ext" extends "General Ledger Setup"
{
    layout
    {
        addlast(Content)
        {
            group(LoanSetup)
            {
                Caption = 'Loan Setup';
                Visible = true;

                field("Loan Nos."; Rec."Loan Nos.")
                {
                    ApplicationArea = All;
                    Caption = 'Loan Number Series';
                    ToolTip = 'Specifies the number series code for loan numbers';
                    TableRelation = "No. Series";

                    trigger OnValidate()
                    var
                        CurrentNoSeriesCode: Code[20];
                    begin
                        if Rec."Loan Nos." <> '' then begin
                            CurrentNoSeriesCode := Rec."Loan Nos.";
                            NoSeriesManagement.TestSeries(CurrentNoSeriesCode, Rec."Loan Nos.");
                        end;
                    end;
                }
            }
        }
    }

    actions
    {
        addlast(navigation)
        {
            action(LoanNumberSeries)
            {
                ApplicationArea = All;
                Caption = 'Loan Number Series';
                Image = NumberSetup;
                RunObject = Page "No. Series";
                RunPageLink = Code = field("Loan Nos.");
                ToolTip = 'Set up number series for loan documents';
            }
        }
    }

    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
}