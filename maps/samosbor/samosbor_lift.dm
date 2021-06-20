/obj/turbolift_map_holder/samosbor
	name = "Samosbor turbolift map placeholder"
	depth = 26
	lift_size_x = 4
	lift_size_y = 4
	z_step = 2

	areas_to_use = list(
		/area/turbolift/zero_two,
		/area/turbolift/first,
		/area/turbolift/second,
		/area/turbolift/third,
		/area/turbolift/fouth,
		/area/turbolift/fifth,
		/area/turbolift/sixth,
		/area/turbolift/seventh,
		/area/turbolift/eighth,
		/area/turbolift/ninth,
		/area/turbolift/tenth,
		/area/turbolift/eleventh,
		/area/turbolift/twelfth
		)


//Turbolift
/area/turbolift
	name = "\improper Turbolift"
	icon_state = "shuttle"
	requires_power = 0
	dynamic_lighting = 1
	//area_flags = AREA_FLAG_RAD_SHIELDED

/area/turbolift/zero_two
	name = "lift (Zero floor)"
	lift_floor_label = "floor �654"
	lift_floor_name = "DERELICT TERRITORY! DANGER!"

/area/turbolift/first
	name = "lift (First floor)"
	lift_floor_label = "floor �661"
	lift_floor_name = "1st inhabited floor"

/area/turbolift/second
	name = "lift (Second floor)"
	lift_floor_label = "floor �662"
	lift_floor_name = "2nd inhabited floor"
	base_turf = /turf/simulated/open

/area/turbolift/third
	name = "lift (Third floor)"
	lift_floor_label = "floor �663"
	lift_floor_name = "3rd inhabited floor"
	base_turf = /turf/simulated/open

/area/turbolift/fouth
	name = "lift (Fouth floor)"
	lift_floor_label = "floor �664"
	lift_floor_name = "4th inhabited floor"
	base_turf = /turf/simulated/open

/area/turbolift/fifth
	name = "lift (Fifth floor)"
	lift_floor_label = "floor �665"
	lift_floor_name = "5th inhabited floor"
	base_turf = /turf/simulated/open

/area/turbolift/sixth
	name = "lift (Sixth floor)"
	lift_floor_label = "floor �667"
	lift_floor_name = "6th inhabited floor"
	base_turf = /turf/simulated/open

/area/turbolift/seventh
	name = "lift (Seventh floor)"
	lift_floor_label = "floor �668"
	lift_floor_name = "7th inhabited floor"
	base_turf = /turf/simulated/open

/area/turbolift/eighth
	name = "lift (Eighth floor)"
	lift_floor_label = "floor �669"
	lift_floor_name = "8th inhabited floor"
	base_turf = /turf/simulated/open

/area/turbolift/ninth
	name = "lift (Ninth floor)"
	lift_floor_label = "floor �670"
	lift_floor_name = "9th inhabited floor"
	base_turf = /turf/simulated/open

/area/turbolift/tenth
	name = "lift (Tenth floor)"
	lift_floor_label = "floor �671"
	lift_floor_name = "10th inhabited floor"
	base_turf = /turf/simulated/open

/area/turbolift/eleventh
	name = "lift (Eleventh floor)"
	lift_floor_label = "floor �676"
	lift_floor_name = "Canteen"
	base_turf = /turf/simulated/open

/area/turbolift/twelfth
	name = "lift (Twelfth floor)"
	lift_floor_label = "floor �677"
	lift_floor_name = "Liquidators' floor"
	base_turf = /turf/simulated/open