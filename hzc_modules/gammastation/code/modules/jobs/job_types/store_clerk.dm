/*
Store Clerk
*/
/datum/job/store_clerk
	title = JOB_STORE_CLERK
	description = "Restock the Nebulamart, protect the Secure Display Room."
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 2
	supervisors = SUPERVISOR_HOP
	exp_granted_type = EXP_TYPE_CREW
	outfit = /datum/outfit/job/store_clerk
	plasmaman_outfit = /datum/outfit/plasmaman
	paycheck = PAYCHECK_CREW

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_COOK + 0.2

	departments_list = list(
		/datum/job_department/service,
		)

	family_heirlooms = list(/obj/item/storage/toolbox/mechanical/old/heirloom, /obj/item/clothing/gloves/cut/heirloom)

	mail_goodies = list(
		/obj/effect/spawner/random/food_or_drink/donkpockets = 10,
		/obj/item/clothing/mask/gas = 10,
		/obj/item/clothing/gloves/color/fyellow = 7,
		/obj/item/choice_beacon/music = 5,
		/obj/item/toy/sprayoncan = 3,
		/obj/item/crowbar/large = 1
	)

	job_flags = STATION_JOB_FLAGS
	rpg_title = "Lout"
	config_tag = "STORECLERK"

/datum/job/store_clerk/get_outfit(consistent)
	return /datum/outfit/job/store_clerk/preview

/datum/outfit/job/store_clerk
	name = JOB_STORE_CLERK
	jobtype = /datum/job/store_clerk
	id_trim = /datum/id_trim/job/store_clerk
	belt = /obj/item/modular_computer/pda/assistant

/datum/outfit/job/store_clerk/pre_equip(mob/living/carbon/human/target)
	..()
	give_holiday_hat(target)
	give_jumpsuit(target)

/datum/outfit/job/store_clerk/proc/give_holiday_hat(mob/living/carbon/human/target)
	for(var/holidayname in GLOB.holidays)
		var/datum/holiday/holiday_today = GLOB.holidays[holidayname]
		var/obj/item/special_hat = holiday_today.holiday_hat
		if(prob(HOLIDAY_HAT_CHANCE) && !isnull(special_hat) && isnull(head))
			head = special_hat

/datum/outfit/job/store_clerk/proc/give_jumpsuit(mob/living/carbon/human/target)
	if (target.jumpsuit_style == PREF_SUIT)
		uniform = /obj/item/clothing/under/color/blue
	else
		uniform = /obj/item/clothing/under/color/jumpskirt/blue

/datum/outfit/job/store_clerk/preview
	name = "Store Clerk - Preview"

/datum/outfit/job/store_clerk/preview/give_jumpsuit(mob/living/carbon/human/target)
	if (target.jumpsuit_style == PREF_SUIT)
		uniform = /obj/item/clothing/under/color/blue
	else
		uniform = /obj/item/clothing/under/color/jumpskirt/blue
