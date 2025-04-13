#define BLACKBOX_FEEDBACK_NUM(key) (SSblackbox.feedback_list[key] ? SSblackbox.feedback_list[key].json["data"] : null)

/datum/episode_name
	var/thename = ""
	var/reason = "Nothing particularly of note happened this round to influence the episode name." //Explanation on why this episode name fits this round. For the admin panel.
	var/weight = 100 //50 will have 50% the chance of being picked. 200 will have 200% the chance of being picked, etc. Relative to other names, not total (just the default names already total 700%)
	var/rare = FALSE //If set to true and this episode name is picked, the current round is considered "not a rerun" for client preferences.

/datum/episode_name/rare
	rare = TRUE

/datum/episode_name/New(thename, reason, weight)
	if(!thename)
		return
	src.thename = thename
	if(reason)
		src.reason = reason
	if(weight)
		src.weight = weight

	switch(rand(1,15))
		if(0 to 5)
			thename += ": PART I"
		if(6 to 10)
			thename += ": PART II"
		if(11 to 12)
			thename += ": PART III"
		if(13)
			thename += ": NOW IN 3D"
		if(14)
			thename += ": ON ICE!"
		if(15)
			thename += ": THE SEASON FINALE"

/datum/controller/subsystem/credits/proc/draft_episode_names()
	var/uppr_name = uppertext(station_name()) //so we don't run these two 500 times

	episode_names += new /datum/episode_name("THE [pick("DOWNFALL OF", "RISE OF", "TROUBLE WITH", "FINAL STAND OF", "DARK SIDE OF")] [pick(200;"[uppr_name]", 150;"SPACEMEN", 150;"HUMANITY", "DIGNITY", "SANITY", "SCIENCE", "CURIOSITY", "EMPLOYMENT", "PARANOIA", "THE CHIMPANZEES", 50;"THE VENDOMAT PRICES")]")
	episode_names += new /datum/episode_name("THE CREW [pick("GOES ON WELFARE", "GIVES BACK", "SELLS OUT", "GETS WHACKED", "SOLVES THE PLASMA CRISIS", "HITS THE ROAD", "RISES", "RETIRES", "GOES TO HELL", "DOES A CLIP SHOW", "GETS AUDITED", "DOES A TV COMMERCIAL", "AFTER HOURS", "GETS A LIFE", "STRIKES BACK", "GOES TOO FAR", "IS 'IN' WITH IT", "WINS... BUT AT WHAT COST?", "INSIDE OUT")]")
	episode_names += new /datum/episode_name("THE CREW'S [pick("DAY OUT", "BIG GAY ADVENTURE", "LAST DAY", "[pick("WILD", "WACKY", "LAME", "UNEXPECTED")] VACATION", "CHANGE OF HEART", "NEW GROOVE", "SCHOOL MUSICAL", "HISTORY LESSON", "FLYING CIRCUS", "SMALL PROBLEM", "BIG SCORE", "BLOOPER REEL", "GOT IT", "LITTLE SECRET", "SPECIAL OFFER", "SPECIALTY", "WEAKNESS", "CURIOSITY", "ALIBI", "LEGACY", "BIRTHDAY PARTY", "REVELATION", "ENDGAME", "RESCUE", "PAYBACK")]")
	episode_names += new /datum/episode_name("THE CREW GETS [pick("PHYSICAL", "SERIOUS ABOUT [pick("DRUG ABUSE", "CRIME", "PRODUCTIVITY", "ANCIENT AMERICAN CARTOONS", "SPACEBALL")]", "PICKLED", "AN ANAL PROBE", "PIZZA", "NEW WHEELS", "A VALUABLE HISTORY LESSON", "A BREAK", "HIGH", "TO LIVE", "TO RELIVE THEIR CHILDHOOD", "EMBROILED IN CIVIL WAR", "DOWN WITH IT", "FIRED", "BUSY", "THEIR SECOND CHANCE", "TRAPPED", "THEIR REVENGE")]")
	episode_names += new /datum/episode_name("[pick("BALANCE OF POWER", "SPACE TRACK", "SEX BOMB", "WHOSE IDEA WAS THIS ANYWAY?", "WHATEVER HAPPENED, HAPPENED", "THE GOOD, THE BAD, AND [uppr_name]", "RESTRAIN YOUR ENJOYMENT", "REAL HOUSEWIVES OF [uppr_name]", "MEANWHILE, ON [uppr_name]...", "CHOOSE YOUR OWN ADVENTURE", "NO PLACE LIKE HOME", "LIGHTS, CAMERA, [uppr_name]!", "50 SHADES OF [uppr_name]", "GOODBYE, [uppr_name]!", "THE SEARCH", \
	"THE CURIOUS CASE OF [uppr_name]", "ONE HELL OF A PARTY", "FOR YOUR CONSIDERATION", "PRESS YOUR LUCK", "A STATION CALLED [uppr_name]", "CRIME AND PUNISHMENT", "MY DINNER WITH [uppr_name]", "UNFINISHED BUSINESS", "THE ONLY STATION THAT'S NOT ON FIRE (YET)", "SOMEONE'S GOTTA DO IT", "THE [uppr_name] MIX-UP", "PILOT", "PROLOGUE", "FINALE", "UNTITLED", "THE END")]")
	episode_names += new /datum/episode_name("[pick("SPACE", "SEXY", "DRAGON", "WARLOCK", "LAUNDRY", "GUN", "ADVERTISING", "DOG", "CARBON MONOXIDE", "NINJA", "WIZARD", "SOCRATIC", "JUVENILE DELIQUENCY", "POLITICALLY MOTIVATED", "RADTACULAR SICKNASTY", "CORPORATE", "MEGA")] [pick("QUEST", "FORCE", "ADVENTURE")]", weight=25)

	var/popcount = SSticker.gather_roundend_feedback()

	if(!EMERGENCY_ESCAPED_OR_ENDGAMED)
		return

	var/dead = GLOB.joined_player_list.len - popcount[POPCOUNT_ESCAPEES]
	var/escaped = popcount[POPCOUNT_ESCAPEES]
	var/human_escapees = popcount[POPCOUNT_SHUTTLE_ESCAPEES]
	if(dead == 0)
		episode_names += new /datum/episode_name/rare("[pick("EMPLOYEE TRANSFER", "LIVE LONG AND PROSPER", "PEACE AND QUIET IN [uppr_name]", "THE ONE WITHOUT ALL THE FIGHTING")]", "No-one died this round.", 2500) //in practice, this one is very very very rare, so if it happens let's pick it more often
	if(escaped == 0 || SSshuttle.emergency.is_hijacked())
		episode_names += new /datum/episode_name("[pick("DEAD SPACE", "THE CREW GOES MISSING", "LOST IN TRANSLATION", "[uppr_name]: DELETED SCENES", "WHAT HAPPENS IN [uppr_name], STAYS IN [uppr_name]", "MISSING IN ACTION", "SCOOBY-DOO, WHERE'S THE CREW?")]", "There were no escapees on the shuttle.", 300)
	if(escaped < 6 && escaped > 0 && dead > escaped*2)
		episode_names += new /datum/episode_name("[pick("AND THEN THERE WERE FEWER", "THE 'FUN' IN 'FUNERAL'", "FREEDOM RIDE OR DIE", "THINGS WE LOST IN [uppr_name]", "GONE WITH [uppr_name]", "LAST TANGO IN [uppr_name]", "GET BUSY LIVING OR GET BUSY DYING", "THE CREW FUCKING DIES", "WISH YOU WERE HERE")]", "[dead] people died this round.", 400)

	var/clowncount = 0
	var/mimecount = 0
	var/assistantcount = 0
	var/chefcount = 0
	var/chaplaincount = 0
	var/lawyercount = 0
	var/minercount = 0
	var/baldycount = 0
	var/horsecount = 0
	for(var/mob/living/carbon/human/H as anything in popcount["human_escapees_list"])
		if(HAS_TRAIT(H, TRAIT_MIMING))
			mimecount++
		if(H.is_wearing_item_of_type(list(/obj/item/clothing/mask/gas/clown_hat, /obj/item/clothing/mask/gas/sexyclown)) || (H.mind && H.mind.assigned_role.title == "Clown"))
			clowncount++
		if(H.is_wearing_item_of_type(/obj/item/clothing/under/color/grey) || (H.mind && H.mind.assigned_role.title == "Assistant"))
			assistantcount++
		if(H.is_wearing_item_of_type(/obj/item/clothing/head/utility/chefhat) || (H.mind && H.mind.assigned_role.title == "Chef"))
			chefcount++
		if(H.is_wearing_item_of_type(/obj/item/clothing/under/rank/civilian/lawyer))
			lawyercount++
		if(H.mind && H.mind.assigned_role.title == "Shaft Miner")
			minercount++
		/*
		if(H.mind && H.mind.assigned_role.title == "Chaplain")
			chaplaincount++
			if(IS_CHANGELING(H))
				episode_names += new /datum/episode_name/rare("[uppertext(H.real_name)]: A BLESSING IN DISGUISE", "The Chaplain, [H.real_name], was a changeling and escaped alive.", 750)
		*/
		if(H.dna.species.type == /datum/species/human && (H.hairstyle == "Bald" || H.hairstyle == "Skinhead") && !(BODY_ZONE_HEAD in H.get_covered_body_zones()))
			baldycount++
		if(H.is_wearing_item_of_type(/obj/item/clothing/mask/animal/horsehead))
			horsecount++

	if(clowncount > 2)
		episode_names += new /datum/episode_name/rare("CLOWNS GALORE", "There were [clowncount] clowns on the shuttle.", min(1500, clowncount*250))
		theme = "clown"
	if(mimecount > 2)
		episode_names += new /datum/episode_name/rare("THE SILENT SHUFFLE", "There were [mimecount] mimes on the shuttle.", min(1500, mimecount*250))
	if(chaplaincount > 2)
		episode_names += new /datum/episode_name/rare("COUNT YOUR BLESSINGS", "There were [chaplaincount] chaplains on the shuttle. Like, the real deal, not just clothes.", min(1500, chaplaincount*450))
	if(chefcount > 2)
		episode_names += new /datum/episode_name/rare("Too Many Cooks", "There were [chefcount] chefs on the shuttle.", min(1500, chefcount*450)) //intentionally not capitalized, as the theme will customize it
		theme = "cooks"

	if(human_escapees)
		if(assistantcount / human_escapees > 0.6 && human_escapees > 3)
			episode_names += new /datum/episode_name/rare("[pick("GREY GOO", "RISE OF THE GREYTIDE")]", "Most of the survivors were Assistants, or at least dressed like one.", min(1500, assistantcount*200))

		if(baldycount / human_escapees > 0.6 && SSshuttle.emergency.launch_status == EARLY_LAUNCHED)
			episode_names += new /datum/episode_name/rare("TO BALDLY GO", "Most of the survivors were bald, and it shows.", min(1500, baldycount*250))
		if(horsecount / human_escapees > 0.6 && human_escapees> 3)
			episode_names += new /datum/episode_name/rare("STRAIGHT FROM THE HORSE'S MOUTH", "Most of the survivors wore horse heads.", min(1500, horsecount*250))

	if(human_escapees == 1)
		var/mob/living/carbon/human/H = popcount["human_escapees_list"][1]

		if(IS_TRAITOR(H) || IS_NUKE_OP(H))
			theme = "syndie"
		if(H.stat == CONSCIOUS && H.mind && H.mind.assigned_role.title)
			switch(H.mind.assigned_role.title)
				if("Chef")
					var/chance = 250
					if(H.is_wearing_item_of_type(/obj/item/clothing/head/utility/chefhat))
						chance += 500
					if(H.is_wearing_item_of_type(/obj/item/clothing/suit/toggle/chef))
						chance += 500
					episode_names += new /datum/episode_name/rare("HAIL TO THE CHEF", "The Chef was the only survivor in the shuttle.", chance)
				if("Clown")
					var/chance = 250
					if(H.is_wearing_item_of_type(/obj/item/clothing/mask/gas/clown_hat))
						chance += 500
					if(H.is_wearing_item_of_type(list(/obj/item/clothing/shoes/clown_shoes, /obj/item/clothing/shoes/clown_shoes/jester)))
						chance += 500
					if(H.is_wearing_item_of_type(list(/obj/item/clothing/under/rank/civilian/clown, /obj/item/clothing/under/rank/civilian/clown/jester)))
						chance += 250
					episode_names += new /datum/episode_name/rare("[pick("COME HELL OR HIGH HONKER", "THE LAST LAUGH")]", "The Clown was the only survivor in the shuttle.", chance)
					theme = "clown"
				if("Detective")
					var/chance = 250
					if(H.is_wearing_item_of_type(/obj/item/storage/belt/holster/detective))
						chance += 1000
					if(H.is_wearing_item_of_type(/obj/item/clothing/head/fedora/det_hat))
						chance += 500
					if(H.is_wearing_item_of_type(/obj/item/clothing/suit/jacket/det_suit))
						chance += 500
					if(H.is_wearing_item_of_type(/obj/item/clothing/under/rank/security/detective))
						chance += 250
					episode_names += new /datum/episode_name/rare("[uppertext(H.real_name)]: LOOSE CANNON", "The Detective was the only survivor in the shuttle.", chance)
				if("Shaft Miner")
					var/chance = 250
					if(H.is_wearing_item_of_type(/obj/item/pickaxe))
						chance += 1000
					if(H.is_wearing_item_of_type(/obj/item/storage/backpack/explorer))
						chance += 500
					if(H.is_wearing_item_of_type(/obj/item/clothing/suit/hooded/explorer))
						chance += 250
					episode_names += new /datum/episode_name/rare("[pick("YOU KNOW THE DRILL", "CAN YOU DIG IT?", "JOURNEY TO THE CENTER OF THE ASTEROI", "CAVE STORY", "QUARRY ON")]", "The Miner was the only survivor in the shuttle.", chance)
				if("Librarian")
					var/chance = 750
					if(H.is_wearing_item_of_type(/obj/item/book))
						chance += 1000
					episode_names += new /datum/episode_name/rare("COOKING THE BOOKS", "The Librarian was the only survivor in the shuttle.", chance)
				if("Chemist")
					var/chance = 1000
					if(H.is_wearing_item_of_type(/obj/item/clothing/suit/toggle/labcoat/chemist))
						chance += 500
					if(H.is_wearing_item_of_type(/obj/item/clothing/under/rank/medical/chemist))
						chance += 250
					episode_names += new /datum/episode_name/rare("A BITTER PILL TO SWALLOW", "The Chemist was the only survivor in the shuttle.", chance)
				if("Chaplain") //We don't check for uniform here because the chaplain's thing kind of is to improvise their garment gimmick
					episode_names += new /datum/episode_name/rare("BLESS THIS MESS", "The Chaplain was the only survivor in the shuttle.", 1250)

			if(H.is_wearing_item_of_type(/obj/item/clothing/mask/luchador) && H.is_wearing_item_of_type(/obj/item/clothing/gloves/boxing))
				episode_names += new /datum/episode_name/rare("[pick("THE CREW, ON THE ROPES", "THE CREW, DOWN FOR THE COUNT", "[uppr_name], DOWN AND OUT")]", "The only survivor in the shuttle wore a luchador mask and boxing gloves.", 1500)

	if(human_escapees == 2)
		if(lawyercount == 2)
			episode_names += new /datum/episode_name/rare("DOUBLE JEOPARDY", "The only two survivors were IAAs or lawyers.", 2500)
		if(chefcount == 2)
			episode_names += new /datum/episode_name/rare("CHEF WARS", "The only two survivors were chefs.", 2500)
		if(minercount == 2)
			episode_names += new /datum/episode_name/rare("THE DOUBLE DIGGERS", "The only two survivors were miners.", 2500)
		if(clowncount == 2)
			episode_names += new /datum/episode_name/rare("A TALE OF TWO CLOWNS", "The only two survivors were clowns.", 2500)
			theme = "clown"
		if(clowncount == 1 && mimecount == 1)
			episode_names += new /datum/episode_name/rare("THE DYNAMIC DUO", "The only two survivors were the Clown, and the Mime.", 2500)

	else
		//more than 0 human escapees
		var/braindamage_total = 0
		var/all_braindamaged = TRUE
		for(var/mob/living/carbon/human/H as anything in popcount["human_escapees_list"])
			var/brain_damage = H.get_organ_loss(ORGAN_SLOT_BRAIN)
			if(brain_damage < 60)
				all_braindamaged = FALSE
				braindamage_total += brain_damage
		var/average_braindamage = braindamage_total / human_escapees
		if(average_braindamage > 30)
			episode_names += new /datum/episode_name/rare("[pick("THE CREW'S SMALL IQ PROBLEM", "OW! MY BALLS", "BR[pick("AI", "IA")]N DAM[pick("AGE", "GE", "AG")]", "THE VERY SPECIAL CREW OF [uppr_name]")]", "Average of [average_braindamage] brain damage for each human shuttle escapee.", min(1000, average_braindamage*10))
		if(all_braindamaged && human_escapees > 2)
			episode_names += new /datum/episode_name/rare("...AND PRAY THERE'S INTELLIGENT LIFE SOMEWHERE OUT IN SPACE, 'CAUSE THERE'S BUGGER ALL DOWN HERE IN [uppr_name]", "Everyone was braindamaged this round.", human_escapees * 500)

/proc/get_station_avg_temp()
	// fix later, DO NOT MERGE THIS YOU FUCK CAR \/
	/*var/avg_temp = 0
	var/avg_divide = 0
	for(var/obj/machinery/airalarm/alarm in GLOB.machines)
		var/turf/location = alarm.loc
		if(!istype(location) || !is_station_level(alarm.z))
			continue
		var/datum/gas_mixture/environment = location.return_air()
		if(!environment)
			continue
		avg_temp += environment.temperature
		avg_divide++

	if(avg_divide)
		return avg_temp / avg_divide
	return T0C*/
	return 69

/mob/living/carbon/proc/get_all_worn_items()
	return list(
		back,
		wear_mask,
		wear_neck,
		head,
		handcuffed,
		legcuffed,
	)

///Bruteforce check for any type or subtype of an item.
/mob/living/carbon/human/proc/is_wearing_item_of_type(type2check)
	var/found
	var/list/my_items = get_all_worn_items()
	if(islist(type2check))
		for(var/type_iterator in type2check)
			found = locate(type_iterator) in my_items
			if(found)
				return found
	else
		found = locate(type2check) in my_items
		return found


/mob/living/carbon/human/get_slot_by_item(obj/item/looking_for)
	if(looking_for == belt)
		return ITEM_SLOT_BELT

	if(looking_for == wear_id)
		return ITEM_SLOT_ID

	if(looking_for == ears)
		return ITEM_SLOT_EARS

	if(looking_for == glasses)
		return ITEM_SLOT_EYES

	if(looking_for == gloves)
		return ITEM_SLOT_GLOVES

	if(looking_for == head)
		return ITEM_SLOT_HEAD

	if(looking_for == shoes)
		return ITEM_SLOT_FEET

	if(looking_for == wear_suit)
		return ITEM_SLOT_OCLOTHING

	if(looking_for == w_uniform)
		return ITEM_SLOT_ICLOTHING

	if(looking_for == r_store)
		return ITEM_SLOT_RPOCKET

	if(looking_for == l_store)
		return ITEM_SLOT_LPOCKET

	if(looking_for == s_store)
		return ITEM_SLOT_SUITSTORE

	return ..()


/mob/living/carbon/get_slot_by_item(obj/item/looking_for)
	if(looking_for == back)
		return ITEM_SLOT_BACK

	if(back && (looking_for in back))
		return ITEM_SLOT_BACKPACK

	if(looking_for == wear_mask)
		return ITEM_SLOT_MASK

	if(looking_for == wear_neck)
		return ITEM_SLOT_NECK

	if(looking_for == head)
		return ITEM_SLOT_HEAD

	if(looking_for == handcuffed)
		return ITEM_SLOT_HANDCUFFED

	if(looking_for == legcuffed)
		return ITEM_SLOT_LEGCUFFED

	return ..()
