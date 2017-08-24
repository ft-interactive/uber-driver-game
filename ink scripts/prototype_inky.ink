INCLUDE functions
INCLUDE check_quest
INCLUDE ratings
INCLUDE results

//Set-up variables 
VAR car="none"
VAR home="none"
VAR credit_rating="none"
VAR car_cost=0
VAR timestamp=1502092800
// start time: Monday, August 7, 2017 8:00:00 AM GMT

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
VAR rating=490
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

/* NOTE: for tags,
button = no choice
link = choice

*/

->welcome
=== welcome ===
# welcome
Welcome! You're a full-time Uber driver trying to make ends meet.

# button 
You have one week to try to make $1000. Can you do it?

* [Yep!] 
->choose_difficulty

=== choose_difficulty===
# link 
# choose_difficulty
Choose your difficulty level:

* [Easy Mode]
~ home="sf"
~ credit_rating="good"
In Easy mode, you live in San Francisco and have good bank credit. 

* [Hard Mode]
~ home="sac"
~ credit_rating="bad"
In Hard mode, you live in Sacramento and have bad bank credit.

- ~current_city=home
->get_started

=get_started
# link
# get_started
Remember, you have 7 days to make $1000.

* [Let's go]
->day_1_start

* [Skip Chris]
~add_time(0,38)
->car_choice

=== day_1_start ===

# day_1_start
~ add_time(0,10)
You start bright and early on a Monday morning.

Pretty soon, you get your first ride request, from someone called Chris.
# button
* [Go pick him up] ->day_1_locate_passenger

===day_1_locate_passenger===
# link
# day_1_locate_passenger
You arrive, but don't see anyone waiting for a ride. What do you do?
~add_time(0, 5)
* [Call Chris]->call_chris
* [Wait] You wait in your car. ->chris_arrives

=call_chris
# link
# day_1_locate_passenger.call_chris
He answers the phone. "I'll be right there! Just coming out now," he says.
~ add_time(0,3)
* "Hurry up, will you?"[]
*"No worries[!"], take your time!"
- He hangs up. You wait. 
->chris_arrives

=chris_arrives
# button
# day_1_locate_passenger.chris_arrives
A few minutes later, a flustered man with a big backpack comes out of a nearby apartment and walk towards your car.

* "Are you Chris[?"]," you ask.
->in_car

=in_car
# link
# day_1_locate_passenger.in_car
"That's me. Sorry about being late," he replies, as he gets in the car.
~ add_time(0, 20)
* [Drive in silence] You start driving. Chris checks his phone.
* [Strike up a conversation]"Going camping?"
"Yeah," Chris replies, brightening up. "Meeting up with a friend, and then we're driving to this amazing place a few hours away. Lemme tell ya..."
- ->driving

=driving
# button
# day_1_locate_passenger.driving

Twenty minutes later, you arrive at his destination.
~ alter(fares_earned_total, 16)
* [Drop him off] 

"Thanks! Sorry again for making you wait," he says as he gets out.

Congratulations! You've just earned your first fare, for $16.
# button
** [That was easy]
->car_choice

=== car_choice ===
# link
# car_choice
~ temp prius_cost=0
~ temp minivan_cost=0
~ temp insurance=0

{ credit_rating == "good":
    ~prius_cost=115
    ~minivan_cost=180
    ~insurance=25
- else:
    ~prius_cost=180
    ~minivan_cost=240
    ~insurance=60    
}

You're going to be spending a lot of time in your car. What model did you lease?
 
+ [Toyota Prius] 
The Prius is fuel efficient, getting up to 50 miles per gallon. {credit_rating == "good":Your good credit rating means it only costs ${prius_cost} per week.}{credit_rating=="bad":Unfortunately, your poor credit means it costs ${prius_cost} per week.}
~ car="Prius"
~ alter(car_cost, prius_cost)
->confirm

+ [Dodge minivan]
The Dodge minivan qualifies for UberXL rides, which earn higher fares.  {credit_rating == "good":Your good credit rating means it only costs ${minivan_cost} per week.}{ credit_rating=="bad":Unfortunately,your poor credit means it costs ${minivan_cost} per week.}
~ car="Minivan"
~ alter(car_cost, minivan_cost)
->confirm

=confirm
# car_choice.confirm
# link
Rent this car?

+ [Yes]->chose_car
+ [Go back]->car_choice

=chose_car
# car_choice.chose_car
# button
You leased the {car}. You also bought insurance for ${insurance} a week.
~ alter(car_cost, insurance)

* [Look around your car]
->buy_accessories
 
===buy_accessories===
# list
# buy_accessories
{!To prepare for life as a professional driver, you also bought...|What else did you buy?}

* [Upgrade to an unlimited data plan ($20/week)]Unlimited data plan: Since you have to be constantly connected to the Uber app, this will save you from paying overage charges. 
    ~unlimited_data=true
    ~alter(accessories_cost,10)
    ->buy_accessories
* Phone mount & charging cords[ ($25)]: A phone mount lets you use your phone with one hand while keeping your eyes on the road. And you don't want to run out of batteries.
    ~phone_mount=true
    ~alter(accessories_cost,25)
    ->buy_accessories
* Cleaning supplies[ ($40)]: In case someone makes a mess in your car 
    ~cleaning_supplies=true
    ~alter(accessories_cost,40)
    ->buy_accessories
