class StationsController < ApplicationController
  before_filter :require_user, :only => [:edit, :destroy]

  def require_user
    redirect_to stations_url unless current_user
    return false
  end

  # GET /stations
  # GET /stations.xml
  def index
    @category = params[:category] || 'home'
    @search = Station.search do
      keywords(params[:q])
      with(:state, params[:state]) if params[:state].present?
      with(:tags).all_of([params[:tags]].flatten) if params[:tags].present?
      with(:cached_color, params[:cached_color]) if params[:cached_color].present?
      with(:average_rating, 0) if params[:average_rating].present? and params[:average_rating] == 'unrated'
      with(:average_rating).greater_than(params[:average_rating]) if params[:average_rating].present? and params[:average_rating] != 'unrated'
      without(:status, 2)
      without(:tags, 'duplicate')
      facet :state, :sort => :index
      facet :cached_color, :sort => :index
      facet :tags, :sort => :index
      facet(:average_rating) do
        row('unrated') do
          with(:average_rating, 0.0)
        end
        row(0.0) do
          with(:average_rating, 0.0..5.0)
        end
        row(1.0) do
          with(:average_rating, 1.0..5.0)
        end
        row(2.0) do
          with(:average_rating, 2.0..5.0)
        end
        row(3.0) do
          with(:average_rating, 3.0..5.0)
        end
        row(4.0) do
          with(:average_rating, 4.0..5.0)
        end
      end

      paginate :per_page => params[:per_page] || 10, :page => params[:page] || 1
      order_by :score, :desc unless params[:q].nil? or params[:q].empty?
      order_by :average_rating, :desc
    end
  
    respond_to do |format|
      format.html # index.html.erb
      format.csv # { render :csv => @search }
    end
  end

  def mosaic
    @stations = Station.all(:conditions => ['status != 2'], :order => :cached_color).select { |x| x.home && x.home.screenshot.file? }
    respond_to do |format|
      format.html # index.html.erb
    end

  end

  # GET /stations/1
  # GET /stations/1.xml
  def show
    @station = Station.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
        format.json { render :json => @station }
      format.xml  { render :xml => @station }
    end
  end

  # GET /stations/new
  # GET /stations/new.xml
  def new
    @station = Station.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @station }
    end
  end

  # GET /stations/1/edit
  def edit
    @station = Station.find(params[:id])
  end

  # POST /stations
  # POST /stations.xml
  def create
    @station = Station.new(params[:station])

    respond_to do |format|
      if @station.save
        flash[:notice] = 'Station was successfully created.'
        format.html { redirect_to(@station) }
        format.xml  { render :xml => @station, :status => :created, :location => @station }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @station.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /stations/1
  # PUT /stations/1.xml
  def update
    @station = Station.find(params[:id])
    params[:station] = { :tag_list => params[:station][:tag_list] } unless current_user
    params[:station][:tag_list] = (@station.tag_list + params[:station][:tag_list].split(" ")).uniq if params[:station][:tag_list] and params[:update] == true

    respond_to do |format|
      if @station.update_attributes(params[:station])
        Sunspot.index! @station
        flash[:notice] = 'Station was successfully updated.'
        format.html { redirect_to(@station) }
        format.js { render :json => @station.as_json(:methods => [:tag_list, :average_rating, :ratings_count]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.js { render :json => @station.errors }
        format.xml  { render :xml => @station.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stations/1
  # DELETE /stations/1.xml
  def destroy
    @station = Station.find(params[:id])
    @station.destroy

    respond_to do |format|
      format.html { redirect_to(stations_url) }
      format.xml  { head :ok }
    end
  end

  def rate
    @station = Station.find(params[:id])
    u = current_user
    unless u
      u = User.find_or_create_by_email(request.remote_ip + '@anonymous.example.org')
      u.password = request.remote_ip
      u.save
    end

    @station.rate_it(params[:rate], u)
    Sunspot.index! @station

    respond_to do |format|
      format.html { redirect_to(@station) }
      format.xml  { render :xml => @station }
      format.json { render :json => @station.to_json(:methods => [:average_rating, :ratings_count]) }
    end
  end
end
