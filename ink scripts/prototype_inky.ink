INCLUDE functions
INCLUDE check_quest
INCLUDE ratings
INCLUDE results

//Set-up variables 
VAR car="none"
VAR home="none"
VAR credit_rating="none"
VAR timestamp=1502092800
// start time: Monday, August 7, 2017 8:00:00 AM GMT

//accessories variables
VAR unlimited_data=false
VAR phone_mount=false
VAR cleaning_supplies=false
VAR biz_licence=false
VAR gym_member=false

//Vital stats variables
VAR current_city="none"

VAR day_ride_count=0
VAR day_fares_earned=0
VAR day_hours_driven=0
VAR rating=500
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
VAR finished_quest_on_weds=false


// Variables for the final screens
VAR revenue_total=0
VAR cost_total=0

//Cost tracking
VAR accessories_cost=0
VAR repair_cost=0
VAR gas_cost=0
VAR tax_cost=0
VAR car_cost=0
VAR ticket_cost=0

// Social choice variables
VAR took_day_off=false
VAR helped_homework=false
VAR friends_dinner=false
VAR overnight=false

/* 
You and XX% didn’t take a single day off
You and XX% kept your promise to help your son with his homework
You and XX% missed meeting your friends for dinner
You and XX% slept overnight in your car
You and XX% were good citizens and bought a business licence (VAR biz_licence from accessories)
Your body is aching after you spend XX hours this week in your car
*/

// Functional variables

VAR time_passing=false
VAR moments=false

/* NOTE: for tags,
button = no choice
link = choice
*/

->welcome
=== welcome ===
# welcome
You're a full-time Uber driver trying to make ends meet.

You have one week to try to make $850, the average weekly income in the United States.

Can you do it?
# button 
* [Yes] 
->choose_difficulty

=== choose_difficulty===

# choose_difficulty

Your difficulty level will affect how easy it is to make $850 in a week.
# link 
+ [Easier]
~ home="sf"
~ credit_rating="good"
You live in San Francisco and have good bank credit, making it cheaper for you to rent a car. 
You have two kids to support, and a mortgage payment coming due.
->confirm

+ [Harder]
~ home="sac"
~ credit_rating="bad"
You have a bad credit rating and can't afford to live in San Francisco. Instead, you live two hours away in Sacramento.
You have two kids to support, and a mortgage payment coming due.
-> confirm

=confirm
# choose_difficulty.confirm
# link
{home=="sf":Choose the easier difficulty?}
{home=="sac":Choose the harder difficulty?} 

+ [Go back]
->choose_difficulty
+ [Yes]
- ~current_city=home
->day_1_start


=== day_1_start ===

# day_1_start
~ add_time(0,10)
You start bright and early on a Monday morning.

Pretty soon, you get your first ride request, from someone called Chris.
->day_1_locate_passenger

===day_1_locate_passenger===
# link
# day_1_locate_passenger
You go to pick him up, but don't see anyone waiting for a ride when you arrive. What do you do?
~add_time(0, 5)
* [Call Chris]->call_chris
* [Wait] You wait in your car. ->chris_arrives

=call_chris
# link
# day_1_locate_passenger.call_chris
He answers the phone. "I'll be right there! Just coming out now," he says.
~ add_time(0,3)
* ["Hurry up, will you?"]
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
->drop_off
=drop_off
# day_1_locate_passenger.drop_off
"Thanks! Sorry again for making you wait," he says as he gets out.

Congratulations! You've just earned your first fare, for $16.
~ moments=true
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
~ car="minivan"
~ alter(car_cost, minivan_cost)
->confirm

=confirm
# car_choice.confirm
# link
Rent this car? You will also buy insurance for ${insurance} a week.

+ [Go back]
->car_choice
+ [Choose this car]
~ alter(car_cost, insurance)
->buy_accessories


===buy_accessories===
# list
# buy_accessories
{!To prepare for life as a professional driver, you also bought...|What else did you buy?}

* [Unlimited data plan ($20/week)]Since you always have to be connected to the Uber app, an unlimited data plan will save you from paying overage charges. 
    ~unlimited_data=true
    ~alter(accessories_cost,10)
    ->buy_accessories
* [Phone mount & charging cords ($25):]A phone mount lets you use your phone with one hand while keeping your eyes on the road. And you don't want to run out of batteries.
    ~phone_mount=true
    ~alter(accessories_cost,25)
    ->buy_accessories
* [Cleaning supplies ($20): ]In case someone makes a mess in your car 
    ~cleaning_supplies=true
    ~alter(accessories_cost,20)
    ->buy_accessories
* [Business license ($91): ]You are, after all, technically running a business as an independent contracter. 
    ~biz_licence=true
    ~alter(accessories_cost,91)
    ->buy_accessories
* [Gym membership ($10/week): ]You could go work out at the gym, but the main perk is having a place to shower and freshen up.
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
- unlimited_data && phone_mount && cleaning_supplies && biz_licence && gym_member:You bought everything. It cost ${accessories_cost}. You used your credit card so you don't have to pay right away. 

 - !unlimited_data && !phone_mount && !cleaning_supplies && !biz_licence && !gym_member:You didn't buy anything.
 
 - else: You bought: 
 {unlimited_data:Unlimited data plan}
 {phone_mount:Phone mount}
 {cleaning_supplies:Cleaning supplies}
 {biz_licence:Business licence}
 {gym_member:Gym membership}
// {tip_sign:Tip sign}

It cost ${accessories_cost}. You put it on your credit card so you don't have to pay right away.

} 
# button
** [Get back to driving]
-> sf_or_sacramento

===weekday_quest_message===

# weekday_quest_message
~quest_rides=75
~quest_bonus=180
~weekday_quest_bonus=quest_bonus
MESSAGE FROM UBER 
"Uber Quest: Drive {quest_rides} trips, make ${quest_bonus} extra. You have until Friday May 26, 4 am"
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
# day_1_sac_afternoon_in_sf
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
# button
*[🚗 (Keep driving)]
{phone_mount==false: ->no_phone_mount->day_1_sac_evening_in_sf_mount}

->day_1_sac_evening_in_sf

===day_1_sac_evening_in_sf===
# day_1_sac_evening_in_sf
# link