* Business license[ ($91)]: You are, after all, technically running a business as an independent contracter. 
    ~biz_licence=true
    ~alter(accessories_cost,91)
    ->buy_accessories
* Gym membership[ ($10/week)]: You could go work out at the gym, but the main perk is having a place to shower and freshen up.
    ~gym_member=true
    ~alter(accessories_cost,10)
    ->buy_accessories
/* * Make a sign asking for tips[ (free)]: You might get more tips, but risk getting lower ratings
    ~tip_sign=true
    ~alter(accessories_cost,0)
    ->buy_accessories
    */
* [{I didn't buy any of this|I'm done shopping}] 
{ 
- unlimited_data && phone_mount && cleaning_supplies && biz_licence && gym_member:You bought everything. It cost ${accessories_cost}.

 - !unlimited_data && !phone_mount && !cleaning_supplies && !biz_licence && !gym_member:You didn't buy anything.
 
 - else: You bought: 
 {unlimited_data:Unlimited data plan}
 {phone_mount:Phone mount}
 {cleaning_supplies:Cleaning supplies}
 {biz_licence:Business licence}
 {gym_member:Gym membership}
// {tip_sign:Tip sign}

It cost ${accessories_cost}.

} 
# button
** [Get back to driving]
-> sf_or_sacramento

===weekday_quest_message===

# weekday_quest_message
~quest_rides=75
~quest_bonus=180
~weekday_quest_bonus=quest_bonus
MESSAGE FROM UBER - "Uber Quest: Drive {quest_rides} trips, make ${quest_bonus} extra. You have until Friday May 26, 4 am"
# button
* [Accept quest]Getting that bonus would really help.

->->

=== sf_or_sacramento ===
# sf_or_sacramento
{
- home=="sf":
You live in San Francisco, Uber's hometown.
->weekday_quest_message->day_1_sf

- home=="sac":->day_1_sacramento
}
=== day_1_sacramento ===
# link
# day_1_sacramento
You live in Sacramento, where fares are a third less than in a bigger city like San Francisco. Do you drive 2 hours to work in SF instead?

* [Try your luck in SF]
->go_to_sf

* [Stay in Sacramento]
->weekday_quest_message-> sac_morning

= go_to_sf
# button
# day_1_sacramento.go_to_sf
~ add_time(2,0)
~ alter(day_ride_count, 1)
~ alter(day_fares_earned, 56)
~ alter(day_hours_driven, 2)
~ alter(ride_count_total, 1)
~ alter(fares_earned_total, 56)
~ alter(hours_driven_total, 2)
~ current_city="sf"
You keep the app on, and score a ride as you approach SF that takes you all the way into the city.

