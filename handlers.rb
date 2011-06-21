require 'icalendar'
require 'date'
require 'open-uri'

require './panels'

config = YAML.load_file("config.yml")

get '/dashboard' do
  panels = {
    "calendar"      => Calendar.new(config["calendar_url"]),
    "working_on"    => WorkingOn.new,
  }
  if (panel = params[:panel])
    presenter = panels[panel]
    erb panel.to_sym, :locals => presenter.context, :layout => false
  else
    erb :dashboard, :locals => { :panels => panels }
  end
end

require './winston'

post '/winston.json' do
  message_text = params["body"].gsub(/(W|w)inston(,)? /,'').strip
  response = WINSTON.message(message_text,params)
  content_type :json
  {:message => response}.to_json
end
