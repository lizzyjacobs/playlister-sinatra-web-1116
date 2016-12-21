require 'rack-flash'
class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  enable :sessions
  use Rack::Flash
  set :session_secret, "my_application_secret"
  set :views, Proc.new { File.join(root, "../views/") }


  get '/' do
    erb :index
  end

  get '/songs' do
    @songs = Song.all
    erb :song_index
  end

  get '/songs/new' do
    @genres = Genre.all
    erb :song_new
    # binding.pry
  end

  post '/songs' do

    @song = Song.create(params[:song])
      # binding.pry
    if Artist.find_by_name(params["artist"]["name"]) != nil
      @song.artist = Artist.find_by_name(params["artist"]["name"])
    else
      @song.artist = Artist.create(name: params["artist"]["name"])
    end
    params['genre']["ids"].each do |id|
      @song.genres << Genre.find(id)
    end
    @song.save
    flash[:message] = "Successfully created song."
    redirect "/songs/#{@song.slug}"
  end

  get '/artists' do
    @artists = Artist.all
    erb :artist_index
  end

  get '/genres' do
    @genres = Genre.all
    erb :genre_index
  end

  get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    erb :song_show
  end

  get '/songs/:slug/edit' do
    @song = Song.find_by_slug(params[:slug])
    @genres = Genre.all
    erb :song_edit
  end

  patch '/songs/:slug/' do
    @song = Song.find(name: params[:song][:name])
    if Artist.find_by_name(params["artist"]["name"]) != nil
      @song.artist = Artist.find_by_name(params["artist"]["name"])
    else
      @song.artist = Artist.update(name: params["artist"]["name"])
    end
    params['genre']["ids"].each do |id|
      @song.genres << Genre.find(id)
    end
    @song.save
    flash[:message] = "Successfully updated song."
    redirect "/songs/#{@song.slug}"
  end

  get '/artists/:slug' do
    @artist = Artist.find_by_slug(params[:slug])
    erb :artist_show
  end

  get '/genres/:slug' do
    @genre = Genre.find_by_slug(params[:slug])
    erb :genre_show
  end




end
