require('sinatra')
require('sinatra/contrib/all')
require_relative('models/film')
also_reload('models/*')

get '/films' do
    @films = Film.find_all()
    erb(:index)
end

get '/films/jurassic_park' do
    @films = Film.find_all()
    erb(:jurassic_park)
end

get '/films/jaws' do
    @films = Film.find_all()
    erb(:jaws)
end

get '/films/indiana_jones' do
    @films = Film.find_all()
    erb(:indiana_jones)
end