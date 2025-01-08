// Welcome to the "Login Action Buttons" page, where the magic of user authentication happens! 
// This page is like the friendly doorman of a fancy club, checking if you're on the guest list 
// (a.k.a. if you have the right credentials) before letting you in to the exclusive world of your account.
// 
// Here, we have a button that serves as the gateway for users to either log in to their existing accounts 
// or register for a brand new one. Think of it as a magical button that transforms based on your needs—
// if you're feeling like a seasoned member, it shouts "🔑 Login!" but if you're a newbie ready to join the fun, 
// it cheerfully says "📝 Register!" 
//
// When you click this button, it doesn't just sit there; it springs into action, calling upon the "Sacco Login and Registration" page 
// to perform its duties. It's like a superhero, swooping in to save the day by handling your login or registration 
// with grace and style. 
//
// The layout is designed to be as user-friendly as a puppy in a room full of kittens, ensuring that even your grandma 
// could navigate it without breaking a sweat. So, buckle up and get ready to dive into the world of user actions, 
// where every click counts and every button has a purpose!
page 50108 "Login Action Buttons" // This defines a page for the login action buttons
{
    PageType = CardPart; // The type of page is a card part
    Caption = ' '; // The caption for the page is empty

    layout // This section defines how the page is laid out
    {
        area(Content) // This is the main content area of the page
        {
            group(Buttons) // This group contains the buttons
            {
                ShowCaption = false; // Do not show the caption for this group
                field(ActionButton; ActionButtonCaption) // This field represents the action button
                {
                    ApplicationArea = All; // This field is available in all application areas
                    Style = Strong; // The button style is set to strong
                    StyleExpr = 'Favorable'; // The style expression is set to favorable
                    ShowCaption = false; // Do not show the caption for this field
                    Editable = false; // This field cannot be edited

                    trigger OnDrillDown() // This code runs when the button is clicked
                    var
                        LoginPage: Page "Sacco Login and Registration"; // Declare a variable for the login page
                    begin
                        LoginPage.PerformAction(); // Directly call the action on the login page
                        CurrPage.Close(); // Close the current page
                    end;
                }
            }
        }
    }

    trigger OnOpenPage() // This code runs when the page is opened
    begin
        UpdateActionButton(); // Calls a function to update the action button caption
    end;

    var
        ActionButtonCaption: Text; // Variable to store the caption for the action button
        ActionType: Option Login,Register; // Variable to store the selected action (Login or Register)

    procedure UpdateActionButton() // This function updates the action button caption
    var
        LoginPage: Page "Sacco Login and Registration"; // Declare a variable for the login page
    begin
        // Correctly access the ActionType variable
        if ActionType = ActionType::Login then // Check if the action is Login
            ActionButtonCaption := '🔑 Login' // Set the button caption to Login
        else
            ActionButtonCaption := '📝 Register'; // Otherwise, set it to Register
    end;
}