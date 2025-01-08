// Table for Loan Applications
table 50104 "Loan Application"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Loan ID"; Code[20])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Loan ID" = '' then
                    "Loan ID" := GetNextLoanID();
            end;
        }
        field(2; "Member ID"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Sacco Member";
        }
        field(3; "Loan Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CalculateLoanDetails();
            end;
        }
        field(4; "Loan Duration Months"; Integer)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CalculateLoanDetails();
            end;
        }
        field(5; "Start Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(6; "End Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Monthly Interest Rate"; Decimal)
        {
            DataClassification = CustomerContent;
            InitValue = 2;
        }
        field(8; "Total Interest Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Monthly Payment"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Total Amount Due"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(11; "Status"; Option)
        {
            OptionMembers = "Pending","Approved","Rejected";
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Loan ID")
        {
            Clustered = true;
        }
    }

    local procedure GetLastLoanID(): Code[20]
    var
        LastLoanID: Code[20];
    begin
        // Logic to retrieve the last Loan ID
        // This is a placeholder; implement your logic here
        LastLoanID := ''; // Replace with actual retrieval logic
        exit(LastLoanID);
    end;

    local procedure GetNextLoanID(): Code[20]
    var
        LastLoanID: Code[20];
        YearPrefix: Text;
        NewNumber: Integer;
    begin
        YearPrefix := Format(Date2DMY(Today, 3));
        LastLoanID := GetLastLoanID(); // Ensure this function is defined

        if LastLoanID <> '' then
            Evaluate(NewNumber, CopyStr(LastLoanID, 5))
        else
            NewNumber := 0;

        NewNumber += 1;
        exit(YearPrefix + Format(NewNumber, 4, '<Integer,4><Filler Character,0>'));
    end;

    local procedure CalculateLoanDetails()
    begin
        if ("Loan Amount" = 0) or ("Loan Duration Months" = 0) then
            exit;

        // Calculate interest for the entire duration
        "Total Interest Amount" := "Loan Amount" * ("Monthly Interest Rate" / 100) * "Loan Duration Months";
        "Total Amount Due" := "Loan Amount" + "Total Interest Amount";
        "Monthly Payment" := "Total Amount Due" / "Loan Duration Months";

        // Set end date
        "End Date" := CalcDate(StrSubstNo('<%1M>', "Loan Duration Months"), "Start Date");
    end;
}