* [Can't believe I just made $56!]
{sac_morning.stay_or_go:
->day_1_sac_afternoon_in_sf
- else: You check your phone as you arrive in SF.
->weekday_quest_message->day_1_sac_afternoon_in_sf
}

===day_1_sac_afternoon_in_sf===
SF is a lot busier than Sacramento. It's pretty stressful driving here.

{
- phone_mount==false: 
~time_passes(3,0,1)
- sac_morning && no_phone_mount:
~time_passes(2,0,1)
- sac_morning.stay_or_go:
~time_passes(3,0,1)
- else:
~time_passes(7,0,1)
}
#button
*[🚗]
{phone_mount==false: ->no_phone_mount->day_1_sac_evening_in_sf_mount}

->day_1_sac_evening_in_sf

===day_1_sac_evening_in_sf===
{sac_morning:
After driving for so long, you're starting to get hungry.

-else: Coming to SF was definitely the right decision. But after driving for so long, you're starting to get hungry.
}

~add_time(0,30)
* [🌯] You go for burritos
* [🍕] You grab a quick slice of pepperoni

- ->day_1_sac_night_in_sf

===day_1_sac_evening_in_sf_mount===
You get back online just in time for the busy evening period. 
~time_passes(2,1,1)
# button
*[🚗]
->day_1_sac_night_in_sf

===day_1_sac_night_in_sf===
It's getting late and you have a two hour drive to get back home.

* [Go home]->go_home
* [Keep driving]->keep_driving
* {gym_member} [Freshen up at the gym]->gym

=go_home
You decide to go home.
~add_time(2,4)
# button
*[🚗]
->day_1_end

=keep_driving
You keep driving.
~time_passes(2,1,1)
# button
*[🚗]
->go_home

=gym
You take a shower at the gym. Feeling refresed, you keep driving.
~time_passes(3,1,1)
# button
*[🚗]
->go_home

===sac_morning===
# day_1_sacramento.sac_morning
~time_passes(3,0,1)
You start driving.
# button
*[🚗]
{phone_mount==false:
->no_phone_mount->day_1_sac_afternoon_in_sf
}
->stay_or_go
= stay_or_go
# link
# day_1_sacramento.stay_or_go
You only earned ${day_fares_earned}. At this rate, you're unlikely to make $1000 by the end of the week.

* [Stay in Sacramento] 
->sac_lunch
* [Go to San Francisco] There's still time to salvage today, you think.
~current_city="sf"

->day_1_sacramento.go_to_sf

=sac_lunch
# button
# day_1_sacramento.sac_lunch
You like driving in a familiar town, especially since it means you can get lunch at your favourite burrito place.
{phone_mount==true: 
~time_passes(4,0,1)
}
* [🌯] ->sac_afternoon

=sac_afternoon

{phone_mount==false:
->no_phone_mount->stay_or_go_2
}

->stay_or_go_2

=stay_or_go_2
# link
# day_1_sacramento.stay_or_go_2
It's 4pm, and you've only earned ${day_fares_earned}.
* [Call it a day] You head home, in time for dinner.-> day_1_end
* [Keep going] Things should pick up during rush hour and dinner time. ->sac_late_afternoon
* [Go to San Francisco] By this point, it doesn't really make sense to make the two-hour trip to SF. You decide to stay in Sacramento, regretting that you didn't go earlier.->sac_late_afternoon

=sac_late_afternoon
# day_1_sacramento.sac_late_afternoon

~time_passes(3,0,1)
# button
*[🚗]->sac_evening

=sac_evening
It's starting to get late.

* [Go home]->go_home
* [Keep driving]->keep_driving
* {gym_member} [Freshen up at the gym]->gym

=go_home
You decide to go home.
# button
*[🚗]
->day_1_end

=keep_driving
You keep driving.
~time_passes(2,1,1)
# button
*[🚗]
->go_home

=gym
You take a shower at the gym. Feeling refresed, you keep driving.
~time_passes(3,1,1)
# button
*[🚗]
->go_home


=== day_1_sf ===

# button
# day_1_sf

~time_passes(4,0,1)
* [Start driving] 

->day_1_sf_morning

===day_1_sf_morning===
# link
# day_1_sf_morning
That was a productive morning! You decide to stop for lunch.
~add_time(0,30)
* [🌯] You spot a Señor Sisig food truck and decide on burritos
* [🍕] You grab a quick slice of pepperoni
- ->day_1_sf_afternoon

===day_1_sf_afternoon===
# day_1_sf_afternoon

{phone_mount==false:
->no_phone_mount->day_1_sf_evening_mount
- else:

~time_passes(5,0,1)
# button
*[Back to driving]

->day_1_sf_keep_going
}

===day_1_sf_evening_mount===
You get back online just in time for the busy evening period.
~time_passes(2,1,1)
# button
*[🚗]

->day_1_sf_keep_going 

 
===day_1_sf_keep_going===
# link
It's starting to get late.


* [Go home]->go_home
* [Keep driving]->keep_driving
* {gym_member} [Freshen up at the gym]->gym

=go_home
You decide to go home.
# button
*[🚗]
->day_1_end

=keep_driving
You keep driving.
~time_passes(2,1,1)
# button
*[🚗]
->go_home

=gym
You take a shower at the gym. Feeling refresed, you keep driving.
~time_passes(3,1,1)
# button
*[🚗]
->go_home

=== day_1_end ===
# button
# day_1_end
It's the end of the first day.
~ timestamp=1502150400
~day_end()
*[Start day 2]->day_2_start

=== day_2_start ===
# day_2_start
It's Tuesday. 
~timestamp=1502182800 

{home=="sac":
~timestamp=1502179200
You wake up a bit earlier today.
* [Drive to San Francisco]

~alter(day_hours_driven,2)
~add_time(2,8)
}
- ->gas_receipt

===gas_receipt===
# link
# gas_receipt
You stop to fill up your tank. Do you get a receipt? 
~add_time(0,14)
*[Yes]You keep it in a folder for your expenses.
~kept_receipt=true
*[Nah]You don’t have time to keep track of stuff like that.
~kept_receipt=false
- ->day_2_midpoint

===day_2_midpoint===
# button
# day_2_midpoint
~time_passes(3,0,1)
~ UberXL()
* [ok] 
->burgers

===burgers===
# link
# burgers
~temp dirty=false
You get a trip request from a burger joint, and when you arrive the passengers have two juicy In N Out burgers that they are about to eat in the car.

* ["The food can’t come in the car"]"Aww, come on," they say. "We'll be careful."
    # link
    ** "No means no[."]," you say, as you cancel their ride.
    ->day_2_evening
    
    ** "Oh, alright[."]," you say. They get in the car. <>
    
* ["Nice! I love burgers too."]They get in the car and you start driving. 

- From the rear-view mirror, you see one of them take a bite, and some ketchup drips onto the seat."
~add_time(0,4)
    # link
    ** [Say something] After your admonishment, they wipe the seat, but there's still a stain. They look unhappy at being called out.
    ~ dirty=true 
    ~ alter(rating,-5)
    ** [Keep quiet] They blithely continue eating. You can't stop thinking about the stain.
    ~ dirty=true
    -- "They finish their burgers. The rest of the trip passes without incident."
    ~add_time(0,22)
    ->dirty_car 
    
===dirty_car===
# link
# dirty_car
What do you do about your dirty backseat?
* [Stop to clean it] You pull over to clean the back seat. Before you start cleaning, a ride request comes in.
    # link
    ** [Take the request]You abandon the cleaning and go pick up the passenger. He's not impressed with the dirty backseat.
    ~ alter(rating,-10) 
    ~ alter(ride_count_total,1)
    ~ alter(fares_earned_total,8)
    ~add_time(0, 18)
    ** [Decline the ride] You finish cleaning up.
* [Ignore it] You put it out of your mind. Your next passenger is not too impressed with the dirty backseat.
    ~ add_time(0, 24)
    ~ alter(rating,-10) 
- {rating > 480 :
    -> day_2_evening
  - else :
    ->low_rating->day_2_evening
    }

===day_2_evening===
# link
# day_2_evening
~time_passes(4,0,1)
You've been driving for a while now. Do you want to push on for the evening peak period?

* [Yes]

