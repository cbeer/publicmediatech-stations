class StationsController < ApplicationController
  before_filter :require_user, :only => [:edit, :destroy]

  def require_user
    redirect_to stations_url unless current_user
    return false
  end
  # GET /stations
  # GET /stations.xml
  def index
    @stations = nil
    @stations ||= Station.paginate :conditions => ['state = ? and genre = ?', params[:state], params[:genre]], :page => params[:page], :per_page => 10 if params[:state] and params[:genre]
    @stations ||= Station.tagged_with(params[:color], :on => :color ).paginate :page => params[:page], :per_page => 10 if params[:color]
    @stations ||= Station.tagged_with(params[:tags], :on => :tags ).paginate :page => params[:page], :per_page => 10 if params[:tags]
    @stations ||= Station.paginate_by_genre params[:genre], :page => params[:page], :per_page => 10 if params[:genre]
    @stations ||= Station.paginate_by_state params[:state], :page => params[:page], :per_page => 10 if params[:state]
    @stations ||= Station.paginate :page => params[:page], :per_page => 10

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stations }
    end
  end

  def top
    @stations = Station.find_top_rated.paginate :page => params[:page], :per_page => 10
    respond_to do |format|
      format.html { render :index } # index.html.erb
      format.xml  { render :xml => @stations }
    end
  end

  def mosaic
    @stations = Station.order(:cached_color).select { |x| x.home.file? }
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
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
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
    @station.rate_it(params[:rate], current_user || User.find(2))

    respond_to do |format|
      format.html { redirect_to(@station) }
      format.xml  { render :xml => @station }
    end
  end
end
