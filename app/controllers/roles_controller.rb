
class RolesController < ApplicationController
  include CMS::Controller::Base
  before_filter :authentication_required
  before_filter :get_container , :only=>[:update_group,:edit_group,:group_details, :create_group,:save_group, :show_groups, :delete_group]
  def index
    @role = CMS::Role.find_all_by_type(nil)
   
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @role }
    end
  end
  
  
  def show
    @role = CMS::Role.find(params[:id] )
    
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @role }
    end
  end
  
  # GET /roles/new
  # GET /roles/new.xml
  def new
    @role = CMS::Role.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @role }
    end
  end
  
  # GET /roles/1/edit
  def edit
    @role = CMS::Role.find(params[:id])
  end
  
  
  # POST /roles
  # POST /roles.xml
  def create
    
    @role = CMS::Role.new(params[:cms_role])
    
    
    respond_to do |format|
      if @role.save
        flash[:notice] = 'Role was successfully created.'
        format.html { redirect_to(:action => "index", :controller => "roles") }
        format.xml  { render :xml => @role, :status => :created, :location => @role }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @role.errors, :status => :unprocessable_entity }
      end
    end
  end
  # PUT /roles/1
  # PUT /roles/1.xml
  def update
  
    @role = CMS::Role.find(params[:id])
    
    respond_to do |format|
      if @role.update_attributes(params[:cms_role])
        flash[:notice] = 'Role was successfully updated.'
        format.html { redirect_to(:action => "index", :controller => "roles") }
        format.xml  { head :ok }
      else
        format.html { render :action => "index" }
        format.xml  { render :xml => @role.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /roles/1
  # DELETE /roles/1.xml
  def destroy
    @role = CMS::Role.find(params[:id])
    @role.destroy
    
    respond_to do |format|
      format.html { redirect_to(roles_url) }
      format.xml  { head :ok }
    end
  end
  
  def group_details
    
    @role = Group.find(params[:group_id])
    @performances = CMS::Performance.find_all_by_role_id_and_container_id(@role.id, @container.id)
    i = 0
    @users = []
    for performance in @performances
      
      @users [i] = User.find(performance.agent_id)
      i = i+ 1
    end
    
    respond_to do |format|
      format.js
      format.xml  { render :xml => @role }
    end
  end
  def show_groups

    ###estan deben ser unicas...
    @perf = CMS::Performance.find_all_by_container_id(params[:container_id])
    
    @perf = @perf.collect{ |p| p.role_id}.uniq
    i = 0
    @role = []
    for perf in @perf  
      @part = Group.find_by_id(perf)
      if @part == nil        
      else
        @role[i]=@part
        i = i+ 1
      end 
      
    end
  
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @role }
    end
  end
  
  def create_group 
    @users =  @container.agents    
    @role = Group.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @role }
    end
    
  end
  def save_group
   
    
    @users =  @container.agents   
    @role = Group.new(params[:group])
    
    
    respond_to do |format|

      if @role.save
        if params[:users] && params[:users][:id]             
          for id in params[:users][:id]
            @container.performances.create :agent => User.find(id), :role => @role
          end          
        end
        flash[:notice] = 'Group was successfully created in this space.'
        format.html { redirect_to(:action => "show_groups", :controller => "roles") }
        format.xml  { render :xml => @role, :status => :created, :location => @role }
      else
      flash[:notice] = 'Error creating group.'
        format.html { render :action => "create_group" }
        format.xml  { render :xml => @role.errors, :status => :unprocessable_entity }
      end
    end
    
  end
  
  
  def edit_group
    @users =  @container.agents    
    @role = Group.find(params[:group_id])
    @performances = CMS::Performance.find_all_by_role_id_and_container_id(@role.id, @container.id)
    i = 0
    @users_group = []
    for performance in @performances
      
      @users_group [i] = User.find(performance.agent_id)
      i = i+ 1
    end
    
    respond_to do |format|
      format.html {render }
      format.xml  { render :xml => @role }
    end
  end
  def update_group
   
    
    @role = Group.find(params[:group_id])
    @performances = CMS::Performance.find_all_by_role_id_and_container_id(params[:group_id], @container.id)
    
    for performance in @performances
      performance.destroy
    end
    if  @role.update_attributes(params[:group])
      if params[:users] && params[:users][:id]             
        for id in params[:users][:id]
       
          @container.performances.create :agent => User.find(id), :role => @role
        end  
        flash[:notice] = 'Group was successfully updated.'
      else
      debugger
        @role.destroy
        flash[:notice] = 'Group was successfully deleted.'
      end
      
       redirect_to(:action => "show_groups", :controller => "roles") 
      
    end
  end
  def delete_group
    
    
    @role = Group.find(params[:group_id])
    
    
    @performances = CMS::Performance.find_all_by_role_id_and_container_id(params[:group_id], @container.id)
    
    for performance in @performances
      performance.destroy
    end
    @role.destroy
    flash[:notice] = 'Group was successfully deleted'
    redirect_to(:action => "show_groups", :controller => "roles") 
    
  end
end