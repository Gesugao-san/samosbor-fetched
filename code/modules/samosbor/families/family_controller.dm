
/datum/family_record
	var/surname = ""
	var/players = list()

var/global/datum/controller/subsystem/families/families_controller

/datum/controller/subsystem/families
	var/list/family_players_pool = list()
	var/list/families = list()


/datum/controller/subsystem/families/Initialize()
	name = "Families"
	wait = 100
	families_controller = src
	SSjobs.reset_occupations()

/datum/controller/subsystem/families/fire(resumed = 0)
	SSjobs.reset_occupations()
	SSjobs.divide_occupations(config.pick_mode("extended"))
	spawn_families()

/datum/controller/subsystem/families/proc/spawn_families()
	for(var/mob/new_player/player in GLOB.player_list)
		if(player && player.ready && player.mind && player.mind.assigned_role && player.client)
			family_players_pool += player

	while(family_players_pool.len)
		var/mob/new_player/player = family_players_pool[1]
		if(player && player.ready && player.mind)
			if(player.mind.assigned_role=="AI")
				player.close_spawn_windows()
				player.AIize()
			else if(!player.mind.assigned_role)
				continue
			else
				var/f = list()

				f += player
				family_players_pool.Remove(player)

				if(family_players_pool.len)
					var/picked = pick(family_players_pool)
					f += picked

					family_players_pool.Remove(picked)




				var/datum/family_record/fr = new()
				fr.surname = pick(GLOB.rus_last_names)
				fr.players = f

				families += fr

				var/id = families.Find(fr)

				for(var/mob/new_player/p in fr.players)
					var/datum/spawnpoints/S = GLOB.family_join["[id]"]
					if(!istype(S) || !GLOB.family_join.len || !S)
						error("There is no family_join.")
						crash_with("ERROR: There is no family_join.")

					var/turf/T = get_turf(S.PickPoint())

					p.mind.family_id = id

					if(p.mind.assigned_role == "Dweller")
						var/mob/living/C = p.create_character(T, fr.surname)
						if(C)
							SSjobs.equip_rank(C, C.mind.assigned_role, 0)
							// UpdateFactionList(player)
							qdel(player)
					else
						var/mob/living/C = p.create_character(null, fr.surname)
						if(C)
							SSjobs.equip_rank(C, C.mind.assigned_role, 0)
							// UpdateFactionList(C)
							qdel(player)
