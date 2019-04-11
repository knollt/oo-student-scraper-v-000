require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

attr_accessor :students

  def self.scrape_index_page(index_url)
    index_doc = Nokogiri::HTML(open(index_url)
    students = []
    student_cards = index_doc.css(".student-card").each do |student_card|
      students << {
        :name => student_card.css("h4.student-name").text,
        :location => student_card.css("p.student-location").text,
        :profile_url => "./fixtures/student-site/" + student_card.css("a").attribute("href").value
        }
    end
    students
  end

  def self.scrape_profile_page(profile_url)
      student_profile = {}
      html = open(profile_url)
      profile = Nokogiri::HTML(html)

      # Social Links

      profile.css("div.main-wrapper.profile .social-icon-container a").each do |social|
        if social.attribute("href").value.include?("twitter")
          student_profile[:twitter] = social.attribute("href").value
        elsif social.attribute("href").value.include?("linkedin")
          student_profile[:linkedin] = social.attribute("href").value
        elsif social.attribute("href").value.include?("github")
          student_profile[:github] = social.attribute("href").value
        else
          student_profile[:blog] = social.attribute("href").value
        end
      end

      student_profile[:profile_quote] = profile.css("div.main-wrapper.profile .vitals-text-container .profile-quote").text
      student_profile[:bio] = profile.css("div.main-wrapper.profile .description-holder p").text

      student_profile
      end


end