{sac_morning:
After driving for so long, you're starting to get hungry.

-else: Coming to SF was definitely the right decision. But after driving for so long, you're starting to get hungry.
}

~add_time(0,30)
* [🌯 (Burritos)] You go for burritos
* [🍕 (Pizza)] You grab a quick slice of pepperoni

- ->day_1_sac_night_in_sf

===day_1_sac_evening_in_sf_mount===
# day_1_sac_evening_in_sf_mount
You get back online just in time for the busy evening period. 
~time_passes(2,1,1)
# button
*[🚗]
->day_1_sac_night_in_sf

===day_1_sac_night_in_sf===
# day_1_sac_night_in_sf
# link
It's getting late and you have a two hour drive to get back home.

* [Go home]->go_home
* [Keep driving]->keep_driving
* {gym_member} [Freshen up at the gym]->gym

=go_home
# day_1_sac_night_in_sf.go_home
You start driving back to Sacramento
~add_time(2,4)
~ alter(day_hours_driven, 2)
~ alter(hours_driven_total, 2)
# button
*[🚗]
->day_1_end

=keep_driving
# day_1_sac_night_in_sf.keep_driving
You call home to say you won't be back for dinner, and keep driving.
~time_passes(2,1,1)
# button
*[🚗]
->go_home

=gym
# day_1_sac_night_in_sf.gym
You take a shower at the gym. Feeling refreshed, you keep driving.
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
You only earned ${day_fares_earned}. At this rate, you're unlikely to make $850 by the end of the week.

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
* [🌯 (Burritos)] ->sac_afternoon

=sac_afternoon
# day_1_sacramento.afternoon
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
# day_1_sacramento.sac_evening
# link
It's starting to get late.

* [Go home]->go_home
* [Keep driving]->keep_driving
* {gym_member} [Freshen up at the gym]->gym

=go_home
# day_1_sacramento.go_home
You decide to go home.
~add_time(0,23)
# button
*[🚗]
->day_1_end

=keep_driving
# day_1_sacramento.keep_driving
You call home to say you won't be back for dinner, and keep driving.
~time_passes(2,1,1)
# button
*[🚗]
->go_home

=gym
# day_1_sacramento.gym
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
* [🌯 (Burritos)] You spot a Señor Sisig food truck and decide on burritos
* [🍕 (Pizza)] You grab a quick slice of pepperoni
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
# day_1_sf_evening_mount
You get back online just in time for the busy evening period.
~time_passes(2,1,1)
# button
*[🚗]

->day_1_sf_keep_going 

 
===day_1_sf_keep_going===
#day_1_sf_keep_going
It's starting to get late
# link
* [Go home]->go_home
* [Keep driving]->keep_driving
* {gym_member} [Freshen up at the gym]->gym

=go_home
#day_1_sf_keep_going.go_home
You decide to go home.
~add_time(0,23)
# button
*[🚗]

->day_1_end

=keep_driving
#day_1_sf_keep_going.keep_driving
You call home to say you won't be back for dinner, and keep driving.
~time_passes(2,1,1)
# button
*[🚗]
->go_home

=gym
#day_1_sf_keep_going.gym
You take a shower at the gym. Feeling refresed, you keep driving.
~time_passes(3,1,1)
# button
*[🚗]
->go_home

===day_1_end===
# day_1_end
It's the end of the first day.
~ timestamp=1502179200
~day_end()
# button
*[Start day 2]
->day_2_begin

=== day_2_begin ===
# day_2_start
It's Tuesday. You wake up, tired from having spent a whole day in the car yesterday.
# button
{home=="sac":
~alter(day_hours_driven,2)
~alter(hours_driven_total,2)
~add_time(2,8)
* [Drive to San Francisco]
->gas_receipt

- else:
* [Get in your car]
->gas_receipt
}

===gas_receipt===
# link
# gas_receipt
You stop to fill up your tank. Do you get a receipt? 
~add_time(0,14)
*[Yes]You keep it in a folder for your expenses.
~kept_receipt=true
*[No]You don’t have time to keep track of stuff like that.
~kept_receipt=false
- ->day_2_midpoint

===day_2_midpoint===
# day_2_midpoint
You turn on your Uber app and start driving.
~time_passes(3,0,1)
~ UberXL()
# button
*[🚗]
->burgers

===burgers===
# link
# burgers
~temp dirty=false
You get a trip request from a burger joint, and when you arrive the passengers have two juicy In-N-Out burgers that they are about to eat in the car.
~add_time(0,4)
* ["The food can’t come in the car"]"Aww, come on," they say. "We'll be careful."
    # link
    ** "No means no[."]," you say, as you cancel their ride.
    ->day_2_afternoon
    
    ** "Oh, alright[."]," you say. They get in the car. <>
    
* ["Nice! I love burgers too."]They get in the car and you start driving. 

- From the rear-view mirror, you see one of them take a bite, and some ketchup drips onto the seat."

    ~add_time(0,22)
    # link
    ** [Say something] After your admonishment, they wipe the seat, but there's still a stain. They look unhappy at being called out.
    ~ dirty=true 
    ~ alter(rating,-5)
    ** [Keep quiet] They blithely continue eating. You can't stop thinking about the stain.
    ~ dirty=true
    -- They finish their burgers. The rest of the trip passes without incident.
    ->dirty_car 
    
===dirty_car===
# link
# dirty_car
What do you do about your dirty backseat?

* [Stop to clean it] You pull over to clean the back seat. Before you start cleaning, a ride request comes in.
    ~add_time(0,13)

    # link
    ** [Take the request]You abandon the cleaning and go pick up the passenger. He's not impressed with the dirty backseat.
    ~ alter(rating,-10) 
    ~ alter(ride_count_total,1)
    ~ alter(fares_earned_total,8)
    ~ alter(day_ride_count,1)
    ~ alter(day_fares_earned,8)

    ** [Decline the ride] You finish cleaning up.

* [Ignore it] You put it out of your mind. Your next passenger is not too impressed with the dirty backseat.
    ~ alter(rating,-10) 

- ->day_2_afternoon

===day_2_afternoon===
# button
# day_2_afternoon
{home=="sf":
~time_passes(5,0,1)
- else:
~time_passes(3,0,1)
}
*[🚗]
{rating > 480 :
    -> day_2_evening
  - else :
    ->low_rating->day_2_evening
    }

