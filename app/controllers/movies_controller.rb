class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @url = request.original_url
    if ! (@url =~ /movies/)
      session.clear
    end
    
    if params[:ratings].nil? && params[:sort].nil? && (!session[:ratings].nil? || !session[:sort].nil?)
      params[:ratings] = session[:ratings]
      params[:sort] = session[:sort]
    end
    
    if params[:ratings].nil? && params[:sort].nil?
      @movies = Movie.all
      session[:ratings] = nil
      session[:sort] = nil
    elsif params[:ratings].nil?
      @movies = Movie.order(params[:sort]) 
      session[:ratings] = nil
      session[:sort] = params[:sort]
    elsif params[:sort].nil?
      @params_ratings = params[:ratings]
      @movies = Movie.where("rating IN (?)",@params_ratings.keys)
      session[:sort] = nil
      session[:ratings] = params[:ratings]
    else
      @params_ratings = params[:ratings]
      @movies = Movie.where("rating IN (?)",@params_ratings.keys).order(params[:sort])
      session[:sort] = params[:sort]
      session[:ratings] = params[:ratings]
    end
    
    @sort_column = params[:sort]
    
    if params[:sort] == "title"
      @text_class_title = "text-success"
    else
      @text_class = "text-primary"
    end
    if params[:sort] == "release_date"
      @text_class_date = "text-success"
    else
      @text_class = "text-primary"
    end
    
    @all_ratings = Movie.ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
