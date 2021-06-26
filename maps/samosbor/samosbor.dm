#if !defined(using_map_DATUM)

	#include "samosbor_areas.dm"
	#include "samosbor_shuttles.dm"
	#include "samosbor_unit_testing.dm"
	#include "samosbor_lift.dm"

	#include "samosbor.dmm"
	#include "samosbor-inf4.dmm"
	#include "samosbor-templates.dmm"

	//#include "../../code/modules/lobby_music/generic_songs.dm"

	#define using_map_DATUM /datum/map/samosbor

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Samosbor

#endif