===day_2_evening===
# day_2_evening
# link
You get a message from your friend. A group of them are meeting up for her birthday dinner {home=="sac":in Sacramento }and asks if you want to join.

* [Yes]
{home=="sf":
You deserve a break. You turn off the Uber app and go to dinner with your friends.
~ friends_dinner=true
~add_time(1,57)
->dinner
- else:

You want to, but it'll take too long to get back to Sacramento. You eat dinner by yourself instead before calling it a day.
~add_time(2,26)
~alter(day_hours_driven,2)
~alter(hours_driven_total,2)
->dinner
}

* [No]
->keep_working

=dinner
# day_2_evening.dinner
# button
*[🍲]
->day_2_end

=keep_working
#day_2_evening.keep_working

Working is more important. You say you can't make it.
~time_passes(3,1,1)
~alter(day_hours_driven,2)
~alter(hours_driven_total,2)
~add_time(2,1)
#button
*[🚗]
->day_2_end
=== day_2_end ===
# day_2_end
~timestamp=1502265600
{home=="sf":
You call it a day.
}

{home=="sac":
~timestamp=1502262000 //Weds 8am
The two-hour drive back to Sacramento is long and boring.
}

~day_end()
# button
* [Start Day 3]

-> day_3_start

=== day_3_start ===
# day_3_start

It's Wednesday. You're feeling more confident behind the wheel. 
{home=="sac":
You head over to San Francisco. <> 
~alter(day_hours_driven,2)
~alter(hours_driven_total,2)
~add_time(1,48)
}
->pebble_start

===pebble_start===
# link
# pebble_start
~add_time(0,19)
As you drive along the highway, a pebble hits your windshield and leaves a chip.

* [Repair it immediately]
->repair

* [Ignore it] It's just a small chip. You don't want to spend the time and money repairing a car you leased.
~ windshield_cracked=true
->day_3_morning

=repair
# button
# pebble_start.repair
You find a nearby auto shop. 
~add_time(1,0)
* [🔧]
They take an hour to fix your windscreen, and charge you $30. You put it on your credit card.
~alter(repair_cost,30)
->day_3_morning

===day_3_morning===
# day_3_morning
# button
~time_passes(4,0,1)

* [Continue driving]

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
~ alter(fares_earned_total,10)
~ alter(rating,10)
{rating>500:
~rating=500
}
* [Give her 4 stars]
* [Give her 5 stars]
- Soon, you get a notification. She gave you an 'Excellent Service' badge, and a $10 tip! 

"Friendly and professional. Would ride again" 

->reward

=reward
# nice_passenger.reward
# link
* [Keep driving] Nice!
-> day_3_pm
* [Reward yourself] You stop for a brief break at Burger King before continuing.
-> day_3_pm


===day_3_pm===
#day_3_pm

~time_passes(5,0,1)

#button
*[🚗]
->quest_finish->
->day_3_quest_near_finish

===day_3_quest_near_finish===
# link
# day_3_quest_near_finish
{
- quest_rides==0:
->day_3_end

- quest_rides<5 && quest_rides > 0:
MESSAGE FROM UBER
Just {quest_rides} more rides until you get ${quest_bonus} bonus!
* [Keep driving]As you pull up for the next pick up, you find, annoyingly, that it's for a long trip to the airport.
->pickup
* [Call it a day] 
->day_3_end

- else:
It's getting late.
{home=="sac":
~add_time(1,52)
}
* [Call it a day]
->day_3_end
* [Vacuum your car before calling it a day] You make sure the car is clean for tomorrow.
->day_3_end
}

=pickup
# day_3_quest_near_finish.pickup
# link
*[Ask the passenger if you could decline]The passenger says she's in a hurry.
    ->in_hurry

*[Just go to the airport]You drop her off at the airport.
    
You don't feel like getting in the queue for a ride back, so you drive back to town by yourself. 
~add_time(1,13)
# button
    **[🚗]
    You decide to call it a day and finish the quest tomorrow instead.
    ~ alter(day_ride_count, 1)
    ~ alter(day_fares_earned, 30)
    ~ alter(day_hours_driven, 1)
    ~ alter(quest_rides, -1)
    ->day_3_end

=in_hurry
# day_3_quest_near_finish.in_hurry
# link
*[Cancel on her]She shouts at you as you pull away. Fortunately, you quickly get a few short rides. 
    ~ add_time(2,6)
    ~ alter(ride_count_total, quest_rides)
    ~ alter(fares_earned_total, quest_rides*6)
    ~ alter(hours_driven_total, 2)
    ~ alter(day_ride_count, quest_rides)
    ~ alter(day_fares_earned, quest_rides*6)
    ~ alter(day_hours_driven, 2)
    ~ quest_rides=0
    # button
    **[🚗]

    ->quest_finish->day_3_end

*[Go to the airport]You take her to the airport.

You don't feel like getting in the queue for a ride back, so you drive back to town by yourself. 
~add_time(1,13)
~ alter(ride_count_total, 1)
~ alter(fares_earned_total, 30)
~ alter(hours_driven_total, 1)
~ alter(day_ride_count, 1)
~ alter(day_fares_earned, 30)
~ alter(day_hours_driven, 1)
~ alter(quest_rides, -1)
    # button
    **[🚗]
    You decide to call it a day and finish the quest tomorrow instead.
    ->day_3_end

->->
===day_3_end===
# button
# day_3_end
{home=="sac":
~alter(day_hours_driven,2)
~alter(hours_driven_total,2)
}
{quest_completion==true:
~finished_quest_on_weds=true
}

~day_end()
~ timestamp=1502352000
# button
* [Start day 4] -> day_4_start

===day_4_start===
# day_4_start
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
~ took_day_off=true
->day_off

* [Keep working]
You need every penny you can earn.
->day_4_morning

=day_off
# day_4_start_day_off
You spend the day with your family. Your son is glad you made time for him, and you get some much needed rest. 
~helped_homework=true
{home=="sf":
~timestamp=1502438400 //Friday 9am
-else:
~timestamp=1502434800 // Friday 8am
}
    # button
    ** [An enjoyable day]
->day_5_start

=day_4_quest_easy
# day_4_start.day_4_quest_easy
It should be pretty easy to complete the last {quest_rides>1:few} ride{quest_rides>1:s} for the quest bonus.

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
->day_off

