class CampaignsController < ApplicationController
  before_action :set_campaign, only: [:edit, :update, :destroy]

  # GET /campaigns
  # GET /campaigns.json
  def index
    @campaigns = current_user.campaigns
  end

  # GET /campaigns/1
  # GET /campaigns/1.json
  def show
    @campaign = Campaign.includes(contacts: [:answer]).find(params[:id])
    @contacts = @campaign.contacts.paginate(:page => params[:page], :per_page => 50)
    @nps = Nps.for_campaign(@campaign.id)
  end

  # GET /campaigns/new
  def new
    @campaign = Campaign.new
  end

  # GET /campaigns/1/edit
  def edit
  end

  # POST /campaigns
  # POST /campaigns.json
  def create
    @campaign = Campaign.new(campaign_params.merge(user_id: current_user.id))
    respond_to do |format|
      if @campaign.save
        Campaign.import_contacts(params[:campaign][:file], @campaign.id)
        format.html { redirect_to @campaign, notice: 'Campaign was successfully created.' }
        format.json { render :show, status: :created, location: @campaign }
      else
        format.html { render :new }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /campaigns/1
  # PATCH/PUT /campaigns/1.json
  def update
    respond_to do |format|
      if @campaign.update(campaign_params)
        format.html { redirect_to @campaign, notice: 'Campaign was successfully updated.' }
        format.json { render :show, status: :ok, location: @campaign }
      else
        format.html { render :edit }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /campaigns/1
  # DELETE /campaigns/1.json
  def destroy
    @campaign.destroy
    respond_to do |format|
      format.html { redirect_to campaigns_url, notice: 'Campaign was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def generate_campaign_mailing
    CampaignMailer.send_survey(params[:campaign_id], 'Campaña enviada via Sone', params[:sender_email]).deliver!
    # TODO: Add/Render this flash message into flash messages partial
    respond_to do |format|
      format.js { flash.now[:notice] = 'Campaña enviada exitosamente.' }
    end
    campaign = Campaign.includes(:contacts).find(params[:campaign_id])

    @time = Time.now
    campaign.contacts.update_all(status: 1, sent_date: @time)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_campaign
      @campaign = Campaign.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def campaign_params
      params.require(:campaign).permit(:name, :sender_name, :sender_email, :logo, :color)
    end
end
