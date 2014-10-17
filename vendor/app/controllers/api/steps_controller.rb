class Api::StepsController < ApplicationController

  protect_from_forgery  :except => :create
  before_action :set_user, only: [:create]

  # POST /steps
  # POST /steps.json
  def create

    @step = Step.new(step_params)
    @step.user = @user

    ret = { error: '0', error_msg: 'success' }

    respond_to do |format|
      if @step.save
        format.html { redirect_to @step, notice: 'Step was successfully created.' }
        format.json { render :json => ret.to_json, status: :created, location: @step }
      else
        format.html { render :new }
        format.json { render json: @step.errors, status: :unprocessable_entity }
      end
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
  
  def set_user
    @user = User.find_by_email(params[:email])
  end

end
