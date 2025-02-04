/*
    Project 01
    
    Requirements (for 15 base points)
    - Create an interactive fiction story with at least 8 knots 
    - Create at least one major choice that the player can make
    - Reflect that choice back to the player
    - Include at least one loop
    
    To get a full 20 points, expand upon the game in the following ways
    [+2] Include more than eight passages
    [+1] Allow the player to pick up items and change the state of the game if certain items are in the inventory. Acknowledge if a player does or does not have a certain item
    [+1] Give the player statistics, and allow them to upgrade once or twice. Gate certain options based on statistics (high or low. Maybe a weak person can only do things a strong person can't, and vice versa)
    [+1] Keep track of visited passages and only display the description when visiting for the first time (or requested)
    
    Make sure to list the items you changed for points in the Readme.md. I cannot guess your intentions!

*/

VAR money = 100
VAR pouvias = ""
VAR hasPassport = false
VAR hasCheckedBag = false
VAR hasCarryOn = false
VAR travelSkill = 1
VAR timeRemaining = 60
VAR upgrades = 0

VAR visitedTerminal = false
VAR visitedLounge = false
VAR visitedCheckIn = false
VAR visitedSecurity = false
VAR visitedHandLuggage = false
VAR visitedGate = false

-> start

=== start ===
Welcome to your adventurous vacation journey! Today you're about to catch a flight – and every decision you make will shape your adventure.
Your starting budget is {money} money.
Are you ready?
-> choose_ticket

=== choose_ticket ===
When buying your plane ticket, you have two options:
* [Buy an expensive premium ticket (costs 50 money, leaving you with less money for vacation)]
    ~ pouvias = "premium"
    ~ money = money - 50
    You decided on a premium ticket. You now have {money} money left for other expenses. (premium ticket)
    -> pack
* [Buy a cheap economy ticket (costs 20 money)]
    ~ pouvias = "economy"
    ~ money = money - 20
    You decided on an economy ticket. You saved money, which might come in handy later. (economy ticket)
    -> pack

=== pack ===
Now it's time to pack for your journey.
-> pack_loop

=== pack_loop ===
What would you like to pack?
* [Passport]
    { hasPassport:
         You already have your passport packed.
     - else:
         You packed your passport.
         ~ hasPassport = true
    }
    -> pack_loop
* [Suitcase (checked baggage)]
    { hasCheckedBag:
         You already have your suitcase packed.
     - else:
         You packed your suitcase.
         ~ hasCheckedBag = true
    }
    -> pack_loop
* [Carry-on Luggage]
    { hasCarryOn:
         You already have your carry-on luggage packed.
     - else:
         You packed your carry-on luggage.
         ~ hasCarryOn = true
    }
    -> pack_loop
+ [Done packing]
    -> travel_preparation

=== travel_preparation ===
You currently have {travelSkill} travel savvy point(s). Studying a travel guide can help you navigate airport procedures more efficiently. You have the opportunity to study the guide up to two times.
{ upgrades < 2:
    * [Study the travel guide to improve your travel savvy]
         ~ travelSkill = travelSkill + 1
         ~ upgrades = upgrades + 1
         You read the travel guide and learn useful tips about airport navigation and security checks. Your travel savvy increases to {travelSkill}.
         -> travel_preparation
    + [Skip studying and move to airport]
         -> terminal
- else:
    You have absorbed all the travel tips available.
    + [Move to terminal] -> terminal
}

=== terminal ===
{ visitedTerminal:
    You are back in the bustling airport terminal.
- else:
    You arrive at the spacious airport terminal. The vibrant chatter of travelers and the myriad of departure boards create an exciting atmosphere.
    ~ visitedTerminal = true
}
You have {timeRemaining} minutes left until your flight departs.
What would you like to do?
* [Check your status]
    -> status_terminal
+ [Go to the Check-In Area]
    -> check_in
+ [Visit the Lounge]
    -> lounge

=== status_terminal ===
Time remaining: {timeRemaining} minutes. Money: {money}.
-> terminal

=== lounge ===
{ visitedLounge:
    ~ timeRemaining = timeRemaining - 10
    You are back in the comfortable lounge area.
- else:
    ~ timeRemaining = timeRemaining - 10
    You step into the lounge, where plush seats and the aroma of fresh coffee offer a moment of relaxation before your flight.
    ~ visitedLounge = true
}
What would you like to do?
+ [Check your status]
    -> status_lounge
+ [Return to the Terminal]
    -> terminal

=== status_lounge ===
Time remaining: {timeRemaining} minutes. Money: {money}.
-> lounge

=== check_in ===
{ visitedCheckIn:
    You are back in the busy check-in area.
- else:
    You enter the check-in area, where counters bustle with activity as airline staff assist passengers.
    ~ visitedCheckIn = true
}
What would you like to do?
+ [Check your status]
    -> status_check_in
+ [Proceed with Check-In]
    -> checkin_choice
+ [Return to the Terminal]
    -> terminal

=== status_check_in ===
Time remaining: {timeRemaining} minutes. Money: {money}.
-> check_in

=== checkin_choice ===
{ hasPassport:
    At the check-in area, your method depends on your baggage:
    { hasCheckedBag:
         Since you have checked baggage, you must check in at the counter.
         -> counter_checkin
      - else:
         You only have carry-on luggage. How would you like to check in?
         + [Online check-in] -> online_checkin
         + [Check-in at the counter] -> counter_checkin
    }
- else:
    You realize you forgot your passport! You must return for it, losing 30 minutes.
    ~ timeRemaining = timeRemaining - 30
    -> pack_loop
}

