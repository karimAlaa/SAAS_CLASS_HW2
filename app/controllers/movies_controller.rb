class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
	@all_ratings = Movie.select(:rating).map(&:rating).uniq
	
	session[:ratings]=params[:ratings] if params[:ratings]
	session[:order]=params[:ord] if params[:ord]
	redir_req=true unless params[:ord]||params[:ratings]
	
	if redir_req && session[:ratings]
		params[:ord]=session[:order]
		params[:ratings]=session[:ratings]
    		flash.keep
    		redirect_to movies_path(params.slice(:ord,:ratings))		
	end

	if session[:ratings]
		@selected_ratings=session[:ratings].keys
	else
		@selected_ratings= @all_ratings
	end

	if session[:order]
		@movies= Movie.where(:rating => @selected_ratings).order(session[:order])
		@th_class='hilite'
	else
    		@movies = Movie.where(:rating => @selected_ratings).all
	end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
