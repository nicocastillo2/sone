xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'

xml.urlset :xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9' do

  @links.each do |link|
    
    xml.url do
      xml.loc link[:url]
      xml.lastmod '2018-04-24'
      xml.priority link[:priority]
    end
    
  end
  
end