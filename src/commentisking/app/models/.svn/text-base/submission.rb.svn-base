require 'hpricot'
require "uri"

class Submission < ActiveRecord::Base
  
  # virtual
  attr_accessor :title, :doc, :h1, :h2, :icon, :uri_obj

  attr_accessible :address
  
  validates_presence_of     :address
  validates_length_of       :address,    :within => 3..255

  # recent
  named_scope :recent, :order=>"created_at DESC"


  # http://actsasblog.wordpress.com/2006/10/16/url-validation-in-rubyrails/
  # http://paulsturgess.co.uk/articles/show/33-how-to-write-custom-validation-in-ruby-on-rails
  def validate    
    begin
      uri = URI.parse(self.address)
      if uri.class != URI::HTTP
         errors.add(:address, 'Only HTTP protocol addresses can be used')
      end
    rescue URI::InvalidURIError
       errors.add(:address, 'The format of the url is not valid.')
    end
  end
  
  def prepare
    begin
      self.uri_obj = URI.parse(self.address)      
    rescue 
      self.uri_obj = nil
    end
    
    # download the post for processing
    self.doc = Submission.load_doc(self.address)
    return if self.doc.blank?
    
    #  load the <title> from the head
    title_element = (self.doc/"html/head/title")
    if !title_element.blank? and !title_element.empty?
      self.title = title_element.first.inner_html
    end
    
    #  the first h1
    h1_element = (self.doc/"html/body//h1")
    if !h1_element.blank? and !h1_element.empty?
      self.h1 = h1_element.first.inner_html
    end
    #  the first h2
    h2_element = (self.doc/"html/body//h2")
    if !h2_element.blank? and !h2_element.empty?
      self.h2 = h2_element.first.inner_html
    end
    #  load the icon
    load_icon
  end
  
  
  def load_icon
    
    # look for blogger comments
    (self.doc/"html/head/link").each do |link|
      if link.attributes['rel'].strip == "shortcut icon" or link.attributes['rel'].strip == "icon"
        href = link.attributes['href']
        # check for absolute or relative
        if href.index('http://')
          # abs
          self.icon = href
        else
          # relative
          self.icon = (uri_obj.host.to_s + '/' + href) if !uri_obj.nil?
        end
        # we are done
        break        
      end
    end
    
  end
  
  
  def post_title
    return self.title || self.h1 || self.h2 || nil
  end
    
    
  def self.load_doc(address)
    doc = nil
    begin
      doc = Hpricot(open(address))    
    rescue Hpricot::ParseError
      doc = nil
    rescue
      doc = nil
    end
    return doc
  end
    
end