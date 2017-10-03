INCLUDE functions

//Set-up variables 
VAR car="Prius"
VAR home="sf"
VAR credit_rating="good"
VAR timestamp=1502092800
// start time: Monday, August 7, 2017 8:00:00 AM GMT
VAR go_to_endscreen=false

//accessories variables
VAR unlimited_data=false
VAR phone_mount=false
VAR cleaning_supplies=false
VAR biz_licence=false
VAR gym_member=false

//Vital stats variables
VAR current_city="sf"

VAR day_ride_count=0
VAR day_fares_earned=0
VAR day_hours_driven=0
VAR rating=500
VAR ride_count_total=0
VAR fares_earned_total=0
VAR hours_driven_total=0
VAR UberXL_total=0

VAR kept_receipt=false
VAR windshield_cracked=false
VAR ticketed=false
VAR saturday_off=false

// Quest variables
VAR quest_rides=75
VAR quest_bonus=180
VAR quest_completion=false
VAR weekday_quest_completion=false
VAR weekday_quest_bonus=180
VAR weekend_quest_completion=false
VAR weekend_quest_bonus=150
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
VAR days_worked=0
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

->dev_mode
===dev_mode===
* [goto first fare] ->day_1_locate_passenger.driving
* [goto time passing]
~home="sac"
~current_city="sac"
~quest_rides=64
~quest_bonus=180
->sac_morning
* [goto deactivated phone mount]
~home="sac"
~current_city="sf"
->day_1_sac_afternoon_in_sf
* [goto deactivated friday night]->day_5_late_late.insist
* [goto weekday quest complete]
~ quest_rides=6
~ quest_bonus=180
->quest_nudge.keep_driving
* [goto weekend quest complete]
~ quest_rides=6
~ quest_bonus=150
->day_7_evening
* [goto end]
~fares_earned_total=RANDOM(700,1600)
~hours_driven_total=RANDOM(60,140)
~ride_count_total=RANDOM(120,220)
~rating=RANDOM(460,500)
~ weekday_quest_completion=true
~ weekday_quest_bonus=180
~ weekend_quest_completion=true
~ weekend_quest_bonus=150
~ car_cost=180
~ gas_cost=RANDOM(160,300)
~ accessories_cost=90
~ repair_cost=140
~ took_day_off=true
->end_sequence
*[goto start]
->welcome


=== welcome ===
# welcome
You're a full-time Uber driver with two kids to support, and a $1000 mortgage payment coming due in a week. 

Can you earn enough to pay the bill — and make more than other players?  
# button
* [Yes]
->choose_difficulty


=== choose_difficulty===
Your difficulty level will affect how easy it is to earn $1000.

Easier difficulty: You live in San Francisco and have good bank credit, so it is cheaper for you to rent a car. 

Harder difficulty: You have a bad credit rating and can't afford to live in San Francisco. Instead, you live two hours away in Sacramento.
# link 
# choose_difficulty
* [Easier]
~ home="sf"
~ credit_rating="good"
~ current_city=home

->day_1_start

* [Harder]
~ home="sac"
~ credit_rating="bad"
~ current_city=home

->day_1_start

/*
=confirm
# choose_difficulty.confirm
# link
{home=="sf":Choose the easier difficulty?}
{home=="sac":Choose the harder difficulty?} 

+ [Go back]
->choose_difficulty
+ [Yes]
->day_1_start
*/

=== day_1_start ===
# day_1_start
# bg:chris_start
You start bright and early on a Monday morning. Pretty soon, you get your first ride request, from a “Chris”. <>

->day_1_locate_passenger

===day_1_locate_passenger===
# link
# day_1_locate_passenger
But when you arrive at the pick-up point, you don't see anyone waiting for a ride. What do you do?
~add_time(0,5)

* [Call Chris]->call_chris
* [Wait]->chris_arrives

=call_chris
# link
# day_1_locate_passenger.call_chris
A man's voice answers the phone. “I'll be right there. Just coming out now,” he says.
~ add_time(0,3)
* [“Hurry up, will you?”]
* [“Take your time!”]
- ->chris_arrives

=chris_arrives
# button
# day_1_locate_passenger.chris_arrives
# bg:chris_arrives
A few minutes later, a flustered man with a big backpack comes out of a nearby apartment.

* [“Are you Chris?”]
->in_car

=in_car
# link
# day_1_locate_passenger.in_car
# bg:chris_start
“That's me. Sorry about being late,” he says as he gets in the car.
~ add_time(0, 20)
* [Drive in silence] You start driving. Chris checks his phone.
* [Strike up a conversation] “Going camping?”
“Yeah,” Chris replies. “Meeting up with a friend, then we're driving to this amazing place in Marin. Lemme tell ya…”
- ->driving

=driving
# button
# day_1_locate_passenger.driving
Twenty minutes later, you arrive at his destination.
~alter(fares_earned_total,16)
~alter(day_fares_earned,16)
~alter(day_ride_count,1)
~alter(ride_count_total,1)
~alter(quest_rides,-1)
* [Drop him off] 
->drop_off
=drop_off
# day_1_locate_passenger.drop_off
“Thanks! Sorry again for making you wait,” he says as he gets out. You mark the ride as complete on the Uber app.
~ moments=true
# button
# first_fare
** [That was easy]
->car_choice

=== car_choice ===
# link
# car_choice
# bg:choose_car
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

You're going to be spending a lot of time in your car. What model do you lease?
 
+ [Toyota Prius] 
The Prius is fuel efficient, getting up to 50 miles per gallon. {credit_rating == "good":Your good credit rating means it only costs ${prius_cost} per week.}{credit_rating=="bad":Unfortunately, your poor credit means it costs ${prius_cost} per week.}
~ car="Prius"
~ alter(car_cost, prius_cost)
->confirm

+ [Dodge minivan]
The Dodge minivan qualifies for UberXL rides, which earn higher fares.  {credit_rating == "good":Your good credit rating means it only costs ${minivan_cost} per week.}{ credit_rating=="bad":Unfortunately, your poor credit means it costs ${minivan_cost} per week.}
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
{!To prepare for life as a professional driver, you buy...|What else do  you buy?|You also buy...|Do you need anything else?}

* [Unlimited data plan ($20/week)]Since you always have to be connected to the Uber app, an unlimited data plan will save you from paying overage charges. 
    ~unlimited_data=true
    ~alter(accessories_cost,10)
    ->buy_accessories
* [Phone mount & charging cords ($25)]A phone mount lets you use your phone with one hand while keeping your eyes on the road. And you don't want to run out of batteries.
    ~phone_mount=true
    ~alter(accessories_cost,25)
    ->buy_accessories
* [Cleaning supplies ($20)]In case someone makes a mess in your car 
    ~cleaning_supplies=true
    ~alter(accessories_cost,20)
    ->buy_accessories