~time_passes(3,1,1)

->day_2_end

* [No]You deserve a break. You meet up with some friends for dinner instead. 

->day_2_end
=== day_2_end ===
# button
# day_2_end
~timestamp=1502236800
~day_end()

* [Start Day 3]

-> day_3_start

=== day_3_start ===
# day_3_start
~timestamp=1502269200
{home=="sac":
~timestamp=1502265600
You head over to San Francisco. <> 
~alter(day_hours_driven,2)
}
->pebble_start

===pebble_start===
# link
# pebble_start
~add_time(0,19)
As you drive along the highway, a pebble hits your windshield and leaves a chip.

* [Repair it immediately]
->repair

* [Ignore it] 
~ windshield_cracked=true
->day_3_morning

=repair
# button
# pebble_start.repair
You find a nearby auto shop. They take an hour to fix your windscreen, and charge you $30.
~add_time(1,0)
* [Continue driving]->day_3_morning

===day_3_morning===
# day_3_morning
~time_passes(4,0,1)
{unlimited_data==false:
->data_plan
- else:
->nice_passenger
}

===nice_passenger===
# link
# nice_passenger
~add_time(0,18)
You pick up a friendly passenger and have a pleasant chat during the ride.

* [Give her 4 stars]

* [Give her 5 stars]
- Soon, you get a notification. She gave you an 'Excellent Service' badge! 

"Friendly and professional. Would ride again" 
~ alter(rating,3)
# link
** [Keep driving] Nice! Your rating has gone up to {rating/100}.
** [Reward yourself] You stop for a brief break at Burger King.
~add_time(0,13)
// TODO: MONEY

- ~time_passes(2,0,1)
->quest_finish->
->day_3_quest_near_finish->
->day_3_end
===day_3_quest_near_finish===
# link
# day_3_quest_near_finish
{quest_rides<5 && quest_rides > 0:
MESSAGE FROM UBER: Just {quest_rides} more rides until you get ${quest_bonus} bonus!
* [Keep driving]As you pull up for the next pick-up, you find, annoyingly, that it's for a long trip to the airport.
    # link
    **[Ask the passenger if you could decline]The passenger says she's in a hurry.
    # link
        ***[Cancel on her]She shouts as you as you pull away. Fortunately, the rest of the rides were short ones. You finish after two hours.
        ~ alter(day_ride_count, quest_rides)
        ~ alter(day_fares_earned, quest_rides*6)
        ~ alter(day_hours_driven, 2)
        ~ add_time(2,6)
        ~ quest_rides=0
        ->quest_finish->day_3_end
        ***[Go to the airport]You take her to the airport. You didn't want to get in the queue for a ride back, so you drive back to town by yourself. You decide to call it a day and finish the quest tomorrow instead. 
        ~ alter(day_ride_count, 1)
        ~ alter(day_fares_earned, 30)
        ~ alter(day_hours_driven, 1)
        ~ alter(quest_rides, -1)
        ~add_time(1,13)
        ->day_3_end
    **[Just go to the airport]ou take her to the airport. You didn't want to get in the queue for a ride back, so you drive back to town by yourself. You decide to call it a day and finish the quest tomorrow instead.
        ~ alter(day_ride_count, 1)
        ~ alter(day_fares_earned, 30)
        ~ alter(day_hours_driven, 1)
        ~ alter(quest_rides, -1)
        ~add_time(1,13)
        ->day_3_end
* [Call it a day]
* [Vacuum your car before you call it a day]
->day_3_end
}
->->
===day_3_end===
# button
# day_3_end
->quest_finish->
* [Call it a day]


~ timestamp=1502323200
~day_end()
# button
** [Start day 4] -> day_4_start


===day_4_start===
# day_4_start
~timestamp=1502352000
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
# link
# day_4_start.day_4_quest_completed
Since you've already finished the quest and the next one won't start until Friday, do you want to take the day off?
* [Take day off]
You spend the day with your family. Your son is glad you made time for him, and you get some much needed rest. 
~helped_homework=true
->day_5_start
* [Keep working]
You need every penny you can earn.

->day_4_morning

=day_4_quest_easy
# day_4_start.day_4_quest_easy
It should be pretty easy to complete the last few rides for the quest bonus.

->day_4_morning

=day_4_quest_hard
# day_4_start.day_4_quest_hard
Today is the last day to complete enough rides for the bonus.

->day_4_morning

=day_4_quest_impossible
# link
# day_4_start.day_4_quest_impossible
There's no way you'll complete enough rides to finish the quest. Do you want to take the day off and start afresh when you get a new quest on Friday?
* [Take day off]
You spend the day with your family. Your son is glad you made time for him, and you get some much needed rest.
~helped_homework=true
->day_5_start
* [Keep working]
If you can't finish the quest, then it's even more important to earn more fares.->day_4_morning

===day_4_morning===
# link
# day_4_morning
As you head out, you remember that you promised your son to be home by 8pm to help him with his homework.
{home=="sac":
* [Drive in Sacramento today] You decide to stay.
~ current_city = "sac"
-> day_4_sacramento

* [Go to San Francisco]You decide to go to San Francisco, since you'll get more rides there.
~alter(day_hours_driven,2)
~add_time(2,3)
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
# button
# day_4_sacramento
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
~add_time(9,12)
- quest_rides<10 && quest_rides>3:
~alter(day_hours_driven,4)
~add_time(4,21)
- quest_rides<3:
~alter(day_hours_driven,2)
~add_time(2,9)
}
~ quest_rides=0
~quest_completion=true
->day_4_end

