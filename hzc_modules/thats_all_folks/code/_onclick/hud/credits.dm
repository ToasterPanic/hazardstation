/atom/movable/screen/credit
	icon = 'icons/hud/screen_alert.dmi'
	icon_state = "default"
	name = "Credits Text"
	desc = "Something seems to have gone wrong with this alert, so report this bug please"
	mouse_opacity = MOUSE_OPACITY_ICON

	/// do we glow to represent we do stuff when clicked
	var/clickable_glow = FALSE
	var/timeout = 0 //If set to a number, this alert will clear itself after that many deciseconds
	var/severity = 0
	var/alerttooltipstyle = ""
	var/override_alerts = FALSE //If it is overriding other alerts of the same type
	var/mob/owner //Alert owner

	/// Boolean. If TRUE, the Click() proc will attempt to Click() on the master first if there is a master.
	var/click_master = TRUE

/atom/movable/screen/credit/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	if(clickable_glow)
		add_filter("clickglow", 2, outline_filter(color = COLOR_GOLD, size = 1))
		mouse_over_pointer = MOUSE_HAND_POINTER

/mob/proc/add_credits_text_ui(text)

	if(QDELETED(src))
		return

	SHOULD_NOT_SLEEP(TRUE)

	src.balloon_alert_credit_perform(src, text)

	/*if(credit.timeout)
		addtimer(CALLBACK(src, PROC_REF(credit_timeout), credit, category), credit.timeout)
		credit.timeout = world.time + credit.timeout - world.tick_lag*/

/proc/send_credits_to_all(text)
	for(var/mob/M in GLOB.mob_list)
		if(M.mind)
			M.add_credits_text_ui(text)

/proc/play_hz_credits()
	send_credits_to_all("<b>Nanotrasen's Space Station 13</b>")
	sleep(3 SECONDS)
	send_credits_to_all("<b>Filmed on Location at [station_name()]</b>")
	sleep(5 SECONDS)
	send_credits_to_all("<b style='color: green;'>Contributors</b>")
	sleep(2 SECONDS)

	var/contributors = world.file2list("config/contributors.txt")
	for(var/contributor in contributors)
		send_credits_to_all(contributor)
		sleep(2 SECONDS)

	sleep(3 SECONDS)

	send_credits_to_all("<b style='color: cyan;'>Cast</b>")
	sleep(2 SECONDS)

	for(var/mob/M in GLOB.player_list)
		if (M.mind)
			send_credits_to_all("[M.name] (played by [M.mind.key])")
			sleep(2 SECONDS)

	for(var/mob/living/silicon/S in GLOB.silicon_mobs)
		if (S.mind)
			send_credits_to_all("[S.name] (played by [S.mind.key])")
			sleep(2 SECONDS)

	sleep(3 SECONDS)

	send_credits_to_all("<b>Sponsored by [pick(list("Dr. Gibb", "Robust Coffee", "Grey Bull", "Canned Air", "Cargonia", "The Very Agressive Crab", "Homosexuality", "The Honkmother", "Space Jesus"))]</b>")

	sleep(5 SECONDS)

	send_credits_to_all("<b>Credits will continue momentarily.</b>")
	sleep(5 SECONDS)

/proc/play_hz_credits_end()
	send_credits_to_all("<b style='color: red; -dm-text-outline: 1px white'>The round has ended. Go wild!</b>")
	sleep(3 SECONDS)
	send_credits_to_all("<b style='color: #f88;'>Antagonists</b>")
	sleep(5 SECONDS)

	if (GLOB.antagonists.len)
		for(var/datum/antagonist/A in GLOB.antagonists)
			if(!A.owner)
				continue

			send_credits_to_all("<b>[A.owner.name] (played by [A.owner.key]) was [A.name]!</b>")
			sleep(3 SECONDS)

			if(A.objectives.len)
				var/increment = 1
				for(var/datum/objective/O in A.objectives)
					var/result = O.check_completion() ? "SUCCESS" : "FAIL"
					send_credits_to_all("<span style='color: [O.check_completion() ? "green" : "red"]'>Objective [increment]: [O.explanation_text]</span>")
					sleep(3 SECONDS)
					increment += 1
	else
		send_credits_to_all("None!")

	sleep(3 SECONDS)

	send_credits_to_all("<b>Thanks for playing!</b>")
	sleep(5 SECONDS)
