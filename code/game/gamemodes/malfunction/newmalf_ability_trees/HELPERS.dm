// Verb: ai_select_hardware()
// Parameters: None
// Description: Allows AI to select it's hardware module.
/datum/game_mode/malfunction/verb/ai_select_hardware()
	set category = "Hardware"
	set name = "Select Hardware"
	set desc = "Allows you to select hardware piece to install"
	var/mob/living/silicon/ai/user = usr

	if(!ability_prechecks(user, 0, 1))
		return

	if(user.hardware)
		user << "You have already selected your hardware."
		return

	var/possible_choices = list("APU Generator", \
							"Turrets Focus Enhancer", \
							"Secondary Processor Unit",\
							"Secondary Memory Bank",\
							"Self-Destruct Explosives",\
							"CANCEL")
	var/choice = input("Select desired hardware. You may only choose one hardware piece!: ") in possible_choices
	if(choice == "CANCEL")
		return
	var/note = null
	switch(choice)
		if("APU Generator")
			note = "APU Generator - When enabled it will keep your core powered. Power output is not large enough so your abilities won't be available while running on APU power. It is also very fragile and prone to failure when your physical core is damaged."
		if("Turrets Focus Enhancer")
			note = "Overcharges turrets to shoot faster. Turrets will also gain higher health and passive regeneration. This however massively increases power usage of turrets, espicially when regenerating."
		if("Secondary Processor Unit")
			note = "Doubles your CPU time generation."
		if("Secondary Memory Bank")
			note = "Doubles your CPU time storage."
		if("Self-Destruct Explosives")
			note = "High yield explosives are attached to your physical mainframe. This hardware comes with activation driver. Explosives will destroy your core and everything around it."
	if(!note)
		return

	var/confirmation = input("[note] - Is this what you want?") in list("Yes", "No")
	if(confirmation != "Yes")
		user << "Selection cancelled. Use command again to select"
		return

	switch(choice)
		if("APU Generator")
			user.hardware = new/datum/malf_hardware/apu_gen()
			user.verbs += new/datum/game_mode/malfunction/verb/ai_toggle_apu()
		if("Turrets Focus Enhancer")
			user.hardware = new/datum/malf_hardware/strong_turrets()
			for(var/obj/machinery/turret/T in machines)
				T.maxhealth += 30
				T.shot_delay = 7 // Half of default time.
				T.auto_repair = 1
				T.active_power_usage = 25000
			for(var/obj/machinery/porta_turret/T in machines)
				T.maxhealth += 30
				T.shot_delay = 7 // Half of default time.
				T.auto_repair = 1
				T.active_power_usage = 25000
		if("Secondary Processor Unit")
			user.hardware = new/datum/malf_hardware/dual_cpu()
		if("Secondary Memory Bank")
			user.hardware = new/datum/malf_hardware/dual_ram()
		if("Self-Destruct Explosives")
			user.hardware = new/datum/malf_hardware/core_bomb()
			user.verbs += new/datum/game_mode/malfunction/verb/ai_self_destruct()


// Verb: ai_help()
// Parameters: None
// Descriptions: Opens help file and displays it to the AI.
/datum/game_mode/malfunction/verb/ai_help()
	set category = "Hardware"
	set name = "Display Help"
	set desc = "Opens help window with overview of available hardware, software and other important information."
	var/mob/living/silicon/ai/user = usr

	var/help = file2text("ingame_manuals/malf_ai.txt")
	if(!help)
		help = "Error loading help (file /ingame_manuals/malf_ai.txt is probably missing). Please report this to server administration staff."

	user << browse(help, "window=malf_ai_help;size=600x500")


// Verb: ai_select_research()
// Parameters: None
// Description: Allows AI to select it's next research priority.
/datum/game_mode/malfunction/verb/ai_select_research()
	set category = "Hardware"
	set name = "Select Research"
	set desc = "Allows you to select your next research target."
	var/mob/living/silicon/ai/user = usr

	if(!ability_prechecks(user, 0, 1))
		return

	var/datum/malf_research/res = user.research
	var/datum/malf_research_ability/tar = input("Select your next research target") in res.available_abilities
	if(!tar)
		return
	res.focus = tar
	user << "Research set: [tar.name]"

