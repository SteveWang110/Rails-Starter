class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]
  before_action :set_sort_session, only: [ :index ]

  helper_method :toggle # Make this helper available in views
  helper_method :highlight_column
  helper_method :sort_indicator

  def highlight_column(column)
    if @sort_column == column
      @sort_direction == "asc" ? "hasc" : "hdesc"
    else
      ""
    end
  end

  def sort_indicator(column)
    if @sort_column == column
      @sort_direction == "asc" ? "▲" : "▼"
    else
      ""
    end
  end

  # GET /movies or /movies.json

  def set_sort_session
    @sort_column = params[:sort] || session[:sort_column] || "title"    # remember session
    @sort_direction = params[:direction] || session[:sort_direction] || "asc"
    session[:sort_column] = @sort_column  # update current sort information to session
    session[:sort_direction] = @sort_direction
  end

  def index
    @movies = Movie.order("#{@sort_column} #{@sort_direction}") # sort
  end

  def toggle(column)
    if column == @sort_column && @sort_direction == "asc"
      "desc"

    else
      "asc"
    end
  end

  # GET /movies/1 or /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies or /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: "Movie was successfully created." }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: "Movie was successfully updated." }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    @movie.destroy!

    respond_to do |format|
      format.html { redirect_to movies_path, status: :see_other, notice: "Movie was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.expect(movie: [ :title, :rating, :description, :release_date ])
    end
end
