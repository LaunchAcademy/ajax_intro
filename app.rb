require 'sinatra'
require 'sinatra/json'
require 'json'

configure do
  set :views, 'app/views'
end

Dir[File.join(File.dirname(__FILE__), 'app', '**', '*.rb')].each do |file|
  require file
end

get '/' do
  erb :index
end

get '/teams.json' do
  @teams = Team.all
  json @teams
end