- quest_completion==false && quest_rides > 35:
You're unlikely to finish the quest by this point, so you just go where the rides take you. 

~time_passes(9,0,1)
# button
* [Time to go home]You call it a day just after 7pm, and make it back home in time to spend the evening with your son, as you promised.
~helped_homework=true
    ->day_4_end

- else:
It might be a stretch to do {quest_rides} rides, especially in Sacramento, but you give it a shot.
~ temp remaining=quest_rides-3
You drive for 9 hours. During this time, you completed {remaining} rides, and earned ${remaining*6} in fares. Your driver rating is {rating/100} 
~ alter(day_ride_count, remaining)
~ alter(day_fares_earned, remaining*6)
~ alter(day_hours_driven, 9)
~ add_time(9,12)
~ quest_rides=3
# button
* [MESSAGE FROM UBER] Just three more trips until you complete your quest!
But it's already 7pm and you promised to be home by 8.
->quest_nudge

}

===quest_nudge===
# link
# quest_nudge
* [Keep driving] It takes you two hours to finish the last {quest_rides} rides, but you finish the quest. You get ${quest_bonus}!
{home=="sac":You drive as quickly as you can to get back to Sacramento, but y}{home=="sf":Y}our son is already asleep by the time you get back. He didn't finish his homework.
~ alter(day_ride_count, 3)
~ alter(day_fares_earned, 19)
~ alter(day_hours_driven, 2)
~ add_time(2,3)
~quest_completion=true
~quest_rides=0
->day_4_end

* [Go home]You go home and help your son with his homework before tucking him into bed. He's happy you kept your promise.
~helped_homework=true

It's 10:30pm and you're tired after a long day, but the quest doesn't expire until 4am.
# link
** [Go back out]You get back in your car and turn the app back on. It takes you two hours to finish the last three rides, but you finish the quest. You get ${quest_bonus}!
You are completely exhausted.
~ alter(day_fares_earned, 19)
~ alter(day_hours_driven, 2)
~ add_time(2,8)
~quest_completion=true
~quest_rides=0
->day_4_end
** [Go to sleep] You're too exhausted.
->day_4_end

===napa===
# button
# napa
Soon after you arrive, you pick up some tourists who want to go to Napa and drive across the Golden Gate Bridge. This is going to take a while...
* [Put your favourite dance mix on Spotify]
* [Keep the car quiet and professional]

- The long trip turns out to be a mixed blessing. You're not much closer to finishing your quest, but it nets you $165 in fares, and $100 in tips!
~ alter(fares_earned,265)
~ alter(ride_count,1)
~ alter(quest_rides, -1)
~ add_time(1,49)
# button
    **[Drive into San Francisco]
->day_4_sf

===day_4_sf===
# link
# day_4_sf
~ temp remaining=quest_rides-3
By now, you've become used to the rhythm of the day and how this works.

{ 
- quest_completion==true:
You go where the rides take you. It's a pretty normal day.

    {home=="sac":
    ~time_passes(5,0,1)
    ~UberXL()
    
    It's 5:30pm. Do you turn off the app and start heading back home to Sacramento? 
    # link
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
    You drive for 6 hours. During this time, you completed {remaining} rides, and earned ${remaining*6} in fares. Your driver rating is {rating/100} 
    ~ alter(day_ride_count, remaining)
    ~ alter(day_fares_earned, remaining*6)
    ~ alter(day_hours_driven, 6)
    ~ timestamp=1502388120
    ~ quest_rides=3
    # button
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
    ~ add_time(8,14)
    - quest_rides<10 && quest_rides>3:
    ~alter(day_hours_driven,4)
    ~add_time(3,57)
    - quest_rides<3:
    ~alter(day_hours_driven,1)
    ~add_time(0,54)
    }
    ~ quest_rides=0
    ~quest_completion=true
    # button
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
    ~ add_time(8,14)
- quest_rides<10 && quest_rides>3:
~alter(day_hours_driven,4)
    ~add_time(3,57)
- quest_rides<3:
~alter(day_hours_driven,1)
    ~add_time(0,54)
}
~ quest_rides=0
~quest_completion=true
# button
*[Time to go home]You get back in time, as promised, and spend a pleasant evening with your son.
~helped_homework=true
->day_4_end
}

