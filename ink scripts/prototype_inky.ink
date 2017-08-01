INCLUDE functions
INCLUDE check_quest
INCLUDE ratings
INCLUDE results

//Set-up variables 
VAR car="none"
VAR home="none"
VAR credit_rating="none"
VAR car_cost=0

//accessories variables
VAR unlimited_data=false
VAR phone_mount=false
//VAR charging_cords=false
//VAR seat_covers=false
VAR cleaning_supplies=false
VAR biz_licence=false
VAR gym_member=false
//VAR tip_sign=false
VAR accessories_cost=0

//Vital stats variables
VAR current_city="none"
VAR ride_count=0
VAR fares_earned=0
VAR hours_driven=0
VAR day_ride_count=0
VAR day_fares_earned=0
VAR day_hours_driven=0
VAR rating=4.9
VAR ride_count_total=0
VAR fares_earned_total=0
VAR hours_driven_total=0
VAR tip_total=0
VAR XL_total=0

VAR kept_receipt=false
VAR miles_tracked=false
VAR money=0
VAR windshield_cracked=false
VAR ticketed=false
VAR saturday_off=false

// Quest variables
VAR quest_rides=0
VAR quest_bonus=0
VAR quest_completion=false
VAR weekday_quest_completion=false
VAR weekday_quest_bonus=0
VAR weekend_quest_completion=false
VAR weekend_quest_bonus=0

VAR helped_homework=false

VAR revenue_total=0
VAR cost_total=0

// Functional variables
VAR time_passing=false

->intro
=== intro ===
# intro
# link
Welcome!

* [Start] ->intro_1

= intro_1
# intro_1
# link
You're a full-time Uber driver trying to make ends meet.

You have one week to try to make $1000. Can you do it?
* [Yep!]
->choose_difficulty


=== choose_difficulty===
# button
->delay->
First, pick your character. Do you live in San Francisco or in Sacramento, where rent is cheaper?
* [San Francisco (easy)]You live in San Francisco (easy)
~ home="sf"
* [Sacramento (hard)]You live in Sacramento (hard)
~ home="sac"

- ~current_city=home
->credit

===credit===
# button
How is your credit rating?
* I have excellent credit (easy)
~ credit_rating="good"
* It's pretty terrible (hard)
~ credit_rating="bad"
- -> car_choice

===delay===
->->

=== car_choice ===
# button
~ temp prius_cost=0
~ temp minivan_cost=0
~ temp insurance=0
Now it's time to get a car. You'll have to lease one{credit_rating == "good":. Your good credit rating gets you a better deal.}{ credit_rating=="bad":, which will cost more due to your poor credit.}

The Prius is more fuel efficient, but the minivan qualifies for UberXL rides, which earn a higher fare.
{ credit_rating == "good":
    ~prius_cost=115
    ~minivan_cost=180
    ~insurance=25
- else:
    ~prius_cost=180
    ~minivan_cost=240
    ~insurance=60    
}

* [Toyota Prius (${prius_cost}/ week)] You pick the Toyota Prius. It costs ${prius_cost} per week, and can get up to 50 miles per gallon
~ car="Prius"
~ alter(car_cost, prius_cost)

* [Dodge minivan (${minivan_cost} / week)] You picked the Dodge minivan. It costs ${minivan_cost} per week, but UberXL rides earn higher fares
~ car="Minivan"
~ alter(car_cost, minivan_cost)
- You also need insurance, which costs ${insurance} a week because of your {credit_rating} credit.
~ alter(car_cost, insurance)

- ->buy_accessories
 