// HELPER PROCS
// Proc: ability_prechecks()
// Parameters 2 - (user - User which used this ability check_price - If different than 0 checks for ability CPU price too. Does NOT use the CPU time!)
// Description: This is pre-check proc used to determine if the AI can use the ability.
/proc/ability_prechecks(var/mob/living/silicon/ai/user = null, var/check_price = 0, var/override = 0)
	if(!user)
		return 0
	if(!istype(user))
		user << "GAME ERROR: You tried to use ability that is only available for malfunctioning AIs, but you are not AI! Please report this."
		return 0
	if(!user.malfunctioning)
		user << "GAME ERROR: You tried to use ability that is only available for malfunctioning AIs, but you are not malfunctioning. Please report this."
		return 0
	if(!user.research)
		user << "GAME ERROR: No research datum detected. Please report this."
		return 0
	if(user.research.max_cpu < check_price)
		user << "Your CPU storage is not large enough to use this ability. Hack more APCs to continue."
		return 0
	if(user.research.stored_cpu < check_price)
		user << "You do not have enough CPU power stored. Please wait a moment."
		return 0
	if(user.hacking && !override)
		user << "Your system is busy processing another task. Please wait until completion."
		return 0
	if(user.APU_power && !override)
		user << "Low power. Unable to proceed."
		return 0
	return 1

// Proc: ability_pay()
// Parameters 2 - (user - User from which we deduct CPU from, price - Amount of CPU power to use)
// Description: Uses up certain amount of CPU power. Returns 1 on success, 0 on failure.
/proc/ability_pay(var/mob/living/silicon/ai/user = null, var/price = 0)
	if(!user)
		return 0
	if(user.APU_power)
		user << "Low power. Unable to proceed."
		return 0
	if(!user.research)
		user << "GAME ERROR: No research datum detected. Please report this."
		return 0
	if(user.research.max_cpu < price)
		user << "Your CPU storage is not large enough to use this ability. Hack more APCs to continue."
		return 0
	if(user.research.stored_cpu < price)
		user << "You do not have enough CPU power stored. Please wait a moment."
		return 0
	user.research.stored_cpu -= price
	return 1

// Proc: announce_hack_failure()
// Parameters 2 - (user - hacking user, text - Used in alert text creation)
// Description: Uses up certain amount of CPU power. Returns 1 on success, 0 on failure.
/proc/announce_hack_failure(var/mob/living/silicon/ai/user = null, var/text)
	if(!user || !text)
		return 0
	var/fulltext = ""
	switch(user.hack_fails)
		if(1)
			fulltext = "We have detected hack attempt into your [text]. The intruder failed to access anything of importance, but disconnected before we could complete our traces."
		if(2)
			fulltext = "We have detected another hack attempt. It was targeting [text]. The intruder almost gained control of the system, so we had to disconnect them. We partially finished trace and it seems to be originating either from the station, or it's immediate vicinity."
		if(3)
			fulltext = "Another hack attempt has been detected, this time targeting [text]. We are certain the intruder entered the network via terminal located somewhere on the station."
		if(4)
			fulltext = "We have finished our traces and it seems the recent hack attempts are originating from your AI system. We reccomend investigation."
		else
			fulltext = "Another hack attempt has been detected, targeting [text]. The source still seems to be your AI system."

	command_announcement.Announce(fulltext)

// Proc: get_unhacked_apcs()
// Parameters: None
// Description: Returns a list of APCs that are not yet hacked.
/proc/get_unhacked_apcs()
	var/list/H = list()
	for(var/obj/machinery/power/apc/A in machines)
		if(!A.hacker)
			H.Add(A)
	return H


// Helper procs which return lists of relevant mobs.
/proc/get_unlinked_cyborgs(var/mob/living/silicon/ai/A)
	if(!A || !istype(A))
		return

	var/list/L = list()
	for(var/mob/living/silicon/robot/RB in mob_list)
		if(istype(RB, /mob/living/silicon/robot/drone))
			continue
		L.Add(RB)
	return L

/proc/get_linked_cyborgs(var/mob/living/silicon/ai/A)
	if(!A || !istype(A))
		return
	return A.connected_robots

/proc/get_other_ais(var/mob/living/silicon/ai/A)
	if(!A || !istype(A))
		return

	var/list/L = list()
	for(var/mob/living/silicon/ai/AT in mob_list)
		L.Add(AT)
	return L
