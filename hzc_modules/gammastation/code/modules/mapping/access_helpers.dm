/obj/effect/mapping_helpers/airlock/access/any/service/nebulamart/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_NEBULAMART
	return access_list

/obj/effect/mapping_helpers/airlock/access/all/service/nebulamart/get_access()
	var/list/access_list = ..()
	access_list += ACCESS_NEBULAMART
	return access_list
