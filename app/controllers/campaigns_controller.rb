class CampaignsController < ApplicationController
  before_action :set_campaign, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: :report
  before_action :require_login
  before_action :validate_campaign_belongs_to_currents_user, only: [:show, :edit, :update]

  # GET /campaigns
  # GET /campaigns.json
  def index
    @campaigns = current_user.campaigns
  end

  # GET /campaigns/1
  # GET /campaigns/1.json
  def show
    date_range = Campaign.receive_date('1')
    @nps = Nps.for_campaign(@campaign.id, date_range[0], date_range[1], @campaign.tmp_topics)
    # @contacts_sent = Campaign.includes(contacts: [:answer]).find(params[:id]).contacts.where(valid_info: true, status: '1').paginate(:page => params[:page])
    @contacts_sent_pendants_actives = Contact.includes(:answer).where(campaign_id: @campaign.id, answers: { id: nil }, valid_info: true, status: '1', sent_date: (Time.current - 48.hour..Time.current)).paginate(:page => params[:page])
    @contacts_not_sent = Campaign.includes(contacts: [:answer]).find(params[:id]).contacts.where(valid_info: true, status: ['0', '3']).paginate(:page => params[:page])
    @topics = Campaign.find(params[:id]).tmp_topics
    @campaign.update({new_answers: 0})
  end

  # GET /campaigns/new
  def new
    @campaign = Campaign.new
  end

  # GET /campaigns/1/edit
  def edit
    # p "·#" * 123
    # p params
  end

  # POST /campaigns
  # POST /campaigns.json
  def create
      @campaign = Campaign.new(campaign_params.merge(user_id: current_user.id))
      @campaign.tmp_topics = campaign_params[:topics].map(&:split).flatten.sort if campaign_params[:topics]
      respond_to do |format|
        if @campaign.save
          format.html { redirect_to @campaign, notice: 'Campaña creada exitosamente.' }
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

  def report
    @campaign = Campaign.find(params[:id])
    @date_range = params[:filter] ? params[:feedback_date] : '30 Días'
    @date_range ||= '30 Días'
    @selected_topics = params[:filter] ? params[:topics] : []
    @topics = params[:topics] ||= []

    if params[:topics].is_a? String
      @topics = params[:topics].split(',')
    end

    if params[:filter]
      @selected_topics = params[:topics]
      params[:filter][:nps_date] = params[:nps_date] if params[:nps_date]
      selected_date = params[:filter][:nps_date]
      date_range = Campaign.receive_date(selected_date)
      @nps = Nps.for_campaign(@campaign.id, date_range[0], date_range[1], @topics)
      @contacts_feedback = Answer.joins(contact: :campaign).where(campaigns: { id: @campaign.id }, created_at: date_range[0]..date_range[1])
      @feedback_report = Answer.joins(contact: :campaign).where(campaigns: { id: @campaign.id }, created_at: date_range[0]..date_range[1])
      @topics.each do |topic|
        @contacts_feedback = @contacts_feedback.where('contacts.topics ? :topics', topics: topic)
        @feedback_report = @feedback_report.where('contacts.topics ? :topics', topics: topic)
      end

      @contacts_feedback = @contacts_feedback.paginate(page: params[:page], per_page: 5)
      # @feedback_report = Answer.joins(contact: :campaign).where(campaigns: { id: @campaign.id }, created_at: date_range[0]..date_range[1])
      if params[:feedback_type] == 'promoter'
        @feedback_type = params[:feedback_type]
        @contacts_feedback = @contacts_feedback.where(score: 9..10)
        @feedback_report = @feedback_report.where(score: 9..10)
      elsif params[:feedback_type] == 'passive'
        @feedback_type = params[:feedback_type]
        @contacts_feedback = @contacts_feedback.where(score: 7..8)
        @feedback_report = @feedback_report.where(score: 7..8)
      elsif params[:feedback_type] == 'detractor'
        @feedback_type = params[:feedback_type]
        @contacts_feedback = @contacts_feedback.where(score: 0..6)
        @feedback_report = @feedback_report.where(score: 0..6)
      end
      @nps_sample_count = @contacts_feedback.count
      @data_percentages = Campaign.get_nps_data_percentages(@nps, @nps_sample_count)
      @active_filter = params[:filter][:nps_date]
    else
      date = params[:nps_date] ? params[:nps_date] : '1'
      date_range = Campaign.receive_date(date)
      @nps = Nps.for_campaign(@campaign.id, date_range[0], date_range[1], @topics)
      @contacts_feedback = Answer.joins(contact: :campaign).where(campaigns: { id: @campaign.id }, created_at: date_range[0]..date_range[1])
      @feedback_report = Answer.joins(contact: :campaign).where(campaigns: { id: @campaign.id }, created_at: date_range[0]..date_range[1])
      @topics.each do |topic|
        @contacts_feedback = @contacts_feedback.where('contacts.topics ? :topics', topics: topic)
        @feedback_report = @feedback_report.where('contacts.topics ? :topics', topics: topic)
      end
      @contacts_feedback = @contacts_feedback.paginate(page: params[:page], per_page: 5)
      if params[:feedback_type] == 'promoter'
        @feedback_type = params[:feedback_type]
        @contacts_feedback = @contacts_feedback.where(score: 9..10)
        @feedback_report = @feedback_report.where(score: 9..10)
      elsif params[:feedback_type] == 'passive'
        @feedback_type = params[:feedback_type]
        @contacts_feedback = @contacts_feedback.where(score: 7..8)
        @feedback_report = @feedback_report.where(score: 7..8)
      elsif params[:feedback_type] == 'detractor'
        @feedback_type = params[:feedback_type]
        @contacts_feedback = @contacts_feedback.where(score: 0..6)
        @feedback_report = @feedback_report.where(score: 0..6)
      end
      @nps_sample_count = @contacts_feedback.count
      @data_percentages = Campaign.get_nps_data_percentages(@nps, @nps_sample_count)
    end

    respond_to do |format|
      format.js { render partial: 'feedback', content_type: 'text/html' }
      format.html
      format.csv do
        send_data Campaign.to_csv(@campaign, @feedback_report),
        filename: "report-#{Date.today}.csv"
      end
    end
  end

  def dashboard
    if current_user.campaigns.empty?
      @no_campaigns = true
    else
      @date_range = params[:filter] ? params[:feedback_date] : '30 Días'
      @date_range ||= '30 Días'

      if params[:campaigns].is_a? String
        @selected_campaigns = params[:campaigns].split(',')
        params[:campaigns] = @selected_campaigns
      end

      if params[:topics].is_a? String
        @topics = params[:topics].split(',')
        params[:topics] = @topics
      end

      if params[:campaigns]
        @campaigns = current_user.campaigns.where(id: params[:campaigns])
      else
        @campaigns = current_user.campaigns
      end
      @campaigns_ids = @campaigns.map { |campaign| campaign.id }

      @selected_campaigns = params[:campaigns] ||= []
      @selected_topics = params[:topics] ||= []
      @topics = params[:topics] ||= []

      if params[:filter]
        params[:filter][:nps_date] = params[:nps_date] if params[:nps_date]
        selected_date = params[:filter][:nps_date]
        date_range = Campaign.receive_date(selected_date)
        date_range_fixed_nps = Campaign.receive_date('1')

        choosed_campaigns = @campaigns.where(id: @selected_campaigns)

        @nps = Nps.for_dashboard(choosed_campaigns, date_range[0], date_range[1], @topics)
        # @contacts_feedback = Answer.joins(contact: :campaign).where(campaigns: { id: @campaigns_ids }, created_at: date_range[0]..date_range[1])
        @nps_30_fixed = Nps.for_dashboard(choosed_campaigns, date_range_fixed_nps[0], date_range_fixed_nps[1], @topics)
        @contacts_feedback = Answer.joins(contact: :campaign).where(campaigns: { id: @campaigns_ids }).where(["date(answers.created_at) BETWEEN ? AND ?", date_range[0], date_range[1]])
        @feedback_report = Answer.joins(contact: :campaign).where(campaigns: { id: @campaigns_ids }).where(["date(answers.created_at) BETWEEN ? AND ?", date_range[0], date_range[1]])
        @topics.each do |topic|
          @contacts_feedback = @contacts_feedback.where('contacts.topics ? :topics', topics: topic)
          @feedback_report = @feedback_report.where('contacts.topics ? :topics', topics: topic)
        end

        @contacts_feedback = @contacts_feedback.paginate(page: params[:page], per_page: 5)
        # @feedback_report = Answer.joins(contact: :campaign).where(campaigns: { id: @campaign.id }, created_at: date_range[0]..date_range[1])

        if params[:feedback_type] == 'promoter'
          @feedback_type = params[:feedback_type]
          @contacts_feedback = @contacts_feedback.where(score: 9..10)
          @feedback_report = @feedback_report.where(score: 9..10)
          @nps.passives = [0]
          @nps.detractors = [0]
        elsif params[:feedback_type] == 'passive'
          @feedback_type = params[:feedback_type]
          @contacts_feedback = @contacts_feedback.where(score: 7..8)
          @feedback_report = @feedback_report.where(score: 7..8)
          @nps.detractors = [0]
          @nps.promoters = [0]
        elsif params[:feedback_type] == 'detractor'
          @feedback_type = params[:feedback_type]
          @contacts_feedback = @contacts_feedback.where(score: 0..6)
          @feedback_report = @feedback_report.where(score: 0..6)
          @nps.passives = [0]
          @nps.promoters = [0]
        end
        @nps_sample_count = @contacts_feedback.count
        @data_percentages = Campaign.get_nps_data_percentages(@nps, @nps_sample_count)
        @data_percentages_30_fixed = Campaign.get_nps_data_percentages(@nps_30_fixed, @nps_sample_count)
        @active_filter = params[:filter][:nps_date]
      else
        date = params[:nps_date] ? params[:nps_date] : '1'
        date_range = Campaign.receive_date(date)
        @nps = Nps.for_dashboard(@campaigns, date_range[0], date_range[1], @topics)
        @contacts_feedback = Answer.joins(contact: :campaign).where(campaigns: { id: @campaigns_ids }).where(["date(answers.created_at) BETWEEN ? AND ?", date_range[0], date_range[1]])
        @feedback_report = Answer.joins(contact: :campaign).where(campaigns: { id: @campaigns_ids }).where(["date(answers.created_at) BETWEEN ? AND ?", date_range[0], date_range[1]])
        @topics.each do |topic|
          @contacts_feedback = @contacts_feedback.where('contacts.topics ? :topics', topics: topic)
          @feedback_report = @feedback_report.where('contacts.topics ? :topics', topics: topic)
        end

        @contacts_feedback = @contacts_feedback.paginate(page: params[:page], per_page: 5)

        if params[:feedback_type] == 'promoter'
          @feedback_type = params[:feedback_type]
          @contacts_feedback = @contacts_feedback.where(score: 9..10)
          @feedback_report = @feedback_report.where(score: 9..10)
        elsif params[:feedback_type] == 'passive'
          @feedback_type = params[:feedback_type]
          @contacts_feedback = @contacts_feedback.where(score: 7..8)
          @feedback_report = @feedback_report.where(score: 7..8)
        elsif params[:feedback_type] == 'detractor'
          @feedback_type = params[:feedback_type]
          @contacts_feedback = @contacts_feedback.where(score: 0..6)
          @feedback_report = @feedback_report.where(score: 0..6)
        end

        @nps_sample_count = @contacts_feedback.count
        @data_percentages = Campaign.get_nps_data_percentages(@nps, @nps_sample_count)
      end
    end
    respond_to do |format|
      format.js { render partial: 'feedback', content_type: 'text/html' }
      format.html
      format.csv do
        send_data Campaign.to_csv(@campaign, @feedback_report),
        filename: "report-#{Date.today}.csv"
      end
    end
  end

  def generate_campaign_mailing
    num_surveys = Campaign.find(params[:campaign_id]).contacts.where(blacklist: nil, valid_info: true, status: 0).count
    # @mensaje = ""
    if num_surveys <= current_user.available_emails
      mensaje = 'Campaña enviada exitosamente.'
      if Campaign.find(params[:campaign_id]).valid_and_not_sent_contacts.empty?
        mensaje = 'No hay contactos disponibles'
      else
        CampaignMailer.send_survey(params[:campaign_id], params[:sender_email]).deliver!
      end
      campaign = Campaign.includes(:contacts).find(params[:campaign_id])

      @time = Time.now
      campaign.update last_sent: @time
      campaign.valid_and_not_sent_contacts.each { |contact| contact.update(status: 1, sent_date: @time) }
      campaign.contacts.where(status: 0, valid_info: true).update_all(status: 3)
      num_available_emails = current_user.available_emails
      current_user.update(available_emails: num_available_emails - num_surveys)
      campaign.surveys_counter += num_surveys
      campaign.save
      flash[:info] = mensaje
    else
      flash[:warning] = 'No tienes sufucuentes emails disponibles'
    end

    redirect_to campaign_path(id: params[:campaign_id])
  end

  def upload_csv
    campaign_id = params[:campaign][:id]
    csv_file = params[:campaign][:file]
    if csv_file.nil?
      redirect_to campaign_path(campaign_id), notice: 'Necesitas agregar un archivo.'
    elsif !csv_file.content_type.include?('csv')
      redirect_to campaign_path(campaign_id), notice: 'El formato del archivo no es correcto.'
    elsif !Campaign.have_correct_columns?(csv_file, campaign_id)
      redirect_to campaign_path(campaign_id), notice: 'Recuerda agregar las columnas correspondientes a tu archivo.'
    else
      topics = Campaign.find(campaign_id).tmp_topics
      Campaign.import_contacts(params[:campaign][:file], topics, campaign_id)
      redirect_to campaign_path(campaign_id), notice: 'CSV importado exitosamente.'
    end
  end

  def template
    campaign = current_user.campaigns.find(params[:id])
    respond_to do |format|
      format.csv { send_data campaign.csv_template, filename: "contacts-#{Date.today}.csv" }
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

    def validate_campaign_belongs_to_currents_user
      campaign = Campaign.find(params[:id])
      unless current_user.campaigns.include?(campaign)
        redirect_to campaigns_path
      end
    end
end