* [Keep working]
If you can't finish the quest, then it's even more important to earn more fares.->day_4_morning

===day_4_morning===
# link
# day_4_morning
As you head out, you remember that you promised your son to be home by {home=="sac":8pm}{home=="sf":7pm} to help him with his homework.
{home=="sac":
* [Drive in Sacramento today]
~ current_city = "sac"
-> day_4_sacramento

* [Go to San Francisco]You set off for SF, hoping to get more rides there.
~alter(day_hours_driven,2)
~alter(hours_driven_total,2)
~add_time(2,3)
~ current_city = "sf"
    # button
    **[🚗]
    {quest_rides>2:
    ->napa
    - else:
    ->day_4_sf_from_sac
    }
}

{home=="sf":
# button
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
~UberXL()
# button
*[🚗] You make it home in time to help your son with his homework, as you promised.
    ~helped_homework=true
->day_4_end
    
- quest_completion==false && quest_rides < 17:
    It shouldn't be too hard to complete {quest_rides} ride{quest_rides>1:s}, even in Sacramento.
    
    ~time_passes(9,0,1)
    # button
    *[🚗] 
    ->quest_finish->
    You make it home in time to spend the evening with your son as you promised.
    ~helped_homework=true
        # button
        **[Help with homework] You help him with his maths homework, and tuck him into bed when you're done.
            ->day_4_end
    ->day_4_end

- quest_completion==false && quest_rides > 25:
    With {quest_rides} more rides to go, you're unlikely to finish the quest, so you just take it easy today. 
    
    ~time_passes(9,0,1)
    # button
    *[🚗] 
    
    You make it home in time to spend the evening with your son as you promised.
        ~helped_homework=true
        # button
        **[Help with homework] You help him with his maths homework, and tuck him into bed when you're done.
            ->day_4_end

- else:
    It might be a stretch to do {quest_rides} rides, especially in Sacramento, but you give it a shot.
    ~ temp remaining=quest_rides-3
    NEXT SCREEN: You drive for 9 hours. During this time, you completed {remaining} rides, and earned ${remaining*6} in fares. Your driver rating is {rating/100} 
    ~ time_passing = true
    ~ alter(day_ride_count, remaining)
    ~ alter(day_fares_earned, remaining*6)
    ~ alter(day_hours_driven, 9)
    ~ alter(ride_count_total, remaining)
    ~ alter(fares_earned_total, remaining*6)
    ~ alter(hours_driven_total, 9)
    ~ add_time(9,18)
    ~ quest_rides=3

# button
*[🚗] 
->quest_nudge
}
===quest_nudge===
# link
# quest_nudge
MESSAGE FROM UBER: Just {quest_rides} more trip{quest_rides>1:s} until you complete your quest!
But you promised to be home by {home=="sac":8pm}{home=="sf":7pm}.

* [Keep driving]->keep_driving

* [Go home]->went_home


=keep_driving
# quest_nudge.keep_driving
You call home to say you won't be back. Your son is disappointed.
~ time_passing=true
~ alter(day_ride_count, quest_rides)
~ alter(day_fares_earned, 19)
~ alter(day_hours_driven, 2)
~ alter(ride_count_total, quest_rides)
~ alter(fares_earned_total, 19)
~ alter(hours_driven_total, 2)
~ add_time(2,3)
# button
*[🚗] 
It takes you two hours to finish the last {quest_rides} rides, but you finish the quest. You get ${quest_bonus}!
~ alter(fares_earned_total, quest_bonus)
~quest_completion=true
~quest_rides=0
~moments=true
{home=="sac" && current_city=="sf":
~ alter(day_hours_driven, 2)
~ alter(hours_driven_total, 2)
~ add_time(1,54)
}
    # button
    ** [Rush home]
    {
    - home=="sac" && current_city=="sf":You drive as quickly as you can to get back to Sacramento, but your son is already asleep by the time you get back. He didn't finish his homework.
    - home=="sf": Your son is already asleep by the time you get back. He didn't finish his homework.
    - home=="sac" && current_city=="sac": Your son is already asleep by the time you get back. He didn't finish his homework.
    }
    ->day_4_end

=went_home
# quest_nudge.went_home
You go home and help your son with his homework. He's happy you kept your promise.
~helped_homework=true
~timestamp=1502400600
# button
* [Tuck him into bed]
->son_asleep

=son_asleep
# quest_nudge.son_asleep
It's 10:30pm and you're tired after a long day, but the quest doesn't expire until 4am.
# link
* [Go back out]
-> go_back_out

* [Go to sleep] You're too exhausted.
->day_4_end

=go_back_out
# quest_nudge.go_back_out
You get back in your car and turn the app back on.
~ alter(day_fares_earned, 19)
~ alter(day_hours_driven, 2)
~ alter(day_ride_count, quest_rides)
~ alter(fares_earned_total, 19)
~ alter(hours_driven_total, 2)
~ alter(ride_count_total, quest_rides)
~ alter(fares_earned_total, quest_bonus)
~ add_time(2,8)
# button
*[🚗] 
It takes you two hours to finish the last {quest_rides} rides, but you finish the quest. You get ${quest_bonus}!
~quest_completion=true
~quest_rides=0
~moments=true
You are completely exhausted.
    # button
    ** [💤]
    ->day_4_end

===napa===
# link
# napa
Soon after you arrive, you get a long ride alert on your Uber app. Someone is requesting a trip that will take more than 45 minutes to complete.
* [Accept the ride]->napa_ride
* [Reject the ride]->day_4_sf_from_sac

=napa_ride
# napa.napa_ride
# link
You pick up some tourists who want to drive across the Golden Gate Bridge and go to Napa.
~ alter(fares_earned_total,265)
~ alter(ride_count_total,1)
~ alter(day_fares_earned,265)
~ alter(hours_driven_total,2)
~ alter(day_ride_count,1)
~ alter(quest_rides, -1)
~ alter(day_hours_driven,2)
~ add_time(1,49)
* [Put your favourite dance mix on Spotify]
* [Keep the car quiet and professional]

- The long trip turns out to be a mixed blessing. You're not much closer to finishing your quest, but it nets you $165 in fares, and $100 in tips!

~ current_city="sf"
# button
    **[Drive to SF]