- quest_completion==false && quest_rides > 35:
You go where the rides take you. It's a pretty normal day.

    {home=="sac":
    ~time_passes(5,0,1)
    ~UberXL()
    ~timestamp=1502386200
    It's 5:30pm. Do you turn off the app and start heading back home to Sacramento? 
    # link
    * [Yes]You get back in time, as promised, and spend a pleasant evening with your son.
    ~add_time(3,48)
    ~helped_homework=true
    ->day_4_end
    * [No]You keep driving.
    ~time_passes(2,1,1)
    It's late by the time you get back. Your son is already asleep, his homework unfinished.
    ->day_4_end
    }

    {home=="sf":
    ~time_passes(7,0,1)
    ~timestamp=1502391600
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
        # button
        * [MESSAGE FROM UBER:] Just {quest_rides} more trips until you complete your quest!
        ~timestamp=1502388120
        But it's already 6pm and you promised to be home in Sacramento by 8.
        
        ->quest_nudge
        
        - quest_rides>=4 && quest_rides<15:
        ~timestamp=1502388120
        It's 6pm and you promised to be home in Sacramento by 8.
        # link
        * [Go home] You go home and help your son with his homework before tucking him into bed. He's happy you kept your promise.
        ~helped_homework=true
        ->day_4_end
        
        * [Keep driving] It takes you another 3 hours before you get enough rides, but you do it. 
        You finished the quest! You get the ${quest_bonus} bonus.
        ~ alter(day_ride_count, quest_rides)
        ~ alter(day_fares_earned, quest_rides*7)
        ~ alter(day_hours_driven, 3)
        ~ add_time(2,52)
        ~ quest_rides=0
        ~ quest_completion=true
        # button
        ** [Go home]
        ~add_time(2,5)
        ~ alter(day_hours_driven, 2)
        It takes you another two hours to get home. By the time you get back. Your son is already asleep, his homework unfinished.
        # button
        *** [Watch him sleep] You watch him for a while, then head to bed.
        ->day_4_end
        
        - else:
        ~timestamp=1502388120
        It's 6pm and you promised to be home in Sacramento by 8. It doesn't look like you'll finish the quest after all.
        # button
        * [Go home] You go home and help your son with his homework before tucking him into bed. He's happy you kept your promise.
        ~helped_homework=true
        ~add_time(3,37)
         # button
        ** [Go to sleep]
        ->day_4_end
        }
    
    }

    {home=="sf":

    You drive for 9 hours. During this time, you completed {remaining} rides, and earned ${remaining*6} in fares. Your driver rating is {rating/100} 
    ~ alter(day_ride_count, remaining)
    ~ alter(day_fares_earned, remaining*6)
    ~ alter(day_hours_driven, 9)
    ~ add_time(8,57)
    ~ quest_rides=3
    # button    
    * [MESSAGE FROM UBER] Just three more trips until you complete your quest!
    But it's already 7pm and you promised to be home by 8.
    ~timestamp=1502391600
    ->quest_nudge
    }
}

===day_4_end===
# button
# day_4_end
~timestamp=1502409600
It's the end of day 4.
{home=="sac":
~alter(hours_driven_total,2)
}
Today, you drove for {day_hours_driven} hours, completed {day_ride_count} rides and earned ${day_fares_earned} in fares. Your driver rating is {rating/100}.

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
# button
# day_5_start
~timestamp=1502442000
~current_city="sf"
It's Friday. You get a new quest for the weekend.
{quest_completion==true:
~weekday_quest_completion=true
}
~quest_rides=65
~quest_bonus=150
~weekend_quest_bonus=quest_bonus

* MESSAGE FROM UBER[]: "New Uber Quest: Drive {quest_rides} trips, make ${quest_bonus} extra. You have until Monday May 29, 4 am"

{quest_completion == false:
    You are determined to finish this quest after missing out on the last one.
    - else:
    You are determined to finish this quest as well. Bonus payments can really boost your earnings.
}
~quest_completion=false
->day_5_late_start

===day_5_late_start===
# link
# day_5_late_start
Friday and Saturday nights are some of the busiest times for rides, but the peak period doesn't start until 10pm.

* [Start at your normal time] ->day_5_daytime

* [Start driving in the evening] You take a rest and try to nap a bit during the day. {home=="sac":You leave for San Franciso after dinner at home.} 
~timestamp=1502474400
-> day_5_evening

===day_5_daytime===
# link
# day_5_daytime
You decide that it's not worth it to disrupt your normal schedule.

{home=="sac": 
You head into San Francisco at your usual hour.
~alter(day_hours_driven,2)
~add_time(2,3)
~time_passes(7,0,1)
- else:
~time_passes(9,0,1)
}

* [Call it a day] You're getting tired and decide to go home
{home=="sac": 
~alter(day_hours_driven,2)
~add_time(2,3)
}
-> day_5_end

* [Keep driving] You decide to try to catch the evening crowd.
-> day_5_evening

===day_5_evening===
# day_5_evening
~time_passes(2,1,1)

You've just dropped off a passenger in the Financial District in the northeast of San Francisco, when you notice there's surge pricing. 
# button
* Check the app[]: You see there's 3x surge pricing in the Sunset district.
->surge
=surge
# link
# day_5_evening.surge
The 3x fare is attractive, but it might be gone by the time you get to the Sunset district, which is 30 minutes away. 

* [Chase the surge]Tripling your earning is just too tempting. You start driving over to the surge zone, but the roads are busy and the traffic lights are not on your side tonight. 

You are three blocks away when the surge ends. You are annoyed at having wasted half an hour.
    ~add_time(0,32)
    # button
    **[Darn]
~time_passes(2,1,1)

