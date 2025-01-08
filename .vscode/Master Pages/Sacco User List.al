page 50101 "Sacco User List"
{
    PageType = List;
    SourceTable = "Sacco User";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User ID"; "UserId")
                {
                    ApplicationArea = All;
                }
                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = All;
                }
                field("Email"; Rec.Email)
                {
                    ApplicationArea = All;
                }
                field("User Role"; Rec."User Role")
                {
                    ApplicationArea = All;
                }
                field("Status"; Rec.Status)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(New)
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    UserRec: Record "Sacco User";
                    UserMgmt: Codeunit "Sacco User Management"; // Reference to the codeunit
                begin
                    UserRec.Init();
                    UserRec."User ID" := UserMgmt.GenerateUniqueUserID(); // Use the method from the correct codeunit
                    UserRec.Insert(true);
                    // Optionally, you can open a card page for the new record
                end;
            }

            action(Delete)
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    UserRec: Record "Sacco User";
                begin
                    if UserRec.Get(Rec."User ID") then begin
                        UserRec.Delete();
                    end;
                end;
            }

            action(Save)
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    UserRec: Record "Sacco Member";
                begin
                    if UserRec.Get(Rec."User ID") then begin
                        UserRec.Modify();
                    end;
                end;
            }
        }
    }
}
