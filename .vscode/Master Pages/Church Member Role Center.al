page 50103 "Sacco Member Role Center"
{
    PageType = RoleCenter;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Sacco Member Role Center';

    layout
    {
        area(RoleCenter)
        {
            part(MemberInfoPart; "Sacco Member Info Part")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Embedding)
        {
            group(MemberActions)
            {
                Caption = 'Member Actions';

                action(MyProfile)
                {
                    ApplicationArea = All;
                    Caption = '👤 My Profile';
                    Image = UserSetup;
                    Promoted = true;
                    PromotedCategory = Process;
                }

                action(Savings)
                {
                    ApplicationArea = All;
                    Caption = '💰 Savings';
                    Image = Payment;
                    Promoted = true;
                    PromotedCategory = Process;
                    // RunObject = Page "Sacco Savings List";
                }

                action(Loans)
                {
                    ApplicationArea = All;
                    Caption = '📋 Loans';
                    Image = Loan;
                    Promoted = true;
                    PromotedCategory = Process;
                    // RunObject = Page "Sacco Loans List";
                }

                action(Statements)
                {
                    ApplicationArea = All;
                    Caption = '📄 Statements';
                    Image = Report;
                    Promoted = true;
                    PromotedCategory = Process;
                    // RunObject = Page "Sacco Statement List";
                }

                action(Reports)
                {
                    ApplicationArea = All;
                    Caption = '📊 Reports';
                    Image = Report;
                    Promoted = true;
                    PromotedCategory = Process;
                    // RunObject = Page "Sacco Reports";
                }
            }
        }
    }
}