table 50103 "Sacco Member"
{
    DataClassification = CustomerContent;
    Caption = 'Sacco Member';

    fields
    {
        field(1; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;
        }
        field(2; "SavingsBalance"; Decimal)
        {
            Caption = 'Savings Balance';
            DataClassification = CustomerContent;
        }
        field(3; "LoanBalance"; Decimal)
        {
            Caption = 'Loan Balance';
            DataClassification = CustomerContent;
        }
        field(4; "NextPaymentDate"; Date)
        {
            Caption = 'Next Payment Date';
            DataClassification = CustomerContent;
        }
        field(5; "No."; Code[20]) // Assuming this is the member number
        {
            Caption = 'Member Number';
            DataClassification = CustomerContent;
        }
        field(6; "Name"; Text[100]) // Assuming this is the member's name
        {
            Caption = 'Member Name';
            DataClassification = CustomerContent;
        }
        field(7; "Registration Date"; Date)
        {
            Caption = 'Registration Date';
            DataClassification = CustomerContent;
        }
        field(8; "Share Capital"; Decimal)
        {
            Caption = 'Share Capital';
            DataClassification = CustomerContent;
        }
        field(9; "Monthly Contribution"; Decimal)
        {
            Caption = 'Monthly Contribution';
            DataClassification = CustomerContent;
        }
        field(10; "Loan No."; Code[20]) // Add Loan No. field
        {
            Caption = 'Loan Number';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "User ID")
        {
            Clustered = true;
        }
    }
}