->day_4_sf_from_sac

===day_4_sf_from_sac===
# day_4_sf_from_sac
~ temp remaining=quest_rides-3
By now, you've become used to the rhythm of the day and how this works.

{
- quest_completion==true:
    Without the pressure to finish the quest, you spend a pretty relaxing day driving.
    ~time_passes(5,0,1)
    ~UberXL()
    # button
    *[🚗] It's nearly 6. You head back to Sacramento to keep your promise to your son.
    
    ~ add_time(1,56)
    ~ alter(day_hours_driven,2)
    ~ alter(hours_driven_total,2)
    # button
    ** [Go home]
    ~helped_homework=true
    You spend a pleasant evening helping your son with his homework.
    -> day_4_end

- else:
    ~time_passes(5,0,1)
    ~UberXL()
    # button
    *[🚗]->time_to_go_home
}

=time_to_go_home
# day_4_sf_from_sac.time_to_go_home

{ 
- quest_completion==true:
->quest_finish->
    It's nearly 6. You head back to Sacramento to keep your promise to your son.
    ~ add_time(1,56)
    ~ alter(day_hours_driven,2)
    ~ alter(hours_driven_total,2)
    # button
    ** [Go home]
        ~helped_homework=true
        You spend a pleasant evening helping your son with his homework.
        -> day_4_end

- quest_completion==false && quest_rides < 7: 
    MESSAGE FROM UBER: Just {quest_rides} more trip{quest_rides>1:s} until you complete your quest!
    But you promised to be home by 8.
    # link
    * [Keep driving] ->keep_driving
    * [Go home] ->go_home

- quest_completion==false && quest_rides > 7: 
    It doesn't look like you'll be able to finish the quest. 
    ~ add_time(1,56)
    ~ alter(day_hours_driven,2)
    ~ alter(hours_driven_total,2)
    # button
    * [Go home]        
        ~helped_homework=true
        You spend a pleasant evening helping your son with his homework.
        ->day_4_end
}

=keep_driving
# day_4_sf_from_sac.keep_driving
You call home to say you won't make it back. Your son is disappointed.
{
- quest_rides== 5 || 6:
~time_passes(3,1,1)
- quest_rides== 3 || 4:
~time_passes(2,1,1)
- else:
~time_passes(1,1,1)
}
# button
*[🚗]->home_after_finishing_quest

=home_after_finishing_quest
# day_4_sf_from_sac.home_after_finishing_quest
You finished the quest! You get the ${quest_bonus} bonus.
~ quest_completion = true
~ alter(fares_earned_total, quest_bonus)
~ alter(day_hours_driven, 2)
~ alter(hours_driven_total, 2)
~ add_time(2,3)
# link
*[Feel good about finishing the quest]
*[Feel bad about breaking your promise]
You drive as quickly as you can to get back to Sacramento, but your son is already asleep by the time you get back. He didn't finish his homework.

# button
** [💤]
->day_4_end

=go_home
# day_4_sf_from_sac.go_home
~ add_time(1,56)
~ alter(day_hours_driven,2)
~ alter(hours_driven_total,2)
You get back in time to keep your promise.
~helped_homework=true
# button
*[Help with homework] You help your son with his maths homework, and tuck him into bed when you're done.
->day_4_end

===day_4_sf===
# button
# day_4_sf
{
- quest_completion==true:
You take it easy today.

~time_passes(9,0,1)
~UberXL()
# button
*[🚗] You make it home in time to help your son with his homework, as you promised.
    ~helped_homework=true
->day_4_end
    
- quest_completion==false && quest_rides < 19:
    It shouldn't be too hard to complete {quest_rides} ride{quest_rides>1:s}.
    
    ~time_passes(9,0,1)
    # button
    *[🚗] 
    ->quest_finish->
    You make it home in time to spend the evening with your son as you promised.
    ~helped_homework=true
        # button
        **[Help with homework] You help him with his maths homework, and tuck him into bed when you're done.
            ->day_4_end
    ->day_4_end

- quest_completion==false && quest_rides > 27:
    With {quest_rides} more rides to go, you're unlikely to finish the quest, so you just take it easy today. 
    
    ~time_passes(9,0,1)
    # button
    *[🚗] 
    
    You make it home in time to spend the evening with your son as you promised.
        ~helped_homework=true
        # button
        **[Help with homework] You help him with his maths homework, and tuck him into bed when you're done.
            ->day_4_end

- else:
    It might be a stretch to do {quest_rides} rides, but you give it a shot.
    ~ temp remaining=quest_rides-3
    NEXT SCREEN: You drive for 9 hours. During this time, you completed {remaining} rides, and earned ${remaining*6} in fares. Your driver rating is {rating/100} 
    ~ time_passing = true
    ~ alter(day_ride_count, remaining)
    ~ alter(day_fares_earned, remaining*6)
    ~ alter(day_hours_driven, 9)
    ~ alter(ride_count_total, remaining)
    ~ alter(fares_earned_total, remaining*6)
    ~ alter(hours_driven_total, 9)
    ~ add_time(9,18)
    ~ quest_rides=3

# button
*[🚗] 
->quest_nudge
}

===day_4_end===
# day_4_end

~timestamp=1502438400 //9am

It's the end of day 4.
{home=="sac":
~alter(hours_driven_total,2)
~alter(day_hours_driven,2)
}
Today, you drove for {day_hours_driven} hours, completed {day_ride_count} rides and earned ${day_fares_earned} in fares. Your driver rating is {rating/100}.

{ 
- quest_completion==true && finished_quest_on_weds==false:
 You finished the quest and netted a ${quest_bonus} bonus.
- quest_completion==true && finished_quest_on_weds==true:

- else:
You didn't finish the quest in time, and lose out on the ${quest_bonus} bonus.
}

~ day_ride_count=0
~ day_fares_earned=0
~ day_hours_driven=0
# button
*[Start day 5]->day_5_start

===day_5_start===
# button
# day_5_start
~current_city="sf"

It's Friday. You look forward to the lucrative weekend period.
{quest_completion==true:
~weekday_quest_completion=true
}
~quest_rides=65
~quest_bonus=150
~weekend_quest_bonus=quest_bonus

