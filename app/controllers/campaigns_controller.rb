class CampaignsController < ApplicationController
  before_action :set_campaign, only: [:show, :edit, :update, :destroy]

  # GET /campaigns
  # GET /campaigns.json
  def index
    if user_signed_in?
    @campaigns = current_user.campaigns
    else
      redirect_to new_user_session_path
    end
  end

  # GET /campaigns/1
  # GET /campaigns/1.json
  def show
    if user_signed_in?
      @nps = Nps.for_campaign(@campaign.id)
      @contacts_sent = Campaign.includes(contacts: [:answer]).find(params[:id]).contacts.where(valid_info: true, status: '1').paginate(:page => params[:page])
      @contacts_not_sent = Campaign.includes(contacts: [:answer]).find(params[:id]).contacts.where(valid_info: true, status: '0').paginate(:page => params[:page])
      @topics = Campaign.find(params[:id]).tmp_topics 
    else
      redirect_to new_user_session_path
    end
  end

  # GET /campaigns/new
  def new
    if user_signed_in?
    @campaign = Campaign.new
    else
      redirect_to new_user_session_path
    end
  end

  # GET /campaigns/1/edit
  def edit
  end

  # POST /campaigns
  # POST /campaigns.json
  def create
      @campaign = Campaign.new(campaign_params.merge(user_id: current_user.id))
      @campaign.tmp_topics = campaign_params[:topics].map(&:split).flatten.sort if campaign_params[:topics]
      respond_to do |format|
        if @campaign.save!
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
    if user_signed_in?
      respond_to do |format|
        if @campaign.update(campaign_params)
          format.html { redirect_to @campaign, notice: 'Campaign was successfully updated.' }
          format.json { render :show, status: :ok, location: @campaign }
        else
          format.html { render :edit }
          format.json { render json: @campaign.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to new_user_session_path
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
    campaign.update last_sent: @time
    campaign.contacts.where(valid_info: true).update_all(status: 1, sent_date: @time)
  end

  def upload_csv
    campaign_id = params[:campaign][:id]
    if params[:campaign][:file].nil?
      redirect_to campaign_path(campaign_id), notice: 'Necesitas agregar un archivo.'
    else
      topics = Campaign.find(campaign_id).tmp_topics
      Campaign.import_contacts(params[:campaign][:file], topics, campaign_id)
      redirect_to campaign_path(campaign_id), notice: 'CSV importado exitosamente.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_campaign
      @campaign = Campaign.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def campaign_params
      params.require(:campaign).permit(:name, :sender_name, :sender_email, :logo, :color, topics: [])
    end
end
