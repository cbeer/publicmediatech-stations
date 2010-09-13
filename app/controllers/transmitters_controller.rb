class TransmittersController < ApplicationController
  # GET /transmitters
  # GET /transmitters.xml
  def index
    @transmitters = Transmitter.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @transmitters }
    end
  end

  # GET /transmitters/1
  # GET /transmitters/1.xml
  def show
    @transmitter = Transmitter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @transmitter }
    end
  end

  # GET /transmitters/new
  # GET /transmitters/new.xml
  def new
    @transmitter = Transmitter.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @transmitter }
    end
  end

  # GET /transmitters/1/edit
  def edit
    @transmitter = Transmitter.find(params[:id])
  end

  # POST /transmitters
  # POST /transmitters.xml
  def create
    @transmitter = Transmitter.new(params[:transmitter])

    respond_to do |format|
      if @transmitter.save
        flash[:notice] = 'Transmitter was successfully created.'
        format.html { redirect_to(@transmitter) }
        format.xml  { render :xml => @transmitter, :status => :created, :location => @transmitter }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @transmitter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /transmitters/1
  # PUT /transmitters/1.xml
  def update
    @transmitter = Transmitter.find(params[:id])

    respond_to do |format|
      if @transmitter.update_attributes(params[:transmitter])
        flash[:notice] = 'Transmitter was successfully updated.'
        format.html { redirect_to(@transmitter) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @transmitter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /transmitters/1
  # DELETE /transmitters/1.xml
  def destroy
    @transmitter = Transmitter.find(params[:id])
    @transmitter.destroy

    respond_to do |format|
      format.html { redirect_to(transmitters_url) }
      format.xml  { head :ok }
    end
  end
end