* [Don't chase the surge]You ignore the message. It'll probably be gone by the time you get there.
    # button
    **[Keep driving]
    
~time_passes(3,1,1)
- ->home_or_not

=home_or_not
# link
# day_5_evening.home_or_not
~timestamp = 1502496480
When you can finally take time for a break, it's already past midnight.

* [Go home] 
{ 
- day_5_daytime && home=="sac": 
You're very tired on the drive home. On the way back you've had to pull over and take a nap before you could continue. You don't get back until nearly 3am. 
~ add_time(2,47)
->day_5_end
- day_5_daytime && home=="sf":
You're too tired. You call it a night, and drive back home. ->day_5_end
- else:
You call it a night, and drive back home. ->day_5_end
}

* {day_5_daytime && home=="sac"} [Sleep in your car] You're too tired to drive another two hours to go back home. You find a quiet spot to park your car in and spend an uncomfortable night sleeping in your car.
    ~add_time(0,22)
    **[zzz] It's not very comfortable, but you eventually fall asleep.
    ~day_end()
-> day_6_slept_in_car

* [Keep driving] ->vomit

===vomit===
# link
# vomit
~add_time(0,8)
You arrive at a pick-up and see a passenger vomiting on the side of the road.

* [Cancel the ride and drive away] You decide it's not worth it. 
    # link
    ** [Keep driving]
    ->day_5_late_night
    ** [Call it a night] You decide to call it a night.
    ->go_home

* [Let the passenger in]You drive to the destination. As he is getting out, the passenger vomits out the window. Ugh!
    # button
    ** [Clean up the mess and notify Uber] 
{ cleaning_supplies==true: 
Luckily, you have cleaning supplies in your trunk. You pull over and spend some time cleaning up.
~add_time(0,18)
    Uber gives you $30 in cleaning fees.
//TODO: figure out how to record this money
    ->day_5_late_night
- else: You don't have any cleaning supplies, and spend some time trying to find a gas station with a convenince store. You eventually clean it all up.
    Uber gives you $30 in cleaning fees.
~add_time(0,58)
//TODO: figure out how to record this money
    ->day_5_late_night
}
    
=go_home
# link
# vomit.go_home
{home=="sf":
->day_5_end
}
{home=="sac":
* [Go home] You're very tired on the drive home and had to pull over for a nap before you could continue. You don't get back until nearly 3am. 
~ add_time(1,47)
-> day_5_end

* [Sleep in your car] You're too tired to drive another two hours to go back home. You find a quiet spot to park your car in and spend an uncomfortable night sleeping in your car.
~add_time(0,18)
    ~day_end()
    **[zzz]It's not very comfortable, but you eventually fall asleep.
-> day_6_slept_in_car
}

===day_5_late_night===
# link
# day_5_late_night
The late hours are certainly lucrative.

~time_passes(2,1,1.3) 

{day_5_daytime : You are so tired that you can do nothing more than park your car by the side of the road and sleep -> day_6_slept_in_car }

* [Go home] 
{ home=="sf": ->day_5_end} 
You're not used to staying up so late and are very tired on the drive home. You don't get back until nearly 4am. 
~ timestamp=1502510160
-> day_5_end

* {home=="sac"}[Sleep in your car] You're too tired to drive another two hours to go back home. You find a quiet spot to park your car in and spend an uncomfortable night sleeping in your car.

    **[zzz] It's not very comfortable, but you eventually fall asleep.
    ~day_end()
    -> day_6_slept_in_car

* [Keep driving] You're really tired by this point but decide to keep going.

In your next ride, the passenger complains that you seem sleepy behind the wheel. Uber immediately deactivates you, without telling you the reason.

# link
**[Contact Uber] You call Uber to contest your deactivation. You spend an hour going back and forth with them on the phone, but all you get is a promise that they'll look into it.
# button
    ***[Go home]
    You drive home and collapse into bed.
    ~day_end()
->day_6_deactivated

**[Go home]
You drive home and collapse into bed.
    ~day_end()
->day_6_deactivated


===day_5_end===
# day_5_end
~timestamp=1502514000
//friday 5am
~day_end()
->day_6_start

===day_6_deactivated===
# button
# day_6_deactivated
~timestamp=1502528400
//saturday 9am
It's Saturday. You wake up and check your Uber app to find that you're still deactivated.You decide to make the most of your enforced day off.

* [Spend time with your son]
~ timestamp=1502559480
//sat 5:38pm
You spend a relaxing afternoon in the park with your son. It sure feels good to not have to sit in a car all day. 

{helped_homework==false: Your son was still mad at you for letting him down on Thursday, but brightened up significantly by the end of the day.}
# button
**[You feel refreshed]
->day_7_start


=== day_6_slept_in_car ===
# day_6_slept_in_car
~timestamp=1502528400
You wake up, briefly forgetting that you're in your car in San Francisco.

->day_6_start

=== day_6_start===
# link
# day_6_start
It's Saturday. Do you take the day off? It is the weekend, after all.

* [Take day off] You decide to take the day off. You spend a relaxing afternoon in the park with your son. It sure feels good to not have to sit in a car all day. 
~add_time(10,32)
{helped_homework==false: Your son was still mad at you for letting him down on Thursday, but brightened up significantly by the end of the day.}
# button
**[You feel refreshed]
->day_7_start

* [Go to work] You're not earning when you're not working.
->day_6_work

=== day_6_work ===
# button
# day_6_work
MESSAGE FROM UBER: 
The San Francisco Giants are playing at AT&T park today. Earn a boosted 1.5x fare for trips from there, from 5pm-6:30pm today 

*[Got it]
~ time_passes(3,0,1)

->door_dent

=== door_dent ===
# link
# door_dent
As you finish a ride, the passenger opens the door to get out and hits a lamp post, denting your car door. He is apologetic, but in a rush, and tells you to resolve it with Uber.

*[Report the incident to Uber] Uber promises to investigate, but in the meantime your account is suspended. There's nothing else you can do today. -> day_6_end
*[Don't report it] You decide to get it repaired yourself. It takes the mechanics two hours to fix it, and they charge you $100. 
//TODO money
~add_time(2,21)
->day_6_afternoon

=== day_6_afternoon ===
# button
# day_6_afternoon
~ time_passes(3,0,1)
* [Head over to the baseball stadium]
You make your way to the baseball stadium before the game ends. Sure enough, lots of people are requesting rides there. You get lucky with a relatively long ride to Outer Richmond, and earn $30
    ~ alter(day_ride_count, 1)
    ~ alter(day_fares_earned, 30)
    ~add_time(0,48)
# button
** [Great!]
->day_6_evening


=== day_6_evening ===
# button
# day_6_evening
It sure is busy this Saturday evening.
~time_passes(3,1,1)

*[It's been a pretty good day] You call it a day
-> day_6_end

=== day_6_end ===
~timestamp=1502582400
//sunday midnight
# button
# day_6_end
~ day_end()

* [Start day 7]
->day_7_start

=== track_mileage ===
# link
# track_mileage
~timestamp=1502614800
//sun 9am
It's been a long week. You idly wonder just how far you've driven.

* [Good thing you've been keeping track] {home=="sf": You check your notes: 869 miles. That's quite a lot.}{home=="sac":You check your notes: 1567 miles. That's quite a lot.}
~miles_tracked=true
->->
* [(shrug emoji)]It doesn't really matter.
~miles_tracked=false
->->

===day_7_start===
# button
# day_7_start
->track_mileage->

It's Sunday! You still need {quest_rides} more rides to get the weekend bonus.
*[Let's do this!]

~time_passes(3,0,1)
->no_drop_zone
=== no_drop_zone===
# link
# no_drop_zone
A passenger insists you drop her off at the entrance to the Caltrain station, which is a no-stop zone.
~add_time(0,19)
* [Agree to do so]
~ temp ticket = RANDOM(1,3)
{ticket>1: 
You drop her off quickly. Luckily, there weren't any cops around.
- else: As you drop her off, you see a police car pull up behind you. You get a traffic ticket (-$260)
~ticketed=true
//TODO money
}

->day_7_afternoon

* [Refuse] You stop nearby and explain why you cannot drop her off at the entrance. She slams the door as she gets out.
~alter(rating, -20)
->day_7_afternoon

===day_7_afternoon===
# link
# day_7_afternoon
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
# button
# pebble_crack
You are driving when you hear a splintering sound. The chip in your windshield is turning into a crack that is spreading across the whole windshield. You have no choice but to get it repaired
* [The mechanic charges you $250]You pay the money, regretting that you didn't get it fixed earlier.
~add_time(1,58)
->->

===day_7_evening===
# link
# day_7_evening
~time_passes(3,1,1)
->quest_finish->

{
-quest_completion==true:
# button
*[Call it a day]
->day_7_end
-quest_rides < 5 && quest_completion==false:
MESSAGE FROM UBER: Just {quest_rides} more trips until you complete your quest!
# button
*[Finish the quest]It doesn't take you long to finish the last {quest_rides} rides. 
Congrats! You completed the quest and got an extra ${quest_bonus}.
~quest_completion=true
->day_7_end

- quest_rides>=5 && quest_rides<10:
You only have {quest_rides} left to do. You could try to finish it by cancelling when you get a long ride. Your rating will suffer though.

# link
*[Hustle to finish it]It takes you a few hours, but your strategy works, and you complete the last ride needed just before midnight.

~ alter(day_ride_count, quest_rides)
~ alter(day_fares_earned, quest_rides*5)
~ alter(day_hours_driven, 4)
~add_time(3,43)

{ rating > 480: 
Congrats! You completed the quest and got an extra ${quest_bonus}.
~quest_completion=true
->day_7_end
- else: For some reason, you didn't get the reward.
    #button
    ** [Huh?] You re-read the instruction text in the app, and realise, too late, that you didn't the get reward because your rating has dropped too low. 
        #button
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
# button
# day_7_end
~day_end()
{quest_completion==true:
~weekend_quest_completion=true
}
It's the end of the week. Were you savvy enough to survive as a full-time Uber driver?
*[See how you did]
->results_revenue


===no_phone_mount===
# no_phone_mount
With no phone mount, you're left fiddling with your phone on your lap. A passenger notices and complains to Uber about your dangerous driving.
~add_time(4,0)
~phone_mount=true 
~alter(accessories_cost,25)
{sac_morning:
~current_city="sf"
}
#button
* [Uh oh] You are deactivated for 4 hours. You use that time to buy a phone mount and charging cables for $25{sac_morning: and make your way to SF}.
->->

===data_plan===
# link
# data_plan
You get a message from your phone provider: You've reached your data limit this month. 
*[Upgrade to an unlimited data plan ($20/week)]

~unlimited_data=true
~alter(accessories_cost,20)
*[Let it go to overage charges($30/week)]For some reason, you decide to pay the overage charges instead.
~alter(accessories_cost,30)
- ->nice_passenger


===results_revenue===
# button
# results_revenue
~ revenue_total=fares_earned_total
This week, you drove for {hours_driven_total} hours, completed {ride_count_total} rides, and had a driver rating of {rating/100}

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
# button
#results_costs
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

Renting your {car} and buying insurance cost ${car_cost}.
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
*[THE END]
->endscreen

===endscreen===
# endscreen
You've reached the end
->END


/* 
===airport_incident===
"You are driving a passenger to the airport when you miss the freeway exit. The passenger gets very angry, saying: "Do I need to drive for you?"

* "Sorry[!"], you say. But you stew over the remark. Especially when you see they've given you a bad rating"

*/


