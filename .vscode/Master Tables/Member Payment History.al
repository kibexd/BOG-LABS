table 50108 "Member Payment History"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Member ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Payment Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Payment Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Member ID")
        {
            Clustered = true;
        }
    }
}