===buy_accessories===
# list
{!Let's get you set up to drive with a few accessories.} 
What {|else }do you want to buy?

* [Upgrade to an unlimited data plan ($20/week)]Unlimited data plan: Since you have to be constantly connected to the Uber app, this will save you from paying overage charges. 
    ~unlimited_data=true
    ~alter(accessories_cost,10)
    ->buy_accessories
* Phone mount & charging cords[ ($25)]: Every driver has one to hold their phone, so they can use it with one hand while keeping their eyes on the road. And you don't want to run out of batteries on your phone.
    ~phone_mount=true
    ~alter(accessories_cost,20)
    ->buy_accessories
/*
* Charging cords[ ($5)]: One for you and one for your passengers 
    ~charging_cords=true
    ~alter(accessories_cost,5)
    ->buy_accessories
 * Seat covers[ ($200)]: This will make it much easier to keep your seats clean 
    ~seat_covers=true
    ~alter(accessories_cost,200)
    ->buy_accessories 
    */
* Cleaning supplies[ ($40)]: In case someone makes a mess in your car 
    ~cleaning_supplies=true
    ~alter(accessories_cost,40)
    ->buy_accessories
* Business license[ ($91)]: You are technically running a business as an independent contracter to Uber 
    ~biz_licence=true
    ~alter(accessories_cost,91)
    ->buy_accessories
* Gym membership[ ($10/week)]: You could go work out, but the main perk is having a place to shower and freshen up.
    ~gym_member=true
    ~alter(accessories_cost,10)
    ->buy_accessories
/* * Make a sign asking for tips[ (free)]: You might get more tips, but risk getting lower ratings
    ~tip_sign=true
    ~alter(accessories_cost,0)
    ->buy_accessories
    */
* [{I don't need any of this|I'm done shopping}] 
{ 
- unlimited_data && phone_mount && cleaning_supplies && biz_licence && gym_member:You bought everything. It costs ${accessories_cost}.

 - !unlimited_data && !phone_mount && !cleaning_supplies && !biz_licence && !gym_member:You didn't buy anything.
 
 - else: You bought: 
 {unlimited_data:Unlimited data plan}
 {phone_mount:Phone mount}
// {charging_cords:Charging cords}
// {seat_covers:Seat covers}
 {cleaning_supplies:Cleaning supplies}
 {biz_licence:Business licence}
 {gym_member:Gym membership}
// {tip_sign:Tip sign}

It cost you ${accessories_cost}. You're ready to start driving!

} 
-> day_1_start

=== day_1_start ===
# day_1_start
# link
You start bright and early on a Monday morning.
* [Next] ->weekday_quest_message

=weekday_quest_message
#weekday_quest_message
# link
~quest_rides=75
~quest_bonus=180
~weekday_quest_bonus=quest_bonus
MESSAGE FROM UBER: "Drive {quest_rides} trips, make ${quest_bonus} extra. Now, until Friday May 26, 4 am"

* [Great!]Getting that bonus would really help

->sf_or_sacramento

=== sf_or_sacramento ===
{
- home=="sf":->day_1_sf

- home=="sac":->day_1_sacramento
}
=== day_1_sacramento ===
# button
Fares in Sacramento are about a third less than in a big city like San Francisco. Do you drive 2 hours to San Francisco to work there instead?"

* ["Try your luck in SF"] "You decide to try your luck in San Francisco"
~current_city="sf"
->go_to_sf
* ["Stay in Sacramento"]

You stay in Sacramento. You'll earn less but at least you're close to home.
->sac_morning

= go_to_sf
# link
# moment: firstfare
You turn your app on as you drive, and you score a ride as you approach San Francisco that takes you all the way into the city.

* [Can't believe I just made $56!]
~ alter(day_ride_count, 1)
~ alter(day_fares_earned, 56)
~ alter(day_hours_driven, 2)
->day_1_sf.sf_afternoon

= sac_morning
# link
# moment: firstfare
Pretty soon, you earn your first fare: a $6 ride that took just 15 minutes to complete. 
* ["This is pretty easy!"] 
~ alter(day_fares_earned, 1)
~ alter(day_fares_earned, 6)
~time_passes(3,0,1)
{phone_mount==false:
->no_phone_mount->stay_or_go_2
}
= stay_or_go
# button
At this rate, you're unlikely to meet your financial target.
* [Keep driving in Sacramento] ->sac_lunch
* [Go to San Francisco instead] There's still time to salvage today. You cross the Oakland Bay bridge and arrive in San Francisco just after lunch. 
~current_city="sf"
->day_1_sf.sf_afternoon

=sac_lunch
# link
You like driving in a familiar town. You grab a quick lunch at your favourite burrito place."
* [That was a nice burrito] ->sac_afternoon

=sac_afternoon

~time_passes(4,0,1)
->stay_or_go_2

=stay_or_go_2
# button
It's 5pm, and you've only earned ${day_fares_earned}.
* [Call it a day] You head home, in time for dinner.-> day_1_end
* [Keep going] Things should pick up during rush hour and dinner time. ->sac_evening
* [Go to San Francisco] By this point, it doesn't really make sense to make the two-hour trip to San Francisco. You decide to stay in Sacramento, regretting that you didn't go earlier.->sac_evening

=sac_evening
# link
You start getting more ride requests, and drive until the evening crowd thins out.
~time_passes(3,1,1)

You call it a day after the evening crowd thins out.

*[End day 1]
->day_1_end

=== day_1_sf ===
// sf_or_sacramento diverts to here
# link
# moment: firstfare
You start driving, and pretty soon get your first passenger. The short trip to the Mission took you 15 minutes, and you earned $10

* [Nice!]You feel great about earning your first fare. This is easy money! 
~ alter(day_ride_count, 1)
~ alter(day_fares_earned, 10)
-> sf_morning
= sf_morning
# link
You spend a productive morning working, with little downtime in between rides.

~time_passes(4,0,1)

* [That's great!]You stop for lunch when you spot a Señor Sisig food truck. Their burritos are amazing as always.->sf_afternoon

=sf_afternoon
{home=="sac":It's pretty stressful driving in big city like San Francisco, but you think you've made the right decision.}
{phone_mount==false:
->no_phone_mount->sf_evening
}
~time_passes(4,0,1)
->sf_evening

=sf_evening
{no_phone_mount: 
# link
You get back online just in time for the busy evening period.
*[Phew!]
~time_passes(2,1,1)
You call it a day.
# link
    **[Not a bad day, overall]
    ->day_1_end

- else: 
# button
You've now been driving for {day_hours_driven} hours, and are starting to get tired.
* {home=="sac"}[Head home to Sacramento]You get home by 10pm, and get a good night's rest.

->day_1_end
* [Keep driving]The evening is the busiest period, but soon you're too tired to continue
~time_passes(2,1,1)
->sac_night
* {gym_member}[Freshen up at the gym]You feel much better after a quick shower at the gym. You do good business during the busy evening period. 
~time_passes(3,1,1)
->sac_night

* [Go home]You decide to call it a day.
->day_1_end
}
=sac_night
# link
{home=="sf":->day_1_end}
{gym_member: 
You drive 2 hours back home to Sacramento. It's pretty late by the time you get back.

- else: You're dead tired by the time you head back. Fortunately you manage to stay awake and arrive home without getting into an accident.
}

* [End day 1]->day_1_end
=== day_1_end ===
# link
It's the end of the first day.
~day_end()
*[Start day 2]->day_2_start

=== day_2_start ===
It's Tuesday. {home=="sac":You wake up a bit earlier and drive out to San Francisco.}

{home=="sac":
~alter(day_hours_driven,2)
}
->gas_receipt

===gas_receipt===
# button
You stop to fill up your tank. Do you get a receipt? 
*[Yes]You keep it in a folder for your expenses.
~kept_receipt=true
*[Nah]You don’t have time to keep track of stuff like that.
~kept_receipt=false
- ->day_2_midpoint

===day_2_midpoint===
# link
~time_passes(3,0,1)
~ UberXL()
* [ok] 
->burgers

===burgers===
# button
~temp dirty=false

You get a trip request from a burger joint, and when you arrive the passengers have two juicy In N Out burgers that they are about to eat in the car.

* ["The food can’t come in the car"]"Aww, come on," they say. "We'll be careful."
    ** "No means no[."]," you say, as you cancel their ride.
    But soon, you find that your driver rating has fallen.
    
    ~ alter(rating,-0.05) 
    ->low_rating->day_2_evening
    
    ** "Oh, alright[."]," you say. They get in the car. <>
    
* ["Nice! I love burgers too."]They get in the car and you start driving. 

- From the rear-view mirror, you see one of them take a bite, and some ketchup drips onto the seat."
    ** [Say something] After your admonishment, they wipe the seat, but there's still a stain. They look unhappy at being called out.
    ~ dirty=true 
    ~ alter(rating,-0.05)
    ** [Keep quiet] They blithely continue eating. You can't stop thinking about the stain.
    ~ dirty=true
    -- "They finish their burgers. The rest of the trip passes without incident."
    ->dirty_car 
    
===dirty_car===
# button
What do you do about your dirty backseat?
* [Stop to clean it] You pull over and clean the back seat. As you start cleaning, a ride request comes in.
    ** [Take the request]You abandon the cleaning and go pick up the passenger. He's not impressed with the dirty backseat.
    ~ alter(rating,-0.1) 
    ~ alter(ride_count_total,1)
    ~ alter(fares_earned_total,8)
    ** [Decline the ride] You finish cleaning up.
* [Ignore it] You put it out of your mind. Your next passenger is not too impressed with the dirty backseat.
    ~ alter(rating,-0.1) 
- {rating > 4.8 :
    -> day_2_evening
  - else :
    ->low_rating->day_2_evening
    }

===day_2_evening===
# button
~time_passes(4,0,1)
You've been driving for {day_hours_driven} hours. Do you want to push on for the evening peak period?

* [Yes]

~time_passes(3,1,1)

->day_2_end

* [No]You deserve a break. You meet up with some friends for dinner instead. 

->day_2_end
=== day_2_end ===
# link
~day_end()

* [Start Day 3]

-> day_3_start

=== day_3_start ===
{home=="sac":
You head over to San Francisco. <> 
~alter(day_hours_driven,2)
}
->pebble_start

===pebble_start===
# button
As you drive along the highway, a pebble hits your windshield and leaves a chip.

* [Repair it immediately]
->repair

* [Ignore it] 
->ignore

=repair
# link
You find a nearby auto shop. They take an hour to fix your windscreen, and charge you $30. 
* [Continue driving]->day_3_morning

=ignore
# link
It's nothing to be concerned about.
~ windshield_cracked=true
* [Continue driving]->day_3_morning

===day_3_morning===

~time_passes(4,0,1)
{unlimited_data==false:
->data_plan
- else:
->nice_passenger
}


===nice_passenger===
# link
You pick up a friendly passenger and have a pleasant chat during the ride. After you drop her off, you get a notification.

* [Check your phone]You got a five-star review! 
# link
"Friendly and professional. Would ride again" 
~ alter(rating,0.03)

** [Nice!] Your rating has gone up to {rating}
~time_passes(2,0,1)
->quest_finish->
->day_3_quest_near_finish->
->day_3_end
===day_3_quest_near_finish===
# button
{quest_rides<5 && quest_rides > 0:
MESSAGE FROM UBER: Just {quest_rides} more rides until you get ${quest_bonus} bonus!
* [Keep driving]As you pull up for the next pick-up, you find, annoyingly, that it's for a long trip to the airport.
    **[Ask the passenger if you could decline]The passenger says she's in a hurry.
        ***[Cancel on her]She shouts as you as you pull away. Fortunately, the rest of the rides were short ones. You finish after two hours.
        ~ alter(day_ride_count, quest_rides)
        ~ alter(day_fares_earned, quest_rides*6)
        ~ alter(day_hours_driven, 2)
        ~ quest_rides=0
        ->quest_finish->day_3_end
        ***[Go to the airport]You take her to the airport. You didn't want to get in the queue for a ride back, so you drive back to town by yourself. You decide to call it a day and finish the quest tomorrow instead. 
        ~ alter(day_ride_count, 1)
        ~ alter(day_fares_earned, 30)
        ~ alter(day_hours_driven, 1)
        ~ alter(quest_rides, -1)
        ->day_3_end
    **[Just go to the airport]ou take her to the airport. You didn't want to get in the queue for a ride back, so you drive back to town by yourself. You decide to call it a day and finish the quest tomorrow instead.
        ~ alter(day_ride_count, 1)
        ~ alter(day_fares_earned, 30)
        ~ alter(day_hours_driven, 1)
        ~ alter(quest_rides, -1)
        ->day_3_end
* [Call it a day]You still have the whole day tomorrow to finish it. You decide to go home for today.
->day_3_end
}
->->
===day_3_end===
# link
->quest_finish->
* [Call it a day]
~day_end()
# link
** ["Start day 4"] -> day_4_start


===day_4_start===
{ 
- quest_completion==true:
->day_4_quest_completed
- quest_completion==false && quest_rides < 15:
->day_4_quest_easy
- quest_completion==false && quest_rides > 35:
->day_4_quest_impossible
- else:
->day_4_quest_hard
}

=day_4_quest_completed
# button
Since you've already finished the quest and the next one won't start until Friday, do you want to take the day off?
* [Take day off]
You spend the day with your family. Your son is glad you made time for him, and you get some much needed rest. 
~helped_homework=true
->day_5_start
* [Keep working]
You need every penny you can earn.

->day_4_morning

=day_4_quest_easy
It should be pretty easy to complete the last few rides for the quest bonus.

->day_4_morning

=day_4_quest_hard
Today is the last day to complete enough rides for the bonus.

->day_4_morning

=day_4_quest_impossible
# button
There's no way you'll complete enough rides to finish the quest. Do you want to take the day off and start afresh when you get a new quest on Friday?
* [Take day off]
You spend the day with your family. Your son is glad you made time for him, and you get some much needed rest.
~helped_homework=true
->day_5_start
* [Keep working]
If you can't finish the quest, then it's even more important to earn more fares.->day_4_morning

===day_4_morning===
# button
As you head out, you remember that you promised your son to be home by 8pm to help him with his homework.
{home=="sac":
* ["Drive in Sacramento today"] You decide to stay.
~ current_city = "sac"
-> day_4_sacramento

* ["Go to San Francisco"]"You decide to go to San Francisco, since you'll get more rides there."
~ current_city = "sf"
    {quest_rides>2:
    ->napa
    - else:
    ->day_4_sf
    }
}
{home=="sf":
* [I'll be back in time!]
~ current_city = "sf"
->day_4_sf
}

===day_4_sacramento===
# link
{
- quest_completion==true:
You take it easy today.
~time_passes(9,0,1)
* [Time to go home]You call it a day just after 7pm, and make it back home in time to spend the evening with your son, as you promised.
~helped_homework=true
    ->day_4_end
- quest_completion==false && quest_rides < 15:
It shouldn't be too hard to complete {quest_rides} rides, even in Sacramento.

It takes you {quest_rides>10:most of the day}{quest_rides<10 && quest_rides>3: a few hours}{quest_rides<3: less than two hours} to get enough rides.

You finished the quest! You get the ${quest_bonus} bonus.
~ alter(day_ride_count, quest_rides)
~ alter(day_fares_earned, quest_rides*6)
{
- quest_rides>10: 
~alter(day_hours_driven,9)
- quest_rides<10 && quest_rides>3:
~alter(day_hours_driven,4)
- quest_rides<3:
~alter(day_hours_driven,2)
}
~ quest_rides=0
~quest_completion=true
->day_4_end

- quest_completion==false && quest_rides > 35:
You're unlikely to finish the quest by this point, so you just go where the rides take you. 

~time_passes(9,0,1)
* [Time to go home]You call it a day just after 7pm, and make it back home in time to spend the evening with your son, as you promised.
~helped_homework=true
    ->day_4_end

- else:
It might be a stretch to do {quest_rides} rides, especially in Sacramento, but you give it a shot.
~ temp remaining=quest_rides-3
You drive for 9 hours. During this time, you completed {remaining} rides, and earned ${remaining*6} in fares. Your driver rating is {rating} 
~ alter(day_ride_count, remaining)
~ alter(day_fares_earned, remaining*6)
~ alter(day_hours_driven, 9)
~ quest_rides=3

* [MESSAGE FROM UBER] Just three more trips until you complete your quest!
But it's already 7pm and you promised to be home by 8.
->quest_nudge

}

===quest_nudge===
# button
* [Keep driving] It takes you two hours to finish the last {quest_rides} rides, but you finish the quest. You get ${quest_bonus}!
{home=="sac":You drive as quickly as you can to get back to Sacramento, but y}{home=="sf":Y}our son is already asleep by the time you get back. He didn't finish his homework.
~ alter(day_ride_count, 3)
~ alter(day_fares_earned, 19)
~ alter(day_hours_driven, 2)
~quest_completion=true
~quest_rides=0
->day_4_end

* [Go home]You go home and help your son with his homework before tucking him into bed. He's happy you kept your promise.
~helped_homework=true

It's 10:30pm and you're tired after a long day, but the quest doesn't expire until 4am.
** [Go back out]You get back in your car and turn the app back on. It takes you two hours to finish the last three rides, but you finish the quest. You get ${quest_bonus}!
You are completely exhausted.
~ alter(day_fares_earned, 19)
~ alter(day_hours_driven, 2)
~quest_completion=true
~quest_rides=0
->day_4_end
** [Go to sleep] You're too exhausted.
->day_4_end

===napa===
# link
"Soon after you arrive, you pick up some tourists who want to go to Napa and drive across the Golden Gate Bridge"
* ["This is going to take a while..."]The long trip turns out to be a mixed blessing. You're not much closer to finishing your quest, but it nets you $165 in fares, and $100 in tips!
~ alter(fares_earned,265)
~ alter(ride_count,1)
~ alter(quest_rides, -1)

    **["Drive into San Francisco"]
->day_4_sf

===day_4_sf===
# button
~ temp remaining=quest_rides-3
By now, you've become used to the rhythm of the day and how this works.

{ 
- quest_completion==true:
You go where the rides take you. It's a pretty normal day.

    {home=="sac":
    ~time_passes(5,0,1)
    ~UberXL()
    
    It's 5:30pm. Do you turn off the app and start heading back home to Sacramento? 
    * [Yes]You get back in time, as promised, and spend a pleasant evening with your son.
    ~helped_homework=true
    ->day_4_end
    * [No]You keep driving.
    ~time_passes(2,1,1)
    It's late by the time you get back. Your son is already asleep, his homework unfinished.
    ->day_4_end
    }

    {home=="sf":
    ~time_passes(8,0,1)
    ~UberXL()
    *[Time to go home]
    You call it a day just after 7pm, and make it back home in time to spend the evening with your son, as you promised.
    ~helped_homework=true
    ->day_4_end
    }
    
- quest_completion==false && quest_rides < 15:

{home=="sac":
It should be pretty easy to finish the quest. 
{
- quest_rides>10:
    You drive for 6 hours. During this time, you completed {remaining} rides, and earned ${remaining*6} in fares. Your driver rating is {rating} 
    ~ alter(day_ride_count, remaining)
    ~ alter(day_fares_earned, remaining*6)
    ~ alter(day_hours_driven, 9)
    ~ quest_rides=3
    
    * [MESSAGE FROM UBER] Just three more trips until you complete your quest!
    But it's already 6pm and you promised to be home in Sacramento by 8.
    ->quest_nudge
    
- quest_rides<=10:
    It takes you {quest_rides<10 && quest_rides>3: a few hours}{quest_rides<3: less than two hours} to get enough rides.
    You finished the quest! You get the ${quest_bonus} bonus.
    ~ alter(day_ride_count, quest_rides)
    ~ alter(day_fares_earned, quest_rides*7)
    {
    - quest_rides>10: 
    ~alter(day_hours_driven,8)
    - quest_rides<10 && quest_rides>3:
    ~alter(day_hours_driven,4)
    - quest_rides<3:
    ~alter(day_hours_driven,1)
    }
    ~ quest_rides=0
    ~quest_completion=true
    *[Time to go home]You get back in time, as promised, and spend a pleasant evening with your son.
    ~helped_homework=true
    ->day_4_end
    }

}

{home=="sf":
It takes you {quest_rides>10:most of the day}{quest_rides<10 && quest_rides>3: a few hours}{quest_rides<3: just an hour} to get enough rides, but you do it.

You finished the quest! You get the ${quest_bonus} bonus.
~ alter(day_ride_count, quest_rides)
~ alter(day_fares_earned, quest_rides*7)
{
- quest_rides>10: 
~alter(day_hours_driven,8)
- quest_rides<10 && quest_rides>3:
~alter(day_hours_driven,4)
- quest_rides<3:
~alter(day_hours_driven,1)
}
~ quest_rides=0
~quest_completion=true
*[Time to go home]You get back in time, as promised, and spend a pleasant evening with your son.
~helped_homework=true
->day_4_end
}

- quest_completion==false && quest_rides > 35:
You go where the rides take you. It's a pretty normal day.

    {home=="sac":
    ~time_passes(5,0,1)
    ~UberXL()
    
    It's 5:30pm. Do you turn off the app and start heading back home to Sacramento? 
    * [Yes]You get back in time, as promised, and spend a pleasant evening with your son.
    ~helped_homework=true
    ->day_4_end
    * [No]You keep driving.
    ~time_passes(2,1,1)
    It's late by the time you get back. Your son is already asleep, his homework unfinished.
    ->day_4_end
    }

    {home=="sf":
    ~time_passes(7,0,1)
    ~UberXL()
    You call it a day just after 7pm, and make it back home in time to spend the evening with your son, as you promised.
    ~helped_homework=true
    ->day_4_end
    }

- else:
It might be a stretch to do {quest_rides} rides but you give it a shot.

    {home=="sac":
    ~time_passes(5,0,1)
    
        {
        - quest_rides<4:
        MESSAGE FROM UBER: Just {quest_rides} more trips until you complete your quest!
        But it's already 6pm and you promised to be home in Sacramento by 8.
        
        ->quest_nudge
        
        - quest_rides>=4 && quest_rides<15:
        It's 6pm and you promised to be home in Sacramento by 8.
        * [Go home] You go home and help your son with his homework before tucking him into bed. He's happy you kept your promise.
        ~helped_homework=true
        ->day_4_end
        
        * [Keep driving] It takes you another 3 hours before you get enough rides, but you do it. 
        You finished the quest! You get the ${quest_bonus} bonus.
        ~ alter(day_ride_count, quest_rides)
        ~ alter(day_fares_earned, quest_rides*7)
        ~ alter(day_hours_driven, 3)
        ~ quest_rides=0
        ~ quest_completion=true
        
        It takes you another two hours to get home. By the time you get back. Your son is already asleep, his homework unfinished.
        ->day_4_end
        
        - else:
        # link
        It's 6pm and you promised to be home in Sacramento by 8. It doesn't look like you'll finish the quest after all.
        * [Go home] You go home and help your son with his homework before tucking him into bed. He's happy you kept your promise.
        ~helped_homework=true
        ->day_4_end
        }
    
    }

    {home=="sf":

    You drive for 9 hours. During this time, you completed {remaining} rides, and earned ${remaining*6} in fares. Your driver rating is {rating} 
    ~ alter(day_ride_count, remaining)
    ~ alter(day_fares_earned, remaining*6)
    ~ alter(day_hours_driven, 9)
    ~ quest_rides=3
    # link    
    * [MESSAGE FROM UBER] Just three more trips until you complete your quest!
    But it's already 7pm and you promised to be home by 8.
    ->quest_nudge
    }
}

===day_4_end===
# link
It's the end of day 4.
{home=="sac":
~alter(hours_driven_total,2)
}
Today, you drove for {day_hours_driven} hours, completed {day_ride_count} rides and earned ${day_fares_earned} in fares. Your driver rating is {rating}.

{ quest_completion==true:
 You finished the quest and netted a ${quest_bonus} bonus.
- else:
You didn't finish the quest in time, and lose out on the ${quest_bonus} bonus.
}

~ alter(ride_count_total, day_ride_count)
~ alter(fares_earned_total, day_fares_earned)
~ alter(hours_driven_total, day_hours_driven)
~ day_ride_count=0
~ day_fares_earned=0
~ day_hours_driven=0

*[Start day 5]->day_5_start


===day_5_start===
# link
~current_city="sf"
It's Friday. You get a new quest for the weekend.
{quest_completion==true:
~weekday_quest_completion=true
}
~quest_rides=65
~quest_bonus=150
~weekend_quest_bonus=quest_bonus

* MESSAGE FROM UBER[]: "Drive {quest_rides} trips, make ${quest_bonus} extra. Now, until Monday May 29, 4 am"

{quest_completion == false:
    "You are determined to finish this quest after missing out on the last one"
    - else:
    "You are determined to finish this quest as well. Bonus payments can really boost your earnings."
}
~quest_completion=false
->day_5_late_start

===day_5_late_start===
# button
Friday and Saturday nights are some of the busiest times for rides, but the peak period doesn't start until 10pm.

* [Start at your normal time] ->day_5_daytime

* [Start driving in the evening] You take a rest and try to nap a bit during the day. {home=="sac":You leave for San Franciso after dinner at home.} -> day_5_evening

===day_5_daytime===
# button
You decide that it's not worth it to disrupt your normal schedule.

You head into San Francisco at your usual hour.

~time_passes(6,0,1)

* [Call it a day] You're getting tired and decide to go home
-> day_5_end

* [Keep driving] You decide to try to catch the evening crowd.
-> day_5_evening

===day_5_evening===
# link
~time_passes(2,1,1)

It's 8pm, and you just dropped off a passenger in the Financial District in the northeast of San Francisco. 

* MESSAGE FROM UBER[]: Surge pricing in the Sunset district. Earn 3x fares!
->surge
=surge
# button
The 3x fare is attractive, but it might be gone by the time you get to the Sunset district, which is 30 minutes away. 

* [Chase the surge]Tripling your earning is just too tempting. You start driving over to the surge zone, but the roads are busy and the traffic lights are not on your side tonight. 

You are three blocks away when the surge ends. You are annoyed at having wasted half an hour.

~time_passes(2,1,1)

* [Don't chase the surge]You ignore the message. You are doing good enough business without it.

~time_passes(3,1,1)
- ->home_or_not
=home_or_not
# button
When you can finally take time for a break, it's already past midnight.

* [Go home] 
{ 
- day_5_daytime && home=="sac": 
You're very tired on the drive home. On the way back you've had to pull over and take a nap before you could continue. You don't get back until nearly 3am. ->day_5_end
- day_5_daytime && home=="sf":
You're too tired. You call it a night, and drive back home. ->day_5_end
- else:
You call it a night, and drive back home. ->day_5_end
}

* {day_5_daytime && home=="sac"} [Sleep in your car] You're too tired to drive another two hours to go back home. You find a quiet spot to park your car in and spend an uncomfortable night sleeping in your car.
    **[zzz] It's not very comfortable, but you eventually fall asleep.
    ~day_end()
-> day_6_slept_in_car

* [Keep driving] ->vomit

===vomit===
# button
You arrive at a pick-up and see a passenger vomiting on the side of the road.

* [Cancel the ride and drive away] You decide it's not worth it. 
    ~alter (rating,-0.1)
    ** [Keep driving]
    ->day_5_late_night
    ** [Call it a night] You decide to call it a night.
    ->go_home

* [Let the passenger in]You drive to the destination. As he is getting out, the passenger vomits out the window. Ugh!
    ** [Clean up the mess and notify Uber] 
{ cleaning_supplies==true: 
Luckily, you have cleaning supplies in your trunk. You pull over and spend some time cleaning up.

    Uber gives you $30 in cleaning fees.
//TODO: figure out how to record this money
    ->day_5_late_night
- else: You don't have any cleaning supplies, and spend some time trying to find a gas station with a convenince store. You eventually clean it all up.
    Uber gives you $30 in cleaning fees.
//TODO: figure out how to record this money
    ->day_5_late_night
}
    
=go_home
# button
{home=="sf":
->day_5_end
}
{home=="sac":
* [Go home] You're very tired on the drive home and had to pull over for a nap before you could continue. You don't get back until nearly 3am. 
-> day_5_end

* [Sleep in your car] You're too tired to drive another two hours to go back home. You find a quiet spot to park your car in and spend an uncomfortable night sleeping in your car.
    ~day_end()
    **[zzz]It's not very comfortable, but you eventually fall asleep.
-> day_6_slept_in_car
}

===day_5_late_night===
# button
The late hours are certainly lucrative.

~time_passes(2,1,1.3) 

{day_5_daytime : You are so tired that you can do nothing more than park your car by the side of the road and sleep -> day_6_slept_in_car }

* [Go home] 
{ home=="sf": ->day_5_end} 
You're not used to staying up so late and are very tired on the drive home. You don't get back until nearly 4am. 
-> day_5_end

* {home=="sac"}[Sleep in your car] You're too tired to drive another two hours to go back home. You find a quiet spot to park your car in and spend an uncomfortable night sleeping in your car.
    **[zzz] It's not very comfortable, but you eventually fall asleep.
    ~day_end()
    -> day_6_slept_in_car

* [Keep driving] You're really tired by this point but decide to keep going.
In your next ride, the passenger complains that you seem sleepy behind the wheel. Uber immediately deactivates you, without telling you the reason.

# button

**[Contact Uber] You call Uber to contest your deactivation. You spend an hour going back and forth with them on the phone, but all you get is a promise that they'll look into it.
# link
    ***[Go home]
    You drive home and collapse into bed.
    ~day_end()
->day_6_deactivated

**[Go home]
You drive home and collapse into bed.
    ~day_end()
->day_6_deactivated


===day_5_end===

~day_end()
->day_6_start

===day_6_deactivated===
# link
It's Saturday. You wake up and check your Uber app to find that you're still deactivated.You decide to make the most of your enforced day off.

* [Spend time with your son]

You spend a relaxing afternoon in the park with your son. It sure feels good to not have to sit in a car all day. 

{helped_homework==false: Your son was still mad at you for letting him down on Thursday, but brightened up significantly by the end of the day.}
**[You feel refreshed]
->day_7_start


=== day_6_slept_in_car ===
You wake up, briefly forgetting that you're in your car in San Francisco.

->day_6_start

=== day_6_start===
# button
It's Saturday. Do you take the day off? It is the weekend, after all.

* [Take day off] You decide to take the day off. You spend a relaxing afternoon in the park with your son. It sure feels good to not have to sit in a car all day. 

{helped_homework==false: Your son was still mad at you for letting him down on Thursday, but brightened up significantly by the end of the day.}
# link
**[You feel refreshed]
->day_7_start

* [Go to work] You're not earning when you're not working.
->day_6_work

=== day_6_work ===
# link
MESSAGE FROM UBER: 
The San Francisco Giants are playing at AT&T park today. Earn a boosted 1.5x fare for trips from there, from 5pm-6:30pm today 

*[Got it]
~ time_passes(3,0,1)

->door_dent

=== door_dent ===
# button
As you finish a ride, the passenger opens the door to get out and hits a lamp post, denting your car door. He is apologetic, but in a rush, and tells you to resolve it with Uber.

*[Report the incident to Uber] Uber promises to investigate, but in the meantime your account is suspended. There's nothing else you can do today. -> day_6_end
*[Don't report it] You decide to get it repaired yourself. It takes the mechanics two hours to fix it, and they charge you $100. 
//TODO money
->day_6_afternoon

=== day_6_afternoon ===
# link
~ time_passes(3,0,1)
* [Head over to the baseball stadium]
You make your way to the baseball stadium before the game ends. Sure enough, lots of people are requesting rides there. You get lucky with a relatively long ride to Outer Richmond, and earn $30
    ~ alter(day_ride_count, 1)
    ~ alter(day_fares_earned, 30)
** [Great!]
->day_6_evening


=== day_6_evening ===
# link
It sure is busy this Saturday evening.
~time_passes(3,1,1)

*[It's been a pretty good day] You call it a day
-> day_6_end

=== day_6_end ===
# link
~ day_end()

* [Start day 7]
->day_7_start

=== track_mileage===
# button
It's been a long week. You idly wonder just how far you've driven.

* [Good thing you've been keeping track] {home=="sf": You check your notes: 1567.43 miles. That's quite a lot.}{home=="sac":You check your notes: 2469.35 miles. That's quite a lot.}
~miles_tracked=true
->->
* [(shrug emoji)]It doesn't really matter.
~miles_tracked=false
->->

===day_7_start===
# link
->track_mileage->

It's Sunday! You still need {quest_rides} more rides to get the weekend bonus.
*[Let's do this!]

~time_passes(3,0,1)
->no_drop_zone
=== no_drop_zone===
# button
A passenger insists you drop her off at the entrance to the Caltrain station, which is a no-stop zone.

* [Agree to do so]
~ temp ticket = RANDOM(1,3)
{ticket>1: 
You drop her off quickly. Luckily, there weren't any cops around.
- else: As you drop her off, you see a police car pull up behind you. You get a traffic ticket (-$260)
~ticketed=true
}

->day_7_afternoon

* [Refuse] You stop nearby and explain why you cannot drop her off at the entrance. She slams the door as she gets out.
~alter(rating, -0.2)
->day_7_afternoon

===day_7_afternoon===
# button
~time_passes(3,0,1)
->quest_finish->
{windshield_cracked==true:
->pebble_crack->
}
{quest_completion==true:
*[Call it a day]
->day_7_end
- else:
*[Keep driving]
->day_7_evening
}

===pebble_crack===
# link
You are driving when you hear a splintering sound. The chip in your windshield is turning into a crack that is spreading across the whole windshield. You have no choice but to get it repaired
* [The mechanic charges you $250]You pay the money, regretting that you didn't get it fixed earlier.
->->

===day_7_evening===
# button
~time_passes(3,1,1)
->quest_finish->

{
-quest_completion==true:
*[Call it a day]
->day_7_end
-quest_rides < 5 && quest_completion==false:
MESSAGE FROM UBER: Just {quest_rides} more trips until you complete your quest!
*[Finish the quest]It doesn't take you long to finish the last {quest_rides} rides. 
Congrats! You completed the quest and got an extra ${quest_bonus}.
~quest_completion=true
->day_7_end

- quest_rides>=5 && quest_rides<10:
You only have {quest_rides} left to do. You could try to finish it by cancelling when you get a long ride. Your rating will suffer though.

*[Hustle to finish it]It takes you a few hours, but your strategy works, and you complete the last ride needed just before midnight.

~ alter(day_ride_count, quest_rides)
~ alter(day_fares_earned, quest_rides*5)
~ alter(day_hours_driven, 4)

{ rating > 4.8: 
Congrats! You completed the quest and got an extra ${quest_bonus}.
~quest_completion=true
->day_7_end
- else: For some reason, you didn't get the reward.

    ** [Huh?] You re-read the instruction text in the app, and realise, too late, that you didn't the get reward because your rating has dropped too low. 
        ***[That feels like a little bit of a con]You feel cheated but there's not much more to be done. You're shattered after driving for {day_hours_driven} hours, and can only go home to sleep it off.
        ->day_7_end
}

*[Just call it a day]It's not worth it. you decide to go home instead.

->day_7_end

- quest_rides>=10:
You still need too many more rides to complete the quest. There's not much you can do about it, so you head home.
->day_7_end
}

===day_7_end===
# link
~day_end()
{quest_completion==true:
~weekend_quest_completion=true
}
It's the end of the week. Were you savvy enough to survive as a full-time Uber driver?
*[See how you did]
->results_revenue


===no_phone_mount===
Without a phone mount, you're left fiddling with your phone on your lap. Soon, a passenger notices and complains to Uber about your dangerous driving.

You are deactivated for 4 hours. You use that time to go buy a phone mount for $20.
~phone_mount=true 
~alter(accessories_cost,20)
->->

===data_plan===
# button
You get a message from your phone provider: You've reached your data limit this month. 
*[Upgrade to an unlimited data plan ($20/week)]You decide to upgrade after all.
~unlimited_data=true
~alter(accessories_cost,20)
*[Let it go to overage charges($30/week)]For some reason, you decide to pay the overage charges instead.
~alter(accessories_cost,30)
- ->nice_passenger


===results_revenue===
# link
~ revenue_total=fares_earned_total
This week, you drove for {hours_driven_total} hours, completed {ride_count_total} rides, and had a driver rating of {rating}

You earned ${fares_earned_total} in fares and tips. {car=="Minivan": Of this, ${XL_total} were extra fares from UberXL rides.} 
{
- weekend_quest_completion && weekday_quest_completion:
You finished both quests, earning ${weekend_quest_bonus+weekday_quest_bonus}.
~alter(revenue_total, weekend_quest_bonus)
~alter(revenue_total, weekday_quest_bonus)
- weekend_quest_completion && !weekday_quest_completion:
You finished the weekend quest, earning ${weekend_quest_bonus}.
~alter(revenue_total, weekend_quest_bonus)
- !weekend_quest_completion && weekday_quest_completion:
You finished the weekday quest, earning ${weekday_quest_bonus}.
~alter(revenue_total, weekday_quest_bonus)
- else:
You didn't finish either quests.
}

{revenue_total>=1000: 
You made ${revenue_total} in total, exceeding your $1000 target.

- else: You made ${revenue_total} in total, and were ${1000-revenue_total} off from your target of making $1000 in a week.
}

* [How much did I really make?]
->results_costs


===results_costs===
# link
~ temp gas=0
~ temp days=0
~ temp tax=revenue_total/10
~ temp income=revenue_total

{saturday_off:
~ days=6
- else:
~ days=7
}
{
- car=="Minivan" && home=="sf":
~gas=days*25

- car=="Minivan" && home=="sac":
~gas=days*30

- car=="Prius" && home=="sf":
~gas=days*15

- car=="Prius" && home=="sac":
~gas=days*20
}
To get a true picture of what you earned as an Uber driver, you also have to take into account your costs.

Renting your {car} cost ${car_cost}.
~alter(cost_total,car_cost)

You spent ${gas} on gas. {car=="Prius":You saved a lot on gas costs by choosing the Prius over the minivan.} 
~alter(cost_total,gas)
You spent ${accessories_cost} buying other gear and services.
~alter(cost_total,accessories_cost)
You also have to file your taxes. {miles_tracked==true: Fortunately, since you tracked your mileage {kept_receipt==true:and kept your gas receipts}, you were able to deduct enough expenses so you don't have to pay any tax.}
{miles_tracked==false: 
Unfortunately, since you weren't diligent about tracking your miles {!kept_receipt:, or keeping your gas receipts}, your tax bill comes to ${tax}. 
~alter(cost_total,tax)
}
~alter(income, -cost_total)
After taking into account your costs, you earned ${income} this week.

{
- income>=1000:
Congratulations! You met your target of earning $1000 this week. You did significantly better as an Uber driver than the average American weekly wage of $855 a week.
- income<1000 && income>855:
You didn't meet your target of earning $1000 this week, but you still did better than the average American weekly wage of $855 a week.
- income<=855 && income>0:
You didn't meet your target of earning $1000 this week, and did worse than the average American weekly wage of $855 a week.
- else:
Not only did you not meet your target of earning $1000 this week, you actually lost money as an Uber driver.
}

->END


/* 
===airport_incident===
"You are driving a passenger to the airport when you miss the freeway exit. The passenger gets very angry, saying: "Do I need to drive for you?"

* "Sorry[!"], you say. But you stew over the remark. Especially when you see they've given you a bad rating"

*/