=== online_checkin ===
{ hasPassport:
    Online check-in was quick and efficient.
    ~ timeRemaining = timeRemaining - 5
    -> security_area
- else:
    You realize you forgot your passport! You must return for it, losing 30 minutes.
    ~ timeRemaining = timeRemaining - 30
    -> pack_loop
}

=== counter_checkin ===
{ hasPassport:
    You wait at the counter, where check-in takes a bit longer.
    ~ timeRemaining = timeRemaining - 10
    { pouvias == "economy":
         Because you have an economy ticket, you are offered an upgrade to premium for 30 money.
         * [Accept the upgrade offer]
             { money >= 30:
                  -> upgrade_at_counter
             - else:
                  Unfortunately, you do not have enough money for an upgrade. You continue without upgrading.
                  -> security_area
             }
         * [Decline the upgrade and continue] -> security_area
      - else:
         You already have a premium ticket, so you continue checking in.
         -> security_area
    }
- else:
    You realize you forgot your passport! You must return for it, losing 30 minutes.
    ~ timeRemaining = timeRemaining - 30
    -> pack_loop
}

=== upgrade_at_counter ===
~ pouvias = "premium"
~ money = money - 30
You upgraded your ticket to premium. You now have {money} money remaining.
-> security_area

=== security_area ===
{ visitedSecurity:
    You are back at the security checkpoint.
- else:
    You arrive at the security area, where separate lanes and vigilant security staff streamline the process.
    ~ visitedSecurity = true
}
What would you like to do?
* [Check your status]
    -> status_security
* [Proceed with Security Check]
    -> security_check

=== status_security ===
Time remaining: {timeRemaining} minutes. Money: {money}.
-> security_area

=== security_check ===
{ pouvias == "premium":
    Thanks to your premium ticket, you use a dedicated security lane and pass through quickly.
    ~ timeRemaining = timeRemaining - 5
- else:
    You join a long queue at security.
    ~ timeRemaining = timeRemaining - 15
}
-> hand_luggage_area

=== hand_luggage_area ===
{ visitedHandLuggage:
    You are back at the hand luggage inspection area.
- else:
    You reach the hand luggage checkpoint, where your carry-on luggage is the focus of the inspection.
    ~ visitedHandLuggage = true
}
What would you like to do?
* [Check your status]
    -> status_hand_luggage
* [Proceed with Luggage Inspection]
    -> hand_luggage_check
* [Try to return to Security Area]
    -> return_complication

=== status_hand_luggage ===
Time remaining: {timeRemaining} minutes. Money: {money}.
-> hand_luggage_area

=== return_complication ===
As you attempt to return, security personnel become suspicious and detain you for a full security check.
~ timeRemaining = timeRemaining - 10
You have lost extra time due to the additional security check.
-> hand_luggage_check

=== hand_luggage_check ===
{ hasCarryOn:
    Your carry-on luggage is now inspected.
    { travelSkill >= 2:
         Thanks to your enhanced travel savvy, you breeze through the inspection without any issues.
         -> gate_area
     - else:
         ~ temp roll = RANDOM(1,2)
         { roll == 1:
              Something in your carry-on luggage raises suspicion – a complication occurs!
              -> complication
          - else:
              Your carry-on luggage is cleared without incident.
              -> gate_area
         }
    }
- else:
    You don't have a carry-on luggage, so security checks your pockets instead.
    { travelSkill >= 2:
         Thanks to your enhanced travel savvy, you quickly produce all necessary items and the inspection is smooth.
         -> gate_area
     - else:
         ~ temp rollPockets = RANDOM(1,2)
         { rollPockets == 1:
              The pocket inspection raises suspicion – a complication occurs!
              -> complication
          - else:
              Your pockets are inspected and nothing problematic is found.
              -> gate_area
         }
    }
}

=== complication ===
A complication delays you. You must wait an extra 10 minutes.
~ timeRemaining = timeRemaining - 10
-> gate_area

=== gate_area ===
{ visitedGate:
    You are back at the boarding gate.
- else:
    You approach the boarding gate—a crucial point as the final call for boarding nears.
    ~ visitedGate = true
}
What would you like to do?
+ [Check your status]
    -> status_gate
+ [Visit the in-flight shop]
    -> inflight_purchase
* [Proceed to the Gate]
    -> gate

=== status_gate ===
Time remaining: {timeRemaining} minutes. Money: {money}.
-> gate_area

=== inflight_purchase ===
Welcome to the in-flight shop. You have the opportunity to buy an in-flight guide for 20 money. This guide will enhance your travel savvy.
+ [Buy the in-flight guide for 20 money]
    { money >= 20:
         ~ money = money - 20
         ~ travelSkill = travelSkill + 1
         You purchased the in-flight guide! Your travel savvy increases to {travelSkill}.
         -> gate_area
     - else:
         You do not have enough money to buy the guide.
         -> gate_area
    }
+ [Leave the shop]
    -> gate_area

=== gate ===
Approaching the gate takes another 5 minutes.
~ timeRemaining = timeRemaining - 5
{ timeRemaining > 0:
    You made it to the gate in time! You have {timeRemaining} minutes left before the flight departs. Enjoy your vacation!
- else:
    Unfortunately, you ran out of time and missed your flight. Game over.
}
-> ending

=== ending ===

-> END











