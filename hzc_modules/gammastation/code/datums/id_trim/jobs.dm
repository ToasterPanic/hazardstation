/datum/id_trim/job/store_clerk
	assignment = JOB_STORE_CLERK
	trim_state = "trim_store_clerk"
	department_color = COLOR_SERVICE_LIME
	subdepartment_color = COLOR_SERVICE_LIME
	sechud_icon_state = SECHUD_ASSISTANT
	minimal_access = list(
		ACCESS_NEBULAMART,
		ACCESS_SERVICE,
		ACCESS_MAINT_TUNNELS,
		)
	extra_access = list(
		ACCESS_NEBULAMART,
		ACCESS_SERVICE,
		ACCESS_MAINT_TUNNELS,
		ACCESS_CARGO,
	)
	template_access = list(
		ACCESS_CAPTAIN,
		ACCESS_CHANGE_IDS,
		ACCESS_HOP,
		)
	job = /datum/job/store_clerk
