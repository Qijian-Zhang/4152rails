class MoviesController < ApplicationController

  before_action :set_ratings

  def set_ratings
    @all_ratings = Movie.all_ratings

    if params[:ratings]
      @ratings_to_show = params[:ratings].keys
      session[:rating]=@ratings_to_show
    else
      @ratings_to_show = []
      if not session[:rating]
        @ratings_to_show = @all_ratings
        session[:rating]=@ratings_to_show
      end
    end
     

  end



  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def column_header_class(sort_column)
    classes = []

    if @selected_sort == sort_column
      classes << 'p-3 mb-2'
      classes << 'hilite'
      classes << 'bg-warning' 
    end

    classes.join(' ')
  end



  def index
    if params[:home]
      session[:rating]=@ratings_to_show
    else
      @ratings_to_show= session[:rating]
    end



    if params[:sorted]
      if params[:sorted] == 'title'
        @movies=Movie.sort_by_name(session[:rating])
        session[:sorted]=params[:sorted]
      else
        @movies=Movie.sort_by_time(session[:rating])
        session[:sorted]=params[:sorted]
      end
    else
      if session[:sorted] == 'title'
        @movies=Movie.sort_by_name(session[:rating])
      elsif session[:sorted] == 'time'
        @movies=Movie.sort_by_time(session[:rating])
      else
        @movies = Movie.with_ratings(session[:rating])
      end
      
    end




    

    @selected_sort = session[:sorted]
    @title_css = column_header_class('title')
    @time_css = column_header_class('time')


  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path(sorted: session[:sorted], ratings: session[:rating].each_with_object({}) { |rating, hash| hash[rating] = '1' })
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
    redirect_to movies_path(sorted: session[:sorted], ratings: session[:rating].each_with_object({}) { |rating, hash| hash[rating] = '1' })
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)

  end

  
end
