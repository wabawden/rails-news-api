require 'open-uri'
require 'json'
class PagesController < ApplicationController
  def home
    @top_ten_bbc = parse("bbc-news")
    @top_ten_fox = parse("fox-news")
    @top_ten_buzz = parse("buzzfeed")
  end

  def parse(site)
    url = "https://newsapi.org/v2/everything?sources=#{site}&from=#{Date.today}&to=#{Date.today}&pageSize=100&apiKey=dbb95aa553c040c0b8f13785149018b4"
    req = open(url)
    response_body = JSON.parse(req.read)
    stop_words = %w(a about after again against all am an and any are arent as at bbc be because been before being below between both but by cant cannot above could couldnt did didnt do does doesnt doing dont down during each few for from further had hadnt has hasnt have havent having he hed hell hes her here heres hers herself him himself his how hows i id ill im ive if in into is isnt it its itself lets me more most mustnt my myself new no nor not of off on once only or other ought our our ourselves out over own same says shant she shed shell shes should shouldnt so some such than that thats the their theirs them themselves then there theres these they theyd theyll theyre theyve this those through to too under until up very was wasnt we wed well were weve were werent what whats when whens where wheres which while will who whos whom why whys with wont would wouldnt you youd youll youre youve your yours yourself yourselves)
    words = []
    response_body["articles"].each do |article|
      if article["title"].include? "2020"
        next
      else
        words << article["title"].downcase.split(" ").map { |word| word.gsub(/\W/, "")}
      end
    end
    word_hash = Hash.new
    words.flatten.each do |word|
      if (stop_words.include? word) || word.length < 3
        next
      elsif word_hash[word]
        word_hash[word] += 1
      else
        word_hash[word] = 1
      end
    end
    top_ten = []
    word_hash.sort_by { |k, v| v }.reverse.first(10).each { |word| top_ten << word[0]}
    top_ten
  end
end
