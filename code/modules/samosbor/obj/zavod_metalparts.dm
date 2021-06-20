/obj/item/weapon/metalpart
	icon = 'icons/samosbor/obj/metalparts.dmi'
	var/hot = 0

/obj/item/weapon/metalpart/grablihead
	name = "metal plate with teeth"
	desc = "������������&#255; �������� � �������."
	icon_state = "grablihead"

/obj/item/weapon/blueprints
	name = "blueprints"
	desc = "������� �����-�� ������..."
	var/desc_adv = "������ ���-282 ������������� ������, ������� �� ���������� � �������."
	icon = 'icons/obj/items.dmi'
	icon_state = "blueprints"
	var/part = /obj/item/weapon/metalpart

/obj/item/weapon/blueprints/attack_self(mob/M as mob)
	if (!istype(M,/mob/living/carbon/human) || M.int <= 7)
		to_chat(M, "������ �����&#255;���...")
		return
	else
		to_chat(M, desc_adv)
		return

/obj/item/weapon/blueprints/grablihead
	desc_adv = "������ ���-80 ������������� �������� � �������, ������������� ��������������� ��&#255; �������&#255; ������� �������."
	part = /obj/item/weapon/metalpart/grablihead
	name = "grabli head blueprint"
	icon_state = "grablihead"