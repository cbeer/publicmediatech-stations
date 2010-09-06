class StationsController < ApplicationController
  before_filter :require_user, :only => [:edit, :destroy]

  def require_user
    redirect_to stations_url unless current_user
    return false
  end
  # GET /stations
  # GET /stations.xml
  def index_old # index
    @stations = nil
    @stations ||= Station.paginate :conditions => ['status != 2 and state = ? and genre = ?', params[:state], params[:genre]], :page => params[:page], :per_page => 10 if params[:state] and params[:genre]
    @stations ||= Station.tagged_with(params[:color], :on => :color ).paginate :conditions => ['status != 2'], :page => params[:page], :per_page => 10 if params[:color]
    @stations ||= Station.tagged_with(params[:tags], :on => :tags ).paginate :conditions => ['status != 2'], :page => params[:page], :per_page => 10 if params[:tags]
    @stations ||= Station.paginate_by_genre params[:genre], :conditions => ['status != 2'], :page => params[:page], :per_page => 10 if params[:genre]
    @stations ||= Station.paginate_by_state params[:state], :conditions => ['status != 2'], :page => params[:page], :per_page => 10 if params[:state]
    @stations ||= Station.paginate :conditions => ['status != 2'], :page => params[:page], :per_page => 10

   if params[:test]
    Station.with_scope(:order => 'state') do
      @stations = Station.paginate :page => params[:page], :per_page => 10
    end
end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stations }
    end
  end

  def index #search
    @search = Station.search do
      keywords(params[:q])
      with(:state, params[:state]) if params[:state].present?
      with(:tags).all_of([params[:tags]].flatten) if params[:tags].present?
      with(:cached_color, params[:cached_color]) if params[:cached_color].present?
      with(:average_rating).greater_than(params[:average_rating]) if params[:average_rating].present?
      without(:status, 2)
      facet :state, :sort => :index
      facet :cached_color, :sort => :index
      facet :tags, :sort => :index
      facet(:average_rating) do
    row(0.0..1.0) do
      with(:average_rating, 0.0..5.0)
    end
    row(1.0..2.0) do
      with(:average_rating, 1.0..5.0)
    end
    row(2.0..3.0) do
      with(:average_rating, 2.0..5.0)
    end
    row(3.0..4.0) do
      with(:average_rating, 3.0..5.0)
    end
    row(4.0..5.0) do
      with(:average_rating, 4.0..5.0)
    end
  end

      paginate :per_page => 10, :page => params[:page] || 1
      order_by :score, :desc
      order_by :average_rating, :desc
    end
  
    respond_to do |format|
      format.html { render :search  } # index.html.erb
    end
  end

  def top
    @stations = nil
    @stations ||= Station.tagged_with(params[:tags], :on => :tags ).find_top_rated(:limit => 50).paginate :conditions => ['status != 2'], :page => params[:page], :per_page => 10 if params[:tags]
    @stations ||= Station.find_top_rated(:limit => 50).paginate_by_genre params[:genre], :conditions => ['status != 2'], :page => params[:page], :per_page => 10 if params[:genre]
    @stations ||= Station.find_top_rated(:limit => 50).paginate_by_state params[:state], :conditions => ['status != 2'], :page => params[:page], :per_page => 10 if params[:state]
    @stations ||= Station.find_top_rated(:limit => 50).paginate :page => params[:page], :per_page => 10
    respond_to do |format|
      format.html { render :index } # index.html.erb
      format.xml  { render :xml => @stations }
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
    params[:station][:tag_list] = (@station.tag_list + params[:station][:tag_list].split(" ")).uniq if params[:station][:tag_list]

    respond_to do |format|
      if @station.update_attributes(params[:station])
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

    respond_to do |format|
      format.html { redirect_to(@station) }
      format.xml  { render :xml => @station }
      format.json { render :json => @station.to_json(:methods => [:average_rating, :ratings_count]) }
    end
  end
end
