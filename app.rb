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

get '/posts' do
  @posts = Post.all
  @post = Post.new
  erb :posts
end

post '/posts' do
  @post = Post.new(params[:post] || {})
  if @post.save
    redirect to('/posts')
  else
    erb :posts
  end
end

post '/posts.json' do
  sleep(1);
  @post = Post.new(params[:post] || {})
  if @post.save
    json @post.attributes
  else
    status 422
    json @post.errors.to_hash
  end
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