* NEW UBER QUEST[] 
"Drive {quest_rides} trips, make ${quest_bonus} extra. You have until Monday May 29, 4 am"
# button
** [Accept quest]

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

* [Start driving now] ->day_5_daytime

* [Start in the evening] You take a rest and try to nap a bit during the day.
~timestamp=1502474400 //7pm
    # button
    ** [💤]
-> day_5_evening_start

===day_5_daytime===
# day_5_daytime
You decide that it's not worth it to disrupt your normal schedule.

{home=="sac": 
You head into San Francisco at your usual hour.
~alter(day_hours_driven,2)
~alter(hours_driven_total,2)
~add_time(2,3)
~time_passes(7,0,1)
- else:
~time_passes(9,0,1)
}
# button
*[🚗]
->day_5_afternoon

===day_5_afternoon===
# day_5_afternoon
# link
You would normally finish up around now. {home=="sac":Especially since you you have a two hour drive to get back home.}

* [Go home]->go_home
* [Keep driving] ->keep_driving
* {gym_member} [Freshen up at the gym]->gym

=go_home
# day_5_afternoon.go_home
{home=="sac": 
~alter(day_hours_driven,2)
~alter(hours_driven_total,2)
~add_time(2,3)
    On the drive back, you wonder if you made the right decision.
    # link
    * It's important to keep to a routine[], you tell yourself.
    You arrive home.
    ->day_5_end
    * Probably should've stuck it out[], but it's too late now.
    You arrive home.
    ->day_5_end

- else:
    You stick with your routine and call it a day.
    -> day_5_end
}

=keep_driving
# day_5_afternoon.keep_driving
You decide to try to catch the evening crowd.
~time_passes(3,1,1)
# button
*[🚗] 
-> day_5_evening

=gym
# day_5_afternoon.gym
You take a break to shower and freshen up at the gym before continuing.
~time_passes(3,1,1)
# button
*[🚗]->day_5_evening

===day_5_evening_start===
# day_5_evening_start
//7pm
You're refreshed after resting during the day. {home=="sac":You leave for San Franciso after dinner at home.}

{home=="sac":
~alter(day_hours_driven,2)
~alter(hours_driven_total,2)
~add_time(2,3)
}
~ time_passes(2,1,1)
# button
*[🚗]->day_5_evening


===day_5_evening===
# day_5_evening
//9pm
As you drop off a passenger in the Financial District in the northeast of San Francisco, you notice there's surge pricing in the Sunset district. 

The 3x fare is attractive, but Sunset is 30 minutes away. 

# link

* [Chase the surge]->chase_surge 

