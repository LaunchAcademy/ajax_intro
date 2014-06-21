require 'sinatra'
require 'sinatra/json'
require 'json'

configure do
  set :views, 'app/views'
  set :public_folder, 'public'
end

Dir[File.join(File.dirname(__FILE__), 'app', '**', '*.rb')].each do |file|
  require file
end

get '/' do
  erb :index
end

get '/time.json' do
  time = Time.now.strftime('%I:%M:%S %p')
  json({
    time: time
  })
end

get '/slow_time.json' do
  sleep(3)
  time = Time.now.strftime('%I:%M:%S %p')
  json({
    time: time
  })
end

get '/failing_time.json' do
  raise 'our clock is broken'
end

get '/teams.json' do
  sleep(2)
  @teams = Team.all
  json @teams
end