* [Business license ($91)]You are, after all, technically running a business as an independent contractor. 
    ~biz_licence=true
    ~alter(accessories_cost,91)
    ->buy_accessories
* [Gym membership ($10/week)]Having a gym membership gives you a place to shower.
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
 {unlimited_data:• Unlimited data plan}
 {phone_mount:• Phone mount}
 {cleaning_supplies:• Cleaning supplies}
 {biz_licence:• Business licence}
 {gym_member:• Gym membership}
// {tip_sign:Tip sign}

It cost ${accessories_cost}. You put it on your credit card so you don't have to pay right away.

} 
# button
** [All set]
-> sf_or_sacramento

=== sf_or_sacramento ===
# sf_or_sacramento
{
- home=="sf":
->day_1_sf

- home=="sac":->day_1_sacramento
}

===weekday_quest_message===
# weekday_quest_message
MESSAGE FROM UBER: “Uber Quest: Drive 75 trips, make ${quest_bonus} extra. You have until 4am on Friday”

# button
* [Accept quest]

->->

=== day_1_sacramento ===
# link
# day_1_sacramento
# bg:driving_sac
You live in Sacramento, where fares are a third less than in a bigger city like San Francisco. Do you drive 2 hours to work in SF instead?

* [Try your luck in SF]
->go_to_sf

* [Stay in Sacramento]
->weekday_quest_message-> sac_morning

= go_to_sf
# button
# day_1_sacramento.go_to_sf
# bg:main
~ add_time(2,0)
~ add_ride(1)
~ alter(day_fares_earned, 56)
~ alter(day_hours_driven, 2)
~ alter(fares_earned_total, 56)
~ alter(hours_driven_total, 2)
~ current_city="sf"
You keep the app on, and score a ride that takes you all the way into San Francisco.

* [You just made $56!]
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
# bg:driving_sf
~alter(rating,-5)
*[🚗&nbsp;&nbsp;Drive]
{phone_mount==false: ->no_phone_mount->day_1_sac_evening_in_sf_mount}

->day_1_sac_evening_in_sf

===day_1_sac_evening_in_sf===
# day_1_sac_evening_in_sf
# link
# bg:lunch_sf
{sac_morning:
After driving for so long, you're starting to get hungry.

-else: Coming to SF was definitely the right decision. But after driving for so long, you're starting to get hungry.
}

~add_time(0,30)
* [🌯&nbsp;&nbsp;Burrito] You go for burritos.
* [🍕&nbsp;&nbsp;Pizza] You grab a quick slice of pepperoni.

- ->day_1_sac_night_in_sf

===day_1_sac_evening_in_sf_mount===
# day_1_sac_evening_in_sf_mount

You get back online just in time for the busy evening period. 
~time_passes(2,0,1)
# button
# bg:driving_sf
*[🚗&nbsp;&nbsp;Drive]
->day_1_sac_night_in_sf

===day_1_sac_night_in_sf===
# day_1_sac_night_in_sf
# link
It's getting late and you have a two-hour drive to get back home.