* [Don't chase the surge] ->no_surge

=chase_surge
# surge.chase_surge
Tripling your earning is just too tempting. You start driving over to the surge zone.
    ~add_time(0,32)
# button
* [Try to get there as fast as possible] The roads are busy and the traffic lights are not on your side tonight. You are three blocks away when the surge ends. 
~time_passes(3,1,1)
    # button
    **[Darn]
->home_or_not

=no_surge
# surge.no_surge
'It'll probably be gone by the time you get there,' you think to yourself.
    # button
~time_passes(3,1,1)
*[Keep driving]
->home_or_not

===home_or_not===
# link
# home_or_not
//midnight
{
- day_5_daytime && gym_member==false && home=="sac":
    You finally have time for a break. You're dead tired after driving for more than 12 hours straight.
        
    * [Go home]->forced_home
    * [Sleep in your car]->sleep_in_car

- day_5_daytime && gym_member==false && home=="sf":
    # button
    * [Go home]->forced_home
- day_5_daytime && gym_member==true:
    You finally have time for a break. You're dead tired after driving for more than 12 hours straight.
    * [Keep driving]->vomit
    * [Go home]->forced_home
    * {home=="sac"}[Sleep in your car]->sleep_in_car
- else:
    You finally have time for a break. Night time driving is more tiring than you expected.
    * [Keep driving]->vomit
    * [Go home]->forced_home
    * {home=="sac"}[Sleep in your car]->sleep_in_car
}

===forced_home===
# forced_home
{home=="sf":
You're too tired. You call it a night, and drive back home.
->day_5_end
- else:
You can barely keep your eyes open on the way back to Sacramento
~ add_time(2,7)
~ alter(day_hours_driven, 2)
~ alter(hours_driven_total, 2)
# button
* [Take a short nap] You pull over and take a short nap. Eventually you make it home.
->day_5_end
}

===sleep_in_car===
# sleep_in_car
# button
You're too tired to drive two hours to go back home. You find a quiet spot to park.
~ overnight = true
~timestamp=1502524800
*[💤] It's not very comfortable, but you eventually fall asleep.
~day_end()
    # button
    ** [Start day 6]
    -> day_6_slept_in_car

===vomit===
# link
# vomit
You arrive at a pick up and see a passenger vomiting on the side of the road.

* [Cancel and drive away] You decide it's not worth it. 
    # link
    ** [Keep driving]
    ->day_5_late_night
    ** [Call it a night]
    ->forced_home
    ** {home=="sac"}[Sleep in your car]
    ->sleep_in_car

* [Let her in]->vomit_ride

=vomit_ride
#vomit.vomit_ride

You let her get in and drive to her destination. 
~add_time(0,18)
# button
* [🚗] As she is getting out, the passenger vomits out the window. Ugh!
-> cleanup

=cleanup
# vomit.cleanup

{cleaning_supplies==true:
~add_time(0,18)
- else:
~add_time(0,58)
~alter(day_hours_driven,1)
~alter(hours_driven_total,1)
~alter(fares_earned_total,-30)
}
# button
*[😷]

{ cleaning_supplies==true: 
Luckily, you have cleaning supplies in your trunk. You pull over and spend some time cleaning up.

- else: You don't have any cleaning supplies, and spend some time looking for a gas station with a convenience store to buy some. You eventually clean it all up.

}
    # link
    ** [Notify Uber]
    Uber gives you $30 in cleaning fees.
    ~alter(fares_earned_total,30)
        # button
        *** [💵]->day_5_late_night
    ** [Don't notify Uber]->day_5_late_night

===day_5_late_night===
# link
# day_5_late_night
{day_5_daytime:
You are so tired you can't drive anymore.

    {home=="sf":
    ->day_5_end
    - else: ->sleep_in_car
    }

- else:
~time_passes(2,1,1.3) 
The late hours are certainly lucrative.
# button
* [🚗]->day_5_late_late
}

===day_5_late_late===
# day_5_late_late
# link
It's getting really late.

* [Keep driving] Are you sure you want to keep driving? You can barely keep your eyes open.
    # link
    ** [Keep driving]->insist
    ** [Go home]->bed

* [Go home] 
{home=="sf": 
->day_5_end
- else: You start driving home but you're too tired.
    # button
    **[Sleep in your car]->sleep_in_car
} 

* {home=="sac"}[Sleep in your car]->sleep_in_car

=bed
# day_5_late_late.bed
{home=="sf": 
You go home for some much needed sleep.
->day_5_end
- else: You start driving home but you're too tired.
# button
*[Sleep in your car]->sleep_in_car
}

=insist
# day_5_late_late.insist
You're really tired but decide to keep going.

In your next ride, the passenger complains that you seem sleepy behind the wheel. Uber immediately deactivates you, without telling you the reason.
~ moments=true
# button
*[Oh no!]
->what_to_do

=what_to_do
# day_5_late_late.what_to_do
What do you do?
# link
*[Contact Uber] You call Uber to contest your deactivation. You spend nearly an hour on the phone, but all you get is a promise that they'll look into it.
    ~add_time(0,44)
# button
    **[Go home]
    {home=="sf":
    You drive home and collapse into bed.
    ~day_end()
    ~timestamp=1502528400
    //saturday 9am
        # button
        *** [💤]->day_6_deactivated
    }
    {home=="sac":
    You're too tired to drive back. You find a quiet spot to park and spend an uncomfortable night sleeping in your car.
    ~day_end()
    ~timestamp=1502528400
    //saturday 9am
        # button
        *** [💤]->day_6_deactivated
    }
*[Don't contact Uber] You're too tired to try to sort this out over the phone right now.
    **[Go home]
    {home=="sf":
    You drive home and collapse into bed.
    ~day_end()
    ~timestamp=1502528400
    //saturday 9am
        # button
        *** [💤]->day_6_deactivated
    }
    {home=="sac":
    You're too tired to drive back. You find a quiet spot to park and spend an uncomfortable night sleeping in your car.
    ~day_end()
    ~timestamp=1502528400
    //saturday 9am
        # button
        *** [💤]->day_6_deactivated
    }

===day_5_end===
# day_5_end
~timestamp=1502524800
//sat 9am
~day_end()
# button
* [Start day 6]
->day_6_start

===day_6_deactivated===
# link
# day_6_deactivated
//saturday 9am
It's Saturday. 
{home=="sac": You wake up, briefly forgetting that you're in your car in San Francisco.}

You {home=="sf":wake up and }check your Uber app to find that you're still deactivated. You decide to make the most of your enforced day off.

->day_6_off

===day_6_off===
# day_6_off
# link
~timestamp=1502573400
//sat 10:30pm
~took_day_off=true
* [Spend time with your son]
You spend a relaxing afternoon in the park with your son. It sure feels good to not have to sit in a car all day. 

{helped_homework==false: Your son was still mad at you for letting him down on Thursday, but brightened up significantly by the end of the day.}

* [Hang out with your friends]
You spend a relaxing day with your friends. It sure feels good to not have to sit in a car all day. 

* [Do laundry and other chores]
You finally have some much-needed time to clean up around the house, and spend time with your son.

{helped_homework==false: Your son was still mad at you for letting him down on Thursday, but brightened up significantly by the end of the day.}


- You feel refreshed.
# button
** [Start day 7]
->day_7_start


=== day_6_slept_in_car ===
# day_6_slept_in_car
You wake up, briefly forgetting that you're in your car in San Francisco.

->day_6_start

=== day_6_start===
# link
# day_6_start
It's Saturday. Do you take the day off? It is the weekend, after all.

* [Take day off] You decide to take the day off.
->day_6_off
* [Go to work]
->day_6_work

=== day_6_work ===
# day_6_work
//9am
MESSAGE FROM UBER: 
The San Francisco Giants are playing at AT&T park today. Earn a boosted 1.5x fare for trips from there, from 5pm-6:30pm today 
~ time_passes(3,0,1)
# button
*[Got it]


->door_dent

=== door_dent ===
# link
# door_dent
As you finish a ride, the passenger opens the door to get out and hits a lamp post, denting your car door. He is apologetic, but in a rush, and tells you to resolve it with Uber.

*[Report the incident to Uber] You document everything and report the incident to Uber. Uber begins the claim process, but in the meantime your account is suspended.
    ~timestamp=1502571600
    # button
    **[🔧]
    ->reported

*[Don't report it] You decide to get it repaired yourself.
~add_time(2,21)
~alter(repair_cost,100)
    # button
    **[🔧] It takes the mechanics two hours to fix it, and they charge you $100. You put it on your credit card.
        ~ time_passes(3,0,1)
        # button
        ***[Keep driving]
        ->day_6_afternoon
        
=reported
# door_dent.reported
# button
You spend the rest of the day getting your car fixed and arranging for a different rental car so you can get back on the road.
*[End day 6]
-> day_6_end

=== day_6_afternoon ===
# link
# day_6_afternoon
//5:30pm
You hear on the radio that the baseball game has just ended.

* [Head over to the stadium]

You make your way to the baseball stadium before the game ends.
Sure enough, lots of people are requesting rides there. 
    ~ alter(day_ride_count, 1)
    ~ alter(ride_count_total, 1)
    ~ alter(quest_rides, -1)
    ~ alter(day_fares_earned, 30)
    ~ alter(fares_earned_total, 30)
    ~add_time(0,48)
# button
** [Great!] You get lucky with a relatively long ride to Outer Richmond, and earn a boosted $30.
->day_6_evening

* [Don't head over] You decide to ignore it.

->day_6_evening

=== day_6_evening ===

# day_6_evening
It sure is busy this Saturday evening.
~time_passes(3,1,1)
# button
*[Time to make some money]
->day_6_go_home

===day_6_go_home===
# day_6_go_home

{day_6_slept_in_car:
You can't wait to go home after two days out driving.
~ add_time(2,7)
~ alter(day_hours_driven, 2)
~ alter(hours_driven_total, 2)
# button
* [End day 6] 
->day_6_end
- else:
-> day_6_end
}

=== day_6_end ===
~timestamp=1502614800
//sun 9am

# day_6_end
~ day_end()
# button
* [Start day 7]
->day_7_start

===day_7_start===

# day_7_start

{door_dent.reported: You manage to get a different {car}, and Uber has reactivated your account.}

It's Sunday! You still need {quest_rides} more rides to get the weekend bonus.
# button
~time_passes(3,0,1)
*[Let's do this!]

->no_drop_zone

=== no_drop_zone===
# link
# no_drop_zone
A passenger insists you drop her off at the entrance to the Caltrain station, which is a no-stop zone.
* [Agree to do so]
~ temp ticket = RANDOM(1,3)
{ticket>1: 
You drop her off quickly. Luckily, there weren't any cops around.
    ~time_passes(3,0,1)
    # button
    ** [Phew!]->track_mileage
- else: ->caught
}

* [Refuse] You stop nearby and explain why you cannot drop her off at the entrance. She's not convinced.
~ time_passes(3,0,1)
    # button
    **[Insist]
    She slams the door as she gets out.
    ->track_mileage

=caught
# no_drop_zone.caught
As you drop her off, you see a police car pull up behind you. 
~ticketed=true
~ alter(ticket_cost,260)

# button
*[🚓]
You get a traffic ticket (-$260). You'll have to go pay that later.
~ time_passes(3,0,1)
    # button
    **[That's a real setback]
    ->quest_finish->
    ->track_mileage
=== track_mileage ===
# track_mileage

It's been a long week. You idly wonder just how far you've driven.

# link
* [Good thing you've been keeping track] {home=="sf": You check your notes: 869 miles. That's quite a lot.}{home=="sac":You check your notes: 1567 miles. That's quite a lot.}
~miles_tracked=true

* [Who cares]It doesn't really matter.
~miles_tracked=false

- ->day_7_afternoon

===day_7_afternoon===

# day_7_afternoon
~time_passes(3,0,1)
# button
* [🚗]
->quest_finish->
{windshield_cracked==true:
->pebble_crack->
}

{quest_completion==true:
Having finished the quest, you decide to call it a day.
# button
*[Finish driving] 
->day_7_end
- else:
# button
*[Keep driving]
->day_7_evening
}

===pebble_crack===
# button
# pebble_crack
You are driving when you hear a splintering sound. The chip in your windshield has cracked across the whole windshield. You have no choice but to get it repaired
~alter(repair_cost,-250)
~add_time(1,58)
* [The mechanic charges you $250]You put it on your card, regretting that you didn't get it fixed earlier.

->->

===day_7_evening===
# link
# day_7_evening
{
-quest_rides < 7 && quest_completion==false:
    MESSAGE FROM UBER: Just {quest_rides} more trip{quest_rides>1:s} until you complete your quest!
    # button
    ~time_passes(3,0,1)
    *[Finish the quest]
    Congrats! You completed the quest and got an extra ${quest_bonus}.
    ~quest_completion=true
    ~moments=true
    ->day_7_end

- quest_rides>=10:
    You still need too many more rides to complete the quest. There's not much you can do about it, so you head home.
    ->day_7_end
}

===day_7_end===

# day_7_end
~day_end()
{quest_completion==true:
~weekend_quest_completion=true
}
# button
*[Finish the week]
->end_sequence

===end_sequence===
# end_sequence
It's the end of the week. Were you savvy enough to survive as a full-time Uber driver?
# button
*[See how you did]
->results_revenue


===no_phone_mount===
# no_phone_mount
With no phone mount, you're left fiddling with your phone on your lap. A passenger notices and complains to Uber about your dangerous driving.
~add_time(4,0)
~phone_mount=true 
~alter(accessories_cost,25)
~moments=true
{sac_morning:
~current_city="sf"
}
#button
* [Uh oh] You are deactivated for 4 hours. You use that time to buy a phone mount and charging cables for $25 {sac_morning:and make your way to SF}.
->->

===data_plan===
# link
# data_plan
You get a message from your phone provider: You've reached your data limit this month. 
*[Upgrade to an unlimited data plan ($20/week)]

~unlimited_data=true
~alter(accessories_cost,20)
*[Let it go to overage charges($30/week)]
~alter(accessories_cost,30)
- ->nice_passenger


===results_revenue===
# button
# results_revenue
~ revenue_total=fares_earned_total
This week, you drove for {hours_driven_total} hours, completed {ride_count_total} rides, and had a driver rating of {rating/100}

You earned ${fares_earned_total} in fares and tips. {car=="minivan": Of this, ${XL_total} were extra fares from UberXL rides.} 
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
You didn't finish either quest.
}

{revenue_total>=1000: 
You made ${revenue_total} in total, exceeding your $1000 target.

- else: You made ${revenue_total} in total, and were ${1000-revenue_total} off from your target of making $1000 in a week.
}

* [How much did I really make?]
->results_costs


===results_costs===
# button
# results_costs

~ temp days=0
~ tax_cost=revenue_total/10
~ temp income=revenue_total

{saturday_off:
~ days=6
- else:
~ days=7
}
{
- car=="minivan" && home=="sf":
~gas_cost=days*25

- car=="minivan" && home=="sac":
~gas_cost=days*30

- car=="Prius" && home=="sf":
~gas_cost=days*15

- car=="Prius" && home=="sac":
~gas_cost=days*20
}
To get a true picture of what you earned as an Uber driver, you also have to take into account your costs.

Renting your {car} and buying insurance cost ${car_cost}.
~alter(cost_total,car_cost)

You spent ${gas_cost} on gas. {car=="Prius":You saved a lot on gas costs by choosing the Prius over the minivan.} 
~alter(cost_total,gas_cost)
You spent ${accessories_cost} buying other gear and services.
~alter(cost_total,accessories_cost)
You also have to file your taxes. {miles_tracked==true: Fortunately, since you tracked your mileage {kept_receipt==true:and kept your gas receipts}, you were able to deduct enough expenses so you don't have to pay any tax.}
{miles_tracked==false: 
Unfortunately, since you weren't diligent about tracking your miles {kept_receipt==false:, or keeping your gas receipts}, your tax bill comes to ${tax_cost}. 
~alter(cost_total,tax_cost)
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


