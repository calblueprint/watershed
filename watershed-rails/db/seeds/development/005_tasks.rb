#Tasks

user_count = User.count
site_count = Site.count

tasks = ["Water",
		"Prune",
		"Weed",
		"Clear inlet/outlet",
		"Re-Plant",
		"Hardware Fix",
		"Outreach",
		"Other"]

(0..20).each do |task_number|
	example_task = Task.where(
		title: "Task #{task_number}",
		description: tasks.sample,
		assignee_id: rand(0..user_count),
		assigner_id: rand(0..user_count),
		site_id: rand(0..site_count),
		complete: false,
		due_date: Time.now,
	).first_or_create
	puts "Created Task: Report #{task_number}: for User #{example_task.assignee_id} by User #{example_task.assigner_id} to do #{example_task.description}"
end
