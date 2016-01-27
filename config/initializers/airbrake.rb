Airbrake.configure do |c|
	c.ignore_environments = %w(development test)
  c.project_key = ENV['AIRBRAKE_PROJECT_KEY']
  c.project_id = ENV['AIRBRAKE_PROJECT_ID']
end
