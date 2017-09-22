class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sort = params[:sort] || session[:sort]
    @all_ratings = Movie.get_all_ratings
    @selected = params[:ratings] || session[:ratings] || {}
    p @selected
    p "*"*80
    
    if @selected == {}
      @all_ratings.each do |x|
        session[:ratings][x] = 1
        p "*"*80
        p session[ratings]
      end
    end
    
    if sort == 'release_date'
      ordering = {:release_date => 'asc'}
      @release_date_header = 'hilite'
    elsif sort == 'title'
      ordering = {:title => 'asc'}
      @title_header = 'hilite'
    end
    
    if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
      session[:sort] = sort
      session[:ratings] = @selected
      flash.keep
      redirect_to movies_path :sort => sort, :ratings => @selected and return
    end
    
    @movies = Movie.where(rating: @selected.keys).order(ordering)
    
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

end