* [That's enough for today]->go_home
* {!gym_member} [Keep driving]->keep_driving
* {gym_member} [Freshen up at the gym]->gym

=go_home
# day_1_sac_night_in_sf.go_home

It's been a long day, and you don't want to burn out too quickly.
~add_time(2,4)
~ alter(day_hours_driven, 2)
~ alter(hours_driven_total, 2)
# button
# bg:home
*[Drive home]
->day_1_end

=keep_driving
# day_1_sac_night_in_sf.keep_driving
You're tired and dirty. You might have been able to drive for longer if you had somewhere to shower in the city, like a gym. 
~add_time(2,4)
~ alter(day_hours_driven, 2)
~ alter(hours_driven_total, 2)
# button
*[Drive home]
->day_1_end

=gym
# day_1_sac_night_in_sf.gym

You take a shower at the gym. Feeling refreshed, you keep driving for just a while longer.
~time_passes(2,1,1)
# button
# bg:gym
*[🚗&nbsp;&nbsp;Drive]
->go_home

===sac_morning===
# day_1_sacramento.sac_morning

~time_passes(4,0,1)
You start driving.
# button
# bg:driving_sac
*[🚗&nbsp;&nbsp;Drive]
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
# day_1_sacramento.sac_lunch

You like driving in a familiar town, especially since it means you can get lunch at your favourite Tex-Mex restaurant.
{phone_mount==true: 
~time_passes(4,0,1)
}
# link
# bg:lunch_sac
* [🌯&nbsp;&nbsp;Burritos]
* [🌮&nbsp;&nbsp;Tacos]
- ->sac_afternoon

=sac_afternoon
# day_1_sacramento.afternoon
{phone_mount==false:
->no_phone_mount->stay_or_go_2
}

->stay_or_go_2

=stay_or_go_2
# link
# day_1_sacramento.stay_or_go_2
# bg:driving_sac
It's 4pm, and you've only earned ${day_fares_earned}.
* [Call it a day] You head home, in time for dinner.-> day_1_end
* [Keep going] Things should pick up during rush hour and dinner time. ->sac_late_afternoon
* [Go to San Francisco] By this point, it doesn't really make sense to make the two-hour trip to SF. You stay in Sacramento, regretting that you didn't go earlier.->sac_late_afternoon

=sac_late_afternoon
# day_1_sacramento.sac_late_afternoon
~time_passes(3,0,1)
# button
*[🚗&nbsp;&nbsp;Drive]->sac_evening

=sac_evening
# day_1_sacramento.sac_evening
# link
# bg:home
It's getting late, and you don't want to burn out too quickly.

* [Call it a day]->day_1_end


=== day_1_sf ===
# day_1_sf
# bg:driving_sf
MESSAGE FROM UBER: “Uber Quest: Drive 75 trips, make ${quest_bonus} extra. You have until 4am on Friday”

You accept the quest, excited at the prospect of exploring San Francisco while earning some money.

~time_passes(4,0,1)
# button
# bg:driving_sf
* [🚗&nbsp;&nbsp;Drive] 

->day_1_sf_morning

===day_1_sf_morning===
# link
# day_1_sf_morning
# bg:lunch_sf
That was a productive morning! You decide to stop for lunch.
~add_time(0,30)
* [🌯&nbsp;&nbsp;Burrito] You enjoy a burrito from Señor Sisig food truck before continuing on.
* [🍕&nbsp;&nbsp;Pizza] You grab a quick slice of pepperoni before getting back on the road.
- ->day_1_sf_afternoon

===day_1_sf_afternoon===
# day_1_sf_afternoon

{phone_mount==false:
->no_phone_mount->day_1_sf_evening_mount
- else:

~time_passes(5,0,1)
# button
# bg:driving_sf
*[Back to driving]

->day_1_sf_keep_going
}

===day_1_sf_evening_mount===
# day_1_sf_evening_mount
You get back online just in time for the busy evening period.
~time_passes(2,1,1)
# button
*[🚗&nbsp;&nbsp;Drive]

->airport_incident
 
 ===airport_incident===
# airport_incident
You are driving a passenger to the airport when you miss the freeway exit. She gets very angry, saying: “Do I need to drive for you?”
~alter(rating,-15)
#link
# bg:airport
* [“Sorry!”] But you stew over the remark. Especially when you see she gave you a bad rating.
* [Argue] You almost get into a shouting match with the woman as you find your way back to the airport.
- ->low_rating

=== low_rating ===
# low_rating
Your rating is getting low. If it falls below 4.6, you might be placed under review.
# link
* [Try extra hard to be nice and to drive carefully]Your emotional labour pays off, but leaves you feeling more tired at the end of the day.
    ~alter (rating, 7)
* [Stock amenities ($20)]You spend $20 buying water bottles and mints for your passengers.  You're not really sure if they'll have a big impact.
    ~alter (rating, 3)
    ~alter (accessories_cost,30)
* [Don't worry about it]It's not like you earn more money with a higher rating anyways.
- ->day_1_sf_keep_going
 
===day_1_sf_keep_going===
# day_1_sf_keep_going

It's getting late, and you don't want to burn out too quickly.
# link
# bg:driving_sf
* [Go home]->day_1_end

===no_phone_mount===
# no_phone_mount

With no phone mount, you're left fiddling with your phone on your lap. Your passenger notices and complains to Uber about your dangerous driving.
~add_time(4,0)
~phone_mount=true 
~alter(accessories_cost,25)
~moments=true
{sac_morning:
~current_city="sf"
}
~alter(rating,-10)
# button
# deactivation
# bg:main
* [Uh oh] You are deactivated for 4 hours. You use that time to buy a phone mount and charging cables for $25 {sac_morning:and make your way to San Francisco}.
->->

===day_1_end===
# day_1_end

It's the end of the first day.
~ timestamp=1502179200
~day_end()
~alter(days_worked,1)
# button
# bg:night
*[Start day 2]
->day_2_begin

=== day_2_begin ===
# day_2_start
It's Tuesday. Your back aches from having spent the whole day in the car yesterday.
# button
# bg:main
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

*[Yes] You keep it in a folder for your expenses. You also take some time to track your mileage, so you can claim tax deductions later.
~kept_receipt=true
*[No] You don’t have time to keep track of stuff like that.
~kept_receipt=false
- ->day_2_midpoint

===day_2_midpoint===
# day_2_midpoint
You turn on your Uber app and start driving.
~time_passes(3,0,1)
~ UberXL()
# button
# bg:driving_sf
*[🚗&nbsp;&nbsp;Drive]
->surge

===surge===
# surge
As you drop off a passenger in the Financial District in the northeast of San Francisco, you notice there's surge pricing in the Sunset District. 
The 3x fare is attractive, but Sunset is 30 minutes away. 

# link
# bg:main
* [Chase the surge]->chase_surge 

* [Don't chase the surge] ->no_surge

=chase_surge
# surge.chase_surge
Tripling your earnings is just too tempting. You start driving over to the surge zone. 

But the roads are busy and the traffic lights are not on your side tonight. You are three blocks away when the surge ends. You've just wasted half an hour.
~add_time(1,0)  
~time_passes(4,0,1)

# button
*[Darn]
->day_2_evening

=no_surge
# surge.no_surge
“It'll probably be gone by the time I get there,” you think to yourself.
    # button
~time_passes(5,0,1)

*[Keep driving]
->day_2_evening

===day_2_evening===
# day_2_evening
# link
# bg:main
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
*[🍲&nbsp;&nbsp;Dinner]
->day_2_end

=keep_working
#day_2_evening.keep_working

Work is more important. You say you can't make it.
~time_passes(2,0,1)
~alter(day_hours_driven,2)
~alter(hours_driven_total,2)
#button
#bg:driving_sf
*[🚗&nbsp;&nbsp;Drive] You turn off the app for a bit to stop the car and stretch your aching legs, but a wave of exhaustion hits you. You decide to call it a day.
->day_2_end
=== day_2_end ===
# day_2_end
~timestamp=1502278740 //Weds 11:39am

{home=="sac":
~timestamp=1502278740 //Weds 11:39am
The two-hour drive back to Sacramento is long and boring.

}

~day_end()
~alter(days_worked,1)
# button
# bg:night
* [Start Day 3]

-> day_3_start

=== day_3_start ===
# day_3_start
It's Wednesday. You wake up to find the sun bright in the sky, and your phone's clock showing 11:39am. You must've slept clean through your alarm.
#button
#bg:main
* [Start working]
You're feeling less tired after a good night's sleep, and more confident getting behind the wheel. 
{home=="sac":
You head over to San Francisco. <> 
~alter(day_hours_driven,2)
~alter(hours_driven_total,2)
~add_time(1,48)
}
~current_city="sf"
->pebble_start

===pebble_start===
# link
# pebble_start
~add_time(0,19)
As you drive along the highway, a pebble hits your windshield and leaves a chip.
#bg:pebble
* [Repair it immediately ($30)]
->repair->day_3_morning

* [Ignore it]
->ignore

=repair
# button
# pebble_start.repair
You find a nearby auto shop. They take an hour to fix your windscreen, and charge you $30. You put it on your credit card.
~alter(repair_cost,30)
~add_time(1,0)

{unlimited_data==false:
~time_passes(2,0,1)
- else:
~time_passes(4,0,1)
}
* [🔧&nbsp;&nbsp;Repair]

->->

=ignore
# pebble_start.ignore
It's just a small chip, and you don't want to spend the time and money repairing a car you leased.
~ windshield_cracked=true
{unlimited_data==false:
~time_passes(2,0,1)
- else:
~time_passes(4,0,1)
}
# button
*[🚗&nbsp;&nbsp;Drive]
->day_3_morning

===day_3_morning===
# day_3_morning

{unlimited_data==false:
->data_plan
- else:
->nice_passenger
}

===data_plan===
# data_plan
You get a message from your phone provider: You've exceeded your data limit.

In retrospect, maybe you should've upgraded to the unlimited data plan.
~alter(accessories_cost,30)
~time_passes(2,0,1)
#bg:main
#button
*[Incur overage charges ($30/week)]

- ->nice_passenger

->nice_passenger
===nice_passenger===

# nice_passenger
~add_time(0,18)
You pick up a friendly passenger and have a pleasant chat during the ride.
~ alter(fares_earned_total,10)
~ alter(day_fares_earned,10)
~ alter(rating,10)
{rating>500:
~rating=500
}
# link
# bg:nice
* [Give her 4 stars]
* [Give her 5 stars]
- Soon, you get a notification. She gave you a $10 tip, and an ‘Excellent Service’ badge: 

“Friendly and professional. Would ride again.”

->day_3_pm

/*
=reward
# nice_passenger.reward
# link
* [Keep driving] It's no time to rest on your laurels. 
-> day_3_pm
* [Reward yourself] You stop for a brief break at Burger King before continuing.
-> day_3_pm
*/

===day_3_pm===
#day_3_pm

~time_passes(4,0,1)
# bg:driving_sf
#button
*[🚗&nbsp;&nbsp;Drive]
->quest_finish->
->day_3_quest_near_finish

===day_3_quest_near_finish===
# link
# day_3_quest_near_finish
{
- quest_rides==0:
->day_3_end

- quest_rides<5 && quest_rides > 0:
MESSAGE FROM UBER: “Just {quest_rides} more rides until you get ${quest_bonus} bonus!”
# link
* [Keep driving] As you pull up for the next pick up, you find that it's for a long trip to the airport.
->pickup
* [Call it a day] 
->day_3_end

- else:
It's getting late.
{home=="sac":
~add_time(1,52)
~alter(day_hours_driven,2)
~alter(hours_driven_total,2)
}
# link
* [Call it a day]
->day_3_end
* [Vacuum your car before calling it a day] You make sure the car is clean for tomorrow.
->day_3_end
}

=pickup
# day_3_quest_near_finish.pickup
# link
# bg:airport
*[Ask the passenger if you could decline] The passenger says she's in a hurry and will miss her flight if she has to wait for another Uber.
    ->in_hurry
*[Just go to the airport] You drop her off at the airport.
    
You don't feel like getting in the queue for a ride back, so you drive back to town by yourself. 
~add_time(1,13)
# button
    **[🚗&nbsp;&nbsp;Drive]
    You decide to call it a day and finish the quest tomorrow instead.
    ~ add_ride(1)
    ~ alter(day_fares_earned, 30)
    ~ alter(day_hours_driven, 1)
    ~ alter(fares_earned_total, 30)
    ~ alter(hours_driven_total, 1)
    ->day_3_end

=in_hurry
# day_3_quest_near_finish.in_hurry
# link
*[Cancel on her] She shouts at you as you pull away. Fortunately, you quickly get a few short rides. 
    
    ~ add_time(2,6)
    ~ alter(ride_count_total, quest_rides)
    ~ alter(fares_earned_total, quest_rides*6)
    ~ alter(hours_driven_total, 2)
    ~ alter(day_ride_count, quest_rides)
    ~ alter(day_fares_earned, quest_rides*6)
    ~ alter(day_hours_driven, 2)
    ~ quest_rides=0
    ~ quest_completion=true
    ~ moments=true
    # button
    **[🚗&nbsp;&nbsp;Drive]

    ->quest_finish->day_3_end

*[Go to the airport] You take her to the airport. You don't feel like getting in the queue for a ride back.
~add_time(1,13)
~ add_ride(1)
~ alter(fares_earned_total, 30)
~ alter(hours_driven_total, 1)
~ alter(day_fares_earned, 30)
~ alter(day_hours_driven, 1)
    # button
    **[Drive back to town] You decide to call it a day and finish the quest tomorrow instead.
    ->day_3_end

->->
===day_3_end===
# day_3_end
{home=="sac":
~alter(day_hours_driven,2)
~alter(hours_driven_total,2)
}
{quest_completion==true:
~finished_quest_on_weds=true
}

~day_end()
~alter(days_worked,1)
~ timestamp=1502355600 //9am
# button
# bg:night
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
# bg:main
Since you've already finished the quest and the next one won't start until Friday, do you want to take the day off?
* [Take day off]
~ took_day_off=true
->day_off

* [Keep working] You need every penny you can earn.
->day_4_morning

=day_off
# day_4_start.day_off
You spend the day with your family. Your son is glad you made time for him, and you get some much needed rest. 
~helped_homework=true
{home=="sf":
~timestamp=1502442000 //Friday 9am
-else:
~timestamp=1502438400 // Friday 8am
}
# button
#bg:day_off
* [An enjoyable day]
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

* [Keep working] If you can't finish the quest, then it's even more important to earn more fares.->day_4_morning

===day_4_morning===
# link
# day_4_morning
As you head out, you remember that you promised your son to be home by 7pm to help him with his homework.
{home=="sac":
* [Drive in Sacramento today]
~ current_city = "sac"
-> day_4_sacramento

* [Go to San Francisco] You set off for SF, hoping to get more rides there.
~alter(day_hours_driven,2)
~alter(hours_driven_total,2)
~add_time(2,3)
~ current_city = "sf"
    # button
    # bg:driving_sf
    **[🚗&nbsp;&nbsp;Drive]
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
# bg:driving_sac
*[🚗&nbsp;&nbsp;Drive] You make it home in time to help your son with his homework, as you promised.
    ~helped_homework=true
->day_4_end
    
- quest_completion==false && quest_rides < 17:
    It shouldn't be too hard to complete {quest_rides} ride{quest_rides>1:s}, even in Sacramento.
    
    ~time_passes(9,0,1)
    # button
    # bg:driving_sac
    *[🚗&nbsp;&nbsp;Drive] 
    ->quest_finish->
    You make it home in time to spend the evening with your son as you promised.
    ~helped_homework=true
        # button
        #bg:son
        **[Help with homework] You tuck him into bed afterwards. He gives you a goodnight kiss.
            ->day_4_end
    ->day_4_end

- quest_completion==false && quest_rides > 25:
    With {quest_rides} more rides to go, you're unlikely to finish the quest, so you just take it easy today. 
    
    ~time_passes(9,0,1)
    # button
    # bg:driving_sac
    *[🚗&nbsp;&nbsp;Drive] 
    
    You make it home in time to spend the evening with your son as you promised.
        ~helped_homework=true
        # button
        #bg:son
        **[Help with homework] You tuck him into bed afterwards. He gives you a goodnight kiss.
            ->day_4_end

- else:
    It might be a stretch to do {quest_rides} rides, especially in Sacramento, but you give it a shot.
    ~ temp remaining=quest_rides-3
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
# bg:driving_sac
*[🚗&nbsp;&nbsp;Drive] 
->quest_nudge
}
===quest_nudge===
# link
# quest_nudge
MESSAGE FROM UBER: “Just {quest_rides} more trip{quest_rides>1:s} until you complete your quest!”

But you promised to be home by {home=="sac":8pm}{home=="sf":7pm}.

* [Keep driving]->keep_driving

* [Go home]->went_home


=keep_driving
# quest_nudge.keep_driving
You call home to say you won't be back. Your son is disappointed.
~ temp remaining=quest_rides
~ time_passing=true
~ alter(day_ride_count, quest_rides)
~ alter(day_fares_earned, 19)
~ alter(day_hours_driven, 2)
~ alter(ride_count_total, quest_rides)
~ alter(fares_earned_total, 19)
~ alter(hours_driven_total, 2)
~ add_time(2,3)
~ quest_rides=0
~ quest_completion=true
# button
*[🚗&nbsp;&nbsp;Drive] 

It takes you two hours to finish the last {remaining} rides, but you finish the quest.
~moments=true
{home=="sac" && current_city=="sf":
~ alter(day_hours_driven, 2)
~ alter(hours_driven_total, 2)
~ add_time(1,54)
}
    # button
    # bg:home
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
~timestamp=1502404200
# button
# bg:son
* [Tuck him into bed]
->son_asleep

=son_asleep
# quest_nudge.son_asleep
You're tired after a long day, but the quest doesn't expire until 4am.
# link
* [Go back out]
-> go_back_out

* [Go to sleep] You're too exhausted.
->day_4_end

=go_back_out
# quest_nudge.go_back_out
You get back in your car and turn the app back on.
~ temp remaining=quest_rides
~ time_passing=true
~ alter(day_fares_earned, 19)
~ alter(day_hours_driven, 2)
~ alter(day_ride_count, quest_rides)
~ alter(fares_earned_total, 19)
~ alter(hours_driven_total, 2)
~ alter(ride_count_total, quest_rides)
~ alter(fares_earned_total, quest_bonus)
~ add_time(2,8)
~ quest_completion=true
~ quest_rides=0
# button
# bg:night
*[🚗&nbsp;&nbsp;Drive] 
It takes you two hours to finish the last {remaining} rides, but you finish the quest. You get ${quest_bonus}!
~moments=true
You are completely exhausted.
    # button
    ** [💤&nbsp;&nbsp;Sleep]
    ->day_4_end

===napa===
# link
# napa
# bg:napa
Soon after you arrive, you get a long ride alert on your Uber app. Someone is requesting a trip that will take more than 45 minutes to complete.
* [Accept the ride]->napa_ride
* [Reject the ride]->day_4_sf_from_sac

=napa_ride
# napa.napa_ride
# link
You pick up some tourists who want to drive across the Golden Gate Bridge and go to Napa.
~ alter(fares_earned_total,265)
~ add_ride(1)
~ alter(day_fares_earned,265)
~ alter(hours_driven_total,2)
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
//11am if no napa ride, 1pm if napa ride
By now, you've become used to the rhythm of the day and how this works.

{
- quest_completion==true:
    Without the pressure to finish the quest, you spend a pretty relaxing day driving.
    {napa.napa_ride:
        ~time_passes(4,0,1)
        ~UberXL()
        - else:
        ~time_passes(6,0,1)
        ~UberXL()
    }
    # button
    # bg:driving_sf
    *[🚗&nbsp;&nbsp;Drive] It's time to head back to Sacramento to keep your promise to your son. //5pm
    
    ~ add_time(1,56)
    ~ alter(day_hours_driven,2)
    ~ alter(hours_driven_total,2)
    # button
    ** [Go home]
    ~helped_homework=true
    You spend a pleasant evening helping your son with his homework. Afterwards, he gives you a goodnight kiss as you tuck him into bed.
    -> day_4_end

- else:
    {napa.napa_ride:
        ~time_passes(4,0,1)
        ~UberXL()
        - else:
        ~time_passes(6,0,1)
        ~UberXL()
    }
    # button
    # bg:driving_sf
    *[🚗&nbsp;&nbsp;Drive]->time_to_go_home
}

=time_to_go_home
//5pm
# day_4_sf_from_sac.time_to_go_home

{ 
- quest_completion==true:
->quest_finish->
    It's time to head back to Sacramento to keep your promise to your son.
    ~ add_time(1,56)
    ~ alter(day_hours_driven,2)
    ~ alter(hours_driven_total,2)
    # button
    # bg:driving_sf
    ** [Go home]
        ~helped_homework=true
        You spend a pleasant evening helping your son with his homework.
        -> day_4_end

- quest_completion==false && quest_rides < 7: 
    MESSAGE FROM UBER: “Just {quest_rides} more trip{quest_rides>1:s} until you complete your quest!”
    But you promised to be home by 7pm to help your son with his homework.
    # link
    * [Keep driving] ->keep_driving
    * [Go home] ->go_home

- quest_completion==false && quest_rides > 7: 
    It doesn't look like you'll be able to finish the quest. You might as well go keep your promise and go home.
    ~ add_time(1,56)
    ~ alter(day_hours_driven,2)
    ~ alter(hours_driven_total,2)
    # button
    # bg:driving_sf
    * [Go home]        
        ~helped_homework=true
        You spend a pleasant evening helping your son with his homework. Afterwards, he gives you a goodnight kiss as you tuck him into bed.
        ->day_4_end
}

=keep_driving
# day_4_sf_from_sac.keep_driving
You call home to say you won't make it back. Your son is disappointed, but getting that quest bonus is too important.
{
- quest_rides== 5 || 6:
~time_passes(3,1,1)
- quest_rides== 3 || 4:
~time_passes(2,1,1)
- else:
~time_passes(1,1,1)
}
# button
*[🚗&nbsp;&nbsp;Drive]->home_after_finishing_quest

=home_after_finishing_quest
# day_4_sf_from_sac.home_after_finishing_quest
You finished the quest! As you drive home, you think about your decision.
~ alter(day_hours_driven, 2)
~ alter(hours_driven_total, 2)
~ add_time(2,3)
# link
# bg:home
*[Feel good about finishing the quest] Your son may be disappointed, but you can always make it up to him later.
*[Feel bad about breaking your promise] You drive as quickly as you can to get back to Sacramento, but your son is already asleep by the time you get back. He didn't finish his homework.
- ->day_4_end

=go_home
# day_4_sf_from_sac.go_home
~ add_time(1,56)
~ alter(day_hours_driven,2)
~ alter(hours_driven_total,2)
You get back in time to keep your promise. Your son is delighted to see you.
~helped_homework=true
# button
# bg:son
*[Help with homework] You tuck him into bed afterwards. He gives you a goodnight kiss.
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
# bg:driving_sf
*[🚗&nbsp;&nbsp;Drive] You make it home in time to help your son with his homework, as you promised.
    ~helped_homework=true
->day_4_end
    
- quest_completion==false && quest_rides < 19:
    It shouldn't be too hard to complete {quest_rides} ride{quest_rides>1:s}.
    
    ~time_passes(9,0,1)
    # button
    # bg:driving_sf
    *[🚗&nbsp;&nbsp;Drive] 
    ->quest_finish->
    You make it home in time to spend the evening with your son as you promised.
    ~helped_homework=true
        # button
        # bg:son
        **[Help with homework] You tuck him into bed afterwards. He gives you a goodnight kiss.
        ->day_4_end

- quest_completion==false && quest_rides > 27:
    With {quest_rides} more rides to go, you're unlikely to finish the quest, so you just take it easy today. 
    
    ~time_passes(9,0,1)
    # button
    # bg:driving_sf
    *[🚗&nbsp;&nbsp;Drive] 
    
    You make it home in time to spend the evening with your son as you promised.
        ~helped_homework=true
        # button
        # bg:son
        **[Help with homework] You tuck him into bed afterwards. He gives you a goodnight kiss.
            ->day_4_end

- else:
    It might be a stretch to do {quest_rides} rides, but you give it a shot.
    ~ temp remaining=quest_rides-3
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
# bg:driving_sf
*[🚗&nbsp;&nbsp;Drive] 
->quest_nudge
}

===day_4_end===
# day_4_end

~timestamp=1502442000 //9am

It's the end of day 4.
{home=="sac":
~alter(hours_driven_total,2)
~alter(day_hours_driven,2)
}
Today, you drove for {day_hours_driven} hours, completed {day_ride_count} rides and earned ${day_fares_earned} in fares. /*Your driver rating is {rating/100}.*/<>

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

//add 1 to the days_worked count if you didn't take the day off
{day_4_start.day_off==0:
~ alter(days_worked,1)
}

# button
# bg:night
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

NEW UBER QUEST: "Drive {quest_rides} trips, make ${quest_bonus} extra. You have until 4am on Monday"
# button
#bg:main
* [Accept quest]

{quest_completion == false:
    You are determined to finish this quest after missing out on the last one.
    - else:
    You are determined to finish this quest as well. <>
}
~quest_completion=false
->day_5_late_start

===day_5_late_start===
# day_5_late_start
Friday and Saturday nights are some of the busiest times for rides, but the peak period doesn't start until 10pm.
# link
# normal_start
* [Start driving now] ->day_5_daytime

* [Start in the evening] You take a rest and try to nap a bit during the day. 
~timestamp=1502478400 //7pm
    # button
    ** [💤&nbsp;&nbsp;Rest]
-> day_5_evening_start

===day_5_daytime===
# day_5_daytime
You decide that it's not worth it to disrupt your normal schedule. <>

{home=="sac": 
<> You head into San Francisco at your usual hour.
~alter(day_hours_driven,2)
~alter(hours_driven_total,2)
~add_time(2,3)
}

{
- home=="sf" && windshield_cracked==true:
    ~time_passes(5,0,1)
    # button
    # bg:driving_sf
    *[🚗&nbsp;&nbsp;Drive]
    ->windshield_reminder
    
- home=="sac" && windshield_cracked==true:
    ~time_passes(3,0,1)
    # button
    # bg:driving_sf
    *[🚗&nbsp;&nbsp;Drive]
    ->windshield_reminder

- home=="sf" && windshield_cracked==false:
    ~time_passes(9,0,1)
    # button
    # bg:driving_sf
    *[🚗&nbsp;&nbsp;Drive]
    ->day_5_afternoon

- home=="sac" && windshield_cracked==false:
    ~time_passes(7,0,1)
    # button
    # bg:driving_sf
    *[🚗&nbsp;&nbsp;Drive]
    ->day_5_afternoon
}

===windshield_reminder===
# windshield_reminder
You check your chipped windshield. You can't tell whether the small crack it has become bigger or not.
# link
# bg:pebble
* [Repair it ($30)]
->pebble_start.repair->windshield_reminder.get_it_fixed
* [Leave it]
->leave

=get_it_fixed
~time_passes(3,0,1)
# button
*[🚗&nbsp;&nbsp;Drive]
->day_5_afternoon

=leave
# windshield_reminder.leave
You decide it's still the same size. It'll be fine.
~time_passes(4,0,1)
# button
*[🚗&nbsp;&nbsp;Drive]
->day_5_afternoon

===day_5_afternoon===
# day_5_afternoon
# link
# bg:driving_sf
You would normally finish up around now. {home=="sac":Especially since you you have a two hour drive to get back home.}

* [Go home]->go_home
* {!gym_member}[Keep driving] ->keep_driving
* {gym_member} [Freshen up at the gym]->gym

=go_home
# day_5_afternoon.go_home
{home=="sac": 
~alter(day_hours_driven,2)
~alter(hours_driven_total,2)
~add_time(2,3)
    On the drive back, you wonder if you made the right decision to start at your usual time.
    # link
    # bg:home
    * It's important to keep to a routine[], you tell yourself.
    ->day_5_end
    * Probably should've started later instead[], you think. But it's too late now.
    ->day_5_end

- else:
    You stick with your routine and call it a day.
    -> day_5_end
}

=keep_driving
# day_5_afternoon.keep_driving
You're getting tired, but decide to push on and try to catch the evening crowd.
~time_passes(2,1,1)
# button
*[🚗&nbsp;&nbsp;Drive] 
->forced_home

=gym
# day_5_afternoon.gym
You take a break to shower and freshen up at the gym before continuing.
~time_passes(3,1,1)
# bg:gym
# button
*[🚗&nbsp;&nbsp;Drive]->burgers

===day_5_evening_start===
# day_5_evening_start
//7pm
Feeling refreshed after resting during the day, you get in your car and prepare for a long night on the road.

{home=="sac":
~alter(day_hours_driven,2)
~alter(hours_driven_total,2)
~add_time(2,3)
}
~ time_passes(1,1,1)
# button
# bg:night
*[🚗&nbsp;&nbsp;Drive]->burgers

===burgers===
//9pm
# link
# burgers
# bg:burger
~temp dirty=false
You arrive at a pick-up to find two passengers holding In-N-Out burgers that they are about to eat in the car.
~add_time(0,4)
* [“The food can’t come in the car”] “Aww, come on,” they say. “We'll be careful.”
    # link
    ** “No means no[.”],” you say, as you cancel their ride.
    ->day_5_after_burger
    
    ** “Oh, alright[.”],” you say. They get in the car. <>
    
* [“Nice! I love burgers too.”]They get in the car and you start driving. 

- From the rear-view mirror, you see one of them take a bite, and some ketchup drips onto the seat.

    ~add_time(0,22)
    # link
    ** [Say something] After your admonishment, they wipe the seat, but there's still a stain. They look unhappy at being called out. <>
    ~ dirty=true 
    ~ alter(rating,-5)
    ** [Keep quiet] They blithely continue eating. You can't stop thinking about the stain. <>
    ~ dirty=true
    -- Eventually, they finish their burgers. The rest of the trip passes without incident.
    ->dirty_car 
    
===dirty_car===
# dirty_car
{cleaning_supplies==true:
Your backseat is dirty. Fortunately, you have cleaning supplies in the trunk. 
#button
#bg:cleanup
*[Clean your car]
You spend some time cleaning up. Your next passenger is impressed by how clean your car is.
    {rating>490:
        ~rating=500
    - else:
        ~ alter(rating, 10)
    }
->day_5_after_burger

- else:
You backseat is dirty and you don't have cleaning supplies.
->no_cleaning_supplies
}

=no_cleaning_supplies
# dirty_car.no_cleaning_supplies
#link
* [Find cleaning supplies]It takes you some time to find a convenience store. You spend $20 stocking up on cleaning supplies.
~cleaning_supplies=true
~alter(accessories_cost,20)
~add_time(0,16)

->ride_request

* [Ignore it] You put it out of your mind. Your next passenger is not too impressed with your dirty backseat.
    ~ alter(rating,-15) 
    ->day_5_after_burger

=ride_request
# dirty_car.ride_request
# link
#bg:cleanup
Just as you start cleaning, a ride request comes in.
~add_time(0,13)

* [Take the request]You abandon the cleaning and go pick up the passenger. He's not impressed with the dirty backseat.
~ alter(rating,-10) 
~ add_ride(1)
~ alter(fares_earned_total,8)
~ alter(day_fares_earned,8)
~ alter(day_hours_driven,1)
~ alter(hours_driven_total,1)
->day_5_after_burger
* [Decline the ride] You finish cleaning up. Your next passenger compliments you on how clean your car is.
    {rating>490:
        ~rating=500
    - else:
        ~ alter(rating, 10)
    }
->day_5_after_burger

===day_5_after_burger===
# day_5_after_burger
# button
{day_5_evening_start:
~time_passes(3,0,1)
*[🚗&nbsp;&nbsp;Drive]
->home_or_not
- else:
->forced_home
}

===home_or_not===
# link
# home_or_not
# bg:night
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
# bg:home
* [Take a short nap] You pull over and take a short nap. Eventually you make it home.
->day_5_end
}

===sleep_in_car===
# sleep_in_car
# button
# bg:night
You're too tired to drive two hours to go back home. You find a quiet spot to park.
~ overnight = true
~timestamp=1502528400
*[💤&nbsp;&nbsp;Sleep] It's not very comfortable, but you eventually fall asleep.
~day_end()
~ alter(days_worked,1)
    # button
    ** [Start day 6]
    -> day_6_slept_in_car

===vomit===
# link
# vomit
# bg:vomit
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
She looks like she needs a ride home. You open a window, maybe some fresh air will make her feel better. 
~add_time(0,18)
~add_ride(1)
~alter(day_fares_earned,7)
~alter(fares_earned_total,7)
# button
* [Drive to her destination] As the passenger is getting out, she vomits again. Ugh!
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
    # bg:cleanup
    ** [Notify Uber]
    Uber gives you $30 in cleaning fees.
    ~alter(fares_earned_total,30)
        # button
        *** [💵&nbsp;&nbsp;Cleaning Fees]->day_5_late_night
    ** [Don't notify Uber]->day_5_late_night

===day_5_late_night===
# day_5_late_night
{day_5_daytime:
You are so tired you can't drive anymore.

    {home=="sf":
    ->day_5_end
    - else: ->sleep_in_car
    }

- else:
~time_passes(2,1,1) 
You might have to put up with some rowdy and drunk passengers, but the late hours are certainly lucrative.
# button
# bg:night
* [🚗&nbsp;&nbsp;Drive]->day_5_late_late
}

===day_5_late_late===
# day_5_late_late
# link
# bg:night
It's getting really late, and despite having taken a nap during the day, you're getting really sleepy.

* [Keep driving] Are you sure you want to keep driving? You can barely keep your eyes open.
    # link
    ** [Yes, keep going]->insist
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
# deactivation
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
    ~ alter(days_worked,1)
    ~timestamp=1502528400
    //saturday 9am
        # button
        # bg:home
        *** [💤&nbsp;&nbsp;Sleep]->day_6_deactivated
    }
    {home=="sac":
    You're too tired to drive back. You find a quiet spot to park and spend an uncomfortable night sleeping in your car.
    ~day_end()
    ~ alter(days_worked,1)
    ~timestamp=1502528400
    //saturday 9am
        # button
        *** [💤&nbsp;&nbsp;Sleep]->day_6_deactivated
    }
*[Don't contact Uber] You're too tired to sort this out over the phone right now.
    {home=="sf":
    You drive home and collapse into bed.
    ~day_end()
    ~ alter(days_worked,1)
    ~timestamp=1502528400
    //saturday 9am
        # button
        *** [💤&nbsp;&nbsp;Sleep]->day_6_deactivated
    }
    {home=="sac":
    You're too tired to drive back. You find a quiet spot to park and spend an uncomfortable night sleeping in your car.
    ~day_end()
    ~ alter(days_worked,1)
    ~timestamp=1502528400
    //saturday 9am
        # button
        *** [💤&nbsp;&nbsp;Sleep]->day_6_deactivated
    }

===day_5_end===
# day_5_end
~timestamp=1502528600
//sat 9am
~day_end()
~ alter(days_worked,1)
# button
# bg:night
* [Start day 6]
->day_6_start

===day_6_deactivated===
# day_6_deactivated
//saturday 9am
It's Saturday. 
{home=="sac": You wake up, briefly forgetting that you're in your car in San Francisco.}

You {home=="sf":wake up and }check your Uber app to find that you're still deactivated. You decide to make the most of your enforced day off.

->day_6_off

===day_6_off===
# day_6_off
# link
# bg:day_off
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
# bg:night
~timestamp=1502614800
//sun 9am
** [Start day 7]
->day_7_start


=== day_6_slept_in_car ===
# day_6_slept_in_car
You wake up, briefly forgetting that you're in your car in San Francisco.

->day_6_start

=== day_6_start===
# link
# day_6_start
# bg:main
It's Saturday. Do you take the day off? It is the weekend, after all.

* [Take day off] You decide to take the day off.
->day_6_off
* [Go to work]
->day_6_work

=== day_6_work ===
# day_6_work
//9am
MESSAGE FROM UBER: “The San Francisco Giants are playing at AT&T park today. Earn a boosted 1.5x fare for trips from there, from 5pm-6:30pm today”
~ time_passes(3,0,1)
# button
# bg:stadium
*[Got it]
->door_dent

=== door_dent ===
# door_dent
As you finish a ride, the passenger opens the door to get out and hits a lamp post, denting your car door. 

“I'm sorry! But I'm in a hurry,” he says as he rushes off. “Why don't you take up with Uber?”
~add_time(2,21)
# link
# bg:door
# deactivation
*[Report the incident to Uber] You document everything and report the incident to Uber. Uber begins the claim process, but in the meantime your account is suspended.
    ~timestamp=1502571600 //sat 9pm
    ~moments=true
    # button
    **[🔧&nbsp;&nbsp;Repair]
    ->reported

*[Don't report it] You decide to get it repaired yourself instead. It takes the mechanics two hours to fix it, and they charge you $100. You put it on your credit card.
    ~alter(repair_cost,100)
    ~ time_passes(3,0,1)
    # button
    ** [🚗&nbsp;&nbsp;Drive]
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
# bg:stadium
//5:30pm
You hear on the radio that the baseball game has just ended.

* [Head over to the stadium]

You make your way to the baseball stadium before the game ends. Sure enough, lots of people are requesting rides there. 
    ~ add_ride(1)
    ~ alter(day_fares_earned, 30)
    ~ alter(fares_earned_total, 30)
    ~add_time(0,48)
# button
** [Great!] You get lucky with a relatively long ride to Outer Richmond, and earn $30 on a boosted fare.
->day_6_evening

* [Don't head over]

->day_6_evening

=== day_6_evening ===

# day_6_evening
It sure is busy this Saturday evening.
~time_passes(3,1,1)
# button
# bg:driving_sf
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
//add one to days_worked count because you don't end up here if you took day 6 off
~alter(days_worked,1)
# button
# bg:night
* [Start day 7]
->day_7_start

===day_7_start===

# day_7_start

{door_dent.reported: You manage to get a different {car}, and Uber has reactivated your account.}

It's Sunday! You still need {quest_rides} more rides to get the weekend bonus.
# button
# bg:main
~time_passes(3,0,1)
*[Let's do this!]

->no_drop_zone

=== no_drop_zone===
# link
# no_drop_zone
# bg:caltrain
A passenger insists you drop her off at the entrance to the Caltrain station, which is a no-stop zone.
* [Agree to do so]->drop

* [Refuse] You stop nearby and explain why you cannot drop her off at the entrance. She's not convinced.
    # link
    **[Insist]
    ->insist
    **[Relent]->drop

=insist
She slams the door as she gets out. You get a bad rating from her but that's better than risking a traffic ticket.
#no_drop_zone.insist
~ alter(rating,-10)
~ time_passes(3,0,1)
# button
* [🚗&nbsp;&nbsp;Drive]
->day_7_afternoon

=drop
#no_drop_zone.drop
~ temp ticket = RANDOM(1,3)
{ticket>1: 
You drop her off quickly. Luckily, there weren't any cops around.
    ~time_passes(3,0,1)
    # button
    ** [Phew!]->day_7_afternoon
- else: ->caught
}

=caught
# no_drop_zone.caught
As you drop her off, you see a police car pull up behind you. 
~ticketed=true
~ alter(ticket_cost,260)

# button
*[🚓&nbsp;&nbsp;Police]
You get a traffic ticket (-$260). You'll have to go pay that later.
~ time_passes(3,0,1)
    # button
    **[That's a real setback]
    ->quest_finish->
    ->day_7_afternoon

===day_7_afternoon===

# day_7_afternoon
~time_passes(3,0,1)
# button
# bg:driving_sf
* [🚗&nbsp;&nbsp;Drive]
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

# pebble_crack

You are driving when you hear a splintering sound. The chip in your windshield has cracked across the whole windshield. You have no choice but to get it repaired
~alter(repair_cost,-250)
~add_time(1,58)
# button
# bg:crack
* [The mechanic charges you $250]You put it on your card, regretting that you didn't get it fixed earlier.
->->

===day_7_evening===
# link
# day_7_evening
{
-quest_rides < 7 && quest_completion==false:
    MESSAGE FROM UBER: “Just {quest_rides} more trip{quest_rides>1:s} until you complete your quest!”
    # button
    ~time_passes(3,0,1)
    ~quest_completion=true
    ~moments=true
    #bg:driving_sf
    *[Finish the quest]
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
~alter(days_worked,1)
# button
#bg:night
*[Finish the week]
->earnings_calculations


===earnings_calculations===
//calculate total revenue
~ alter(revenue_total,fares_earned_total)
~ alter(revenue_total,UberXL_total)
{weekday_quest_completion==true:
    ~ alter(revenue_total,weekday_quest_bonus)
}
{weekend_quest_completion==true:
    ~ alter(revenue_total,weekend_quest_bonus)
}

//calculate tax cost - tax is 10% of revenue if you didn't keep gas receipts
{kept_receipt==true:
~ tax_cost=0
- else:
~tax_cost=revenue_total/10
}

//calculate gas cost
{
- car=="minivan" && home=="sf":
~gas_cost=days_worked*35

- car=="minivan" && home=="sac":
~gas_cost=days_worked*45

- car=="Prius" && home=="sf":
~gas_cost=days_worked*15

- car=="Prius" && home=="sac":
~gas_cost=days_worked*25
}

//calculate total cost
~ cost_total=car_cost+accessories_cost+gas_cost+repair_cost+ticket_cost+tax_cost

->end_sequence

===end_sequence===
# end_sequence
It's the end of the week. Were you savvy enough to survive as a full-time Uber driver?

Your stats

Hours driven: {hours_driven_total}
Rides completed: {ride_count_total}
Ratings: {rating/100}

Your income

Fares and tips: {fares_earned_total}
//Only show UberXL if {car}=="minivan"
UberXL fares: {UberXL_total}
//if {weekday_quest_completion}==false, show 0. Likewise for {weekend_quest_completion}
Weekday quest: {weekday_quest_bonus}
Weekend quest: {weekend_quest_bonus}

Your costs

Car rental: {car_cost}
Accessories: {accessories_cost}
Gasoline: {gas_cost}
//Only show Repair and Traffic ticket costs if > 0??
Repairs: {repair_cost}
Traffic ticket: {ticket_cost}
Tax: {tax_cost}

//Congrats/sorry screens
/*
Total earnings = revenue_total - cost_total
Earnings per hour = total earnings / hours_driven_total

Tests on the two screens are:
    Total earnings > 1000
and
    Earnings per hour > 12
*/

Your choices screen

Took day off? (days worked: {days_worked}) (or,took_day_off boolean variable: {took_day_off})
Kept promise to son? {helped_homework}
Bought biz licence? {biz_licence}


# button
~go_to_endscreen=true
*[to endscreen]
->endscreen



===endscreen===
# endscreen
You shouldn't see this - it should already have gone to the end screen sequence
->END


/*
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

*/




