class Nps
  attr_reader :dates, :nps
  attr_accessor :detractors, :passives, :promoters

  def initialize
    @dates = []
    @detractors = []
    @passives = []
    @promoters = []
    @nps = []
  end

  def self.for_campaign campaign_id, start_date, end_date, topics
    nps = new

    get_nps_data(campaign_id, start_date, end_date, topics).each do |row|
      detractors_avg = row["detractors"].to_f / row["total"] * 100
      promoters_avg = row["promoters"].to_f / row["total"] * 100

      nps.dates << row["answer_date"]
      nps.detractors << row["detractors"]
      nps.passives << row["passives"]
      nps.promoters << row["promoters"]
      nps.nps << promoters_avg - detractors_avg
    end
    nps
  end

  def self.for_dashboard campaigns, start_date, end_date, topics
    nps = new

    get_nps_data_dashboard(campaigns, start_date, end_date, topics).each do |row|
      detractors_avg = row["detractors"].to_f / row["total"] * 100
      promoters_avg = row["promoters"].to_f / row["total"] * 100

      nps.dates << row["answer_date"]
      nps.detractors << row["detractors"]
      nps.passives << row["passives"]
      nps.promoters << row["promoters"]
      nps.nps << promoters_avg - detractors_avg
    end
    nps
  end

  private

    def self.get_nps_data campaign_id, start_date, end_date, topics
      topic_query = ''
      topics.each do |topic|
        topic_query += "AND contacts.topics ? '#{topic}' "
      end
      query = <<~HEREDOC
          SELECT
            date(answers.created_at) AS answer_date,
            SUM(CASE WHEN score BETWEEN 0 AND 6 THEN 1 ELSE 0 END) AS detractors,
            SUM(CASE WHEN score BETWEEN 7 AND 8 THEN 1 ELSE 0 END) AS passives,
            SUM(CASE WHEN score BETWEEN 9 AND 10 THEN 1 ELSE 0 END) AS promoters,
            SUM(1) AS total
          FROM "answers"
          INNER JOIN "contacts" ON "contacts"."id" = "answers"."contact_id"
          INNER JOIN "campaigns" ON "campaigns"."id" = "contacts"."campaign_id"
          WHERE "campaigns"."id" = $1 #{topic_query}AND date(answers.created_at) BETWEEN $2 AND $3
          GROUP BY date(answers.created_at)
          ORDER BY answer_date
        HEREDOC
        ActiveRecord::Base.connection.select_all(query, nil, [[nil, campaign_id], [nil, start_date], [nil, end_date]])
    end

    def self.get_nps_data_dashboard campaigns, start_date, end_date, topics
      campaigns = campaigns.map { |campaign| campaign.id }.join(', ')

      topic_query = ''

      topics.each do |topic|
        topic_query += "AND contacts.topics ? '#{topic}' "
      end
      puts "*"*100
      p start_date
      query = <<~HEREDOC
          SELECT
            date(answers.created_at) AS answer_date,
            SUM(CASE WHEN score BETWEEN 0 AND 6 THEN 1 ELSE 0 END) AS detractors,
            SUM(CASE WHEN score BETWEEN 7 AND 8 THEN 1 ELSE 0 END) AS passives,
            SUM(CASE WHEN score BETWEEN 9 AND 10 THEN 1 ELSE 0 END) AS promoters,
            SUM(1) AS total
          FROM "answers"
          INNER JOIN "contacts" ON "contacts"."id" = "answers"."contact_id"
          INNER JOIN "campaigns" ON "campaigns"."id" = "contacts"."campaign_id"
          WHERE "campaigns"."id" IN (#{campaigns}) #{topic_query}AND date(answers.created_at) BETWEEN $1 AND $2
          GROUP BY date(answers.created_at)
          ORDER BY answer_date
        HEREDOC
        ActiveRecord::Base.connection.select_all(query, nil, [[nil, start_date], [nil, end_date]])
    end
end
