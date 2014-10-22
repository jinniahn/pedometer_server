class StepsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_step, only: [:show, :edit, :update, :destroy]
  protect_from_forgery  :except => :create

  # GET /steps
  # GET /steps.jsonq
  def index
    @steps = current_user.steps.order(:time)
  end

  # GET /steps/1
  # GET /steps/1.json
  def show
  end

  # GET /steps/clear
  def clear
    @steps = current_user.steps
    @steps.each do |step|
      step.destroy
    end
    redirect_to '/steps'
  end

  def graph_hours
    @steps = current_user.steps    

    begin
      @date = DateTime.now
      if params[:date] 
        @date = DateTime.strptime(params[:date], "%Y-%m-%dT%H:%M:%S")
      end
    end

    @prev_date = @date - 1.hour
    @next_date = @date + 1.hour

    respond_to do |format|
      format.html{ }
      format.json{ 
        begin_of_time = @date.beginning_of_hour
        end_of_time = @date.end_of_hour

        # extract data from model
        @steps = Step.where('user_id = ? and time between ? and ?', current_user.id, begin_of_time, end_of_time)
        @data = {}
        @steps.each do |step|
          date = step.time.strftime("%Y-%m-%d %H:%M:00")
          item = if @data.has_key? date then 
                   @data[date]
                 else
                   @data[date] = {date: date, total_of_steps: 0}
                 end
          item[:total_of_steps] += step.steps
        end
        
        render :json => @data.values.to_json 
      }
    end

  end

  def graph_days

    @steps = current_user.steps
    begin
      @date = DateTime.now
      if params[:date] 
        @date = Date.strptime(params[:date], "%Y-%m-%d")
      end
    end

    @prev_date = @date - 1.day
    @next_date = @date + 1.day
        
    respond_to do |format|
      format.html{ }
      format.json{ 
        begin_of_time = @date.beginning_of_day
        end_of_time = @date.end_of_day

        # extract data from model
        @steps = Step.where('user_id = ? and time between ? and ?', current_user.id, begin_of_time, end_of_time)
        @data = {}
        @steps.each do |step|
          date = step.time.strftime("%Y-%m-%d %H:00:00")
          item = if @data.has_key? date then 
                   @data[date]
                 else
                   @data[date] = {date: date, total_of_steps: 0}
                 end
          item[:total_of_steps] += step.steps
        end

        logger.debug( @data )
        
        render :json => @data.values.to_json 
      }
    end

  end

  # GET /steps/new
  def new
    @step = Step.new
  end

  # GET /steps/1/edit
  def edit
  end

  # POST /steps
  # POST /steps.json
  def create
    @step = Step.new(step_params)
    @step.user = current_user

    respond_to do |format|
      if @step.save
        format.html { redirect_to @step, notice: 'Step was successfully created.' }
        format.json { render :show, status: :created, location: @step }
      else
        format.html { render :new }
        format.json { render json: @step.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /steps/1
  # PATCH/PUT /steps/1.json
  def update
    respond_to do |format|
      if @step.update(step_params)
        format.html { redirect_to @step, notice: 'Step was successfully updated.' }
        format.json { render :show, status: :ok, location: @step }
      else
        format.html { render :edit }
        format.json { render json: @step.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /steps/1
  # DELETE /steps/1.json
  def destroy
    @step.destroy
    respond_to do |format|
      format.html { redirect_to steps_url, notice: 'Step was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_step
      @step = Step.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def step_params
      params.require(:step).permit(:time, :period, :steps)
    end
end
