/obj/item/weapon/concrete_gun
	name = "Concrete-Thrower BR73"
	desc = "����������������� �������� ���������� ����������&#255; ��-73, ������������� ��������������� ���� �481-18. ������� �� ������������� ������� ����������������� ���������� �������� � ������������ ��������������. ���������� ���� ������������ ��� ������ � ��������!"
	icon = 'icons/samosbor/obj/weapons.dmi'
	icon_state = "concrete_gun"
	item_state = "concrete_gun"
	hitsound = 'sound/weapons/smash.ogg'
	flags = CONDUCT
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BELT|SLOT_BACK
//	throwforce = 10
	throw_speed = 2
	throw_range = 2
	force = 5
	matter = list(DEFAULT_WALL_MATERIAL = 500)
	attack_verb = list("���� ���������", "���� ������")

	var/operating = 0//cooldown
	var/turf/previousturf = null
	var/obj/item/weapon/tank/concrete/ptank = null
	var/safety = 1

/obj/item/weapon/concrete_gun/examine()
	. = ..()
	if(safety == 1)
		to_chat(usr, "�������������� <font color = green>�������</font>.")
	else
		to_chat(usr, "�������������� <font color = red>��������</font>.")
	if(ptank)
		to_chat(usr, "<span class='notice'>������� ��������� ���������� �������� � [ptank.amount ? ptank.amount : 0] ��.</span>")

/obj/item/weapon/concrete_gun/Destroy()
	qdel_null(ptank)
	. = ..()

/obj/item/weapon/concrete_gun/update_icon()
	if(ptank)
		icon_state = "concrete_gun_full"
		item_state = "concrete_gun_full"
	return

/obj/item/weapon/concrete_gun/attackby(obj/item/W as obj, mob/user as mob)
	if(user.stat || user.restrained() || user.lying)	return
	if(iswrench(W))//Taking this apart
		var/turf/T = get_turf(src)
		if(ptank)
			ptank.loc = T
			ptank = null
			user << "�� ���������� ��� � ������ �������."
			src.update_icon()
		return



	if(istype(W,/obj/item/weapon/tank/concrete))
		if(ptank)
			to_chat(user, "<span class='notice'>��� � ������ ������� ��� �����!</span>")
			return

		user.drop_item()
		ptank = W
		W.loc = src
		src.update_icon()
		return

	..()
	return

/obj/item/weapon/concrete_gun/attack_self(mob/user as mob)
	if(user.stat || user.restrained() || user.lying)	return
	if(!safety)
//		if(user.INTELLEKT > 10)	��������� ����� � ���� ���������
//			to_chat(user, "<span class='notice'>�� ������� ��������������!</span>")
		to_chat(user, "<span class='notice'>�� ���-�� �������!</span>")
		playsound(loc, 'sound/weapons/empty.ogg', 50, 1, -1)
		safety = 1
	else
//		if(user.INTELLEKT > 10)	��������� ����� � ���� ���������
//			to_chat(user, "<span class='notice'>�� �������� ��������������!</span>")
		to_chat(user, "<span class='notice'>�� ���-�� �������!</span>")
		playsound(loc, 'sound/weapons/empty.ogg', 50, 1, -1)
		safety = 0

/obj/item/weapon/concrete_gun/proc/concrete_turf(var/turf/target)
	if(safety || ptank.amount <= 0)
		usr << "<b>������ ����!</b>"
		playsound(loc, 'sound/weapons/empty.ogg', 50, 1, -1)

	ptank.amount -= rand(75,125)
	if(ptank.amount < 0)
		ptank.amount = 0
	playsound(loc, 'sound/effects/attackblob.ogg', 50, 1, -1)
	new /obj/effect/effect/foam/concrete(target)
/*	var/F
	for(F in target)
		if(prob(40))
			new /turf/simulated/concrete_raw(F) �������� ��� ���� */
	operating = 0
	return

/obj/item/weapon/tank/concrete
	name = "liquid concrete tank"
	desc = "��������� � ������ ���������������� �������� ���������. �� ������ ���&#255;�!"
	icon = 'icons/samosbor/obj/weapons.dmi'
	icon_state = "concrete_tank"
	gauge_icon = null      // �� ���
	flags = CONDUCT
	slot_flags = null	//they have no straps!
	var/amount = 2000

/turf/simulated/floor/attackby(obj/item/C as obj, mob/user as mob)
	if (istype(C, /obj/item/weapon/concrete_gun))
		var/obj/item/weapon/concrete_gun/G = C
		visible_message("<span class = 'notice'>[user] �������� �� ����� ����� �������.</span>")

		G.concrete_turf(src)

	..()