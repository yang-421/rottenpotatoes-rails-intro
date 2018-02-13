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
    @movies = Movie.all #load all movies
    @sort = params[:sort] #gets sort parameter from HTTP address to know if sorting titles or release dates
    @ratings = params[:ratings]
    @all_ratings = Movie.all_ratings #load all ratings enum types
    
    puts "RATINGS: #{@ratings}"
    puts "Session Ratings: #{session[:ratings]}"
    puts "SORT: #{@sort}"
    puts "Session Sort: #{session[:sort]}"
    
  
    #Filter
    if !params[:ratings].nil?
      if !@ratings.kind_of?(Array) then @ratings = @ratings.keys end
      @movies = @movies.where(:rating => @ratings)
      
    elsif !session[:ratings].nil?
      @ratings = session[:ratings]
      if !@ratings.kind_of?(Array) and !@ratings.nil? then @ratings = @ratings.keys end
      @movies = @movies.where(:rating => @ratings)
    end
    
    if @ratings.nil?
      @ratings = Movie.all_ratings
    end

    #Sorting
    if !@sort.nil?
      @movies = @movies.order(@sort)
      @hilite = params[:sort]
      
    else
      @sort = session[:sort]
      @movies = @movies.order(@sort)
      @hilite = session[:sort]
    end
    
    session[:sort] = @sort
    session[:ratings] = @ratings
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

