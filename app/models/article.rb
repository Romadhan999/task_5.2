class Article < ActiveRecord::Base
  require 'csv'
  #attr_accessible :title, :content, :status
  #name relation must plural
  has_many :comments, dependent: :destroy
  paginates_per 2

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv.add_row column_names
      all.each do |article|
        values = article.attributes.values
        csv.add_row values
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      article_hash = row.to_hash
      article = Article.where(id: article_hash["id"])
      if article.count == 1
        article.first.update_attributes(article_hash)
      else
        Article.create!(article_hash)
      end
    end
  end
end
