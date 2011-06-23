require 'digest/md5'

class Activity
  include DataMapper::Resource
  property :id, Serial
  property :name, String, :length => 255
  property :created, DateTime
  property :last_worked_on, DateTime
  has n, :persons
  
  def self.being_worked_on
    Activity.all().select {|a| a.persons.length > 0 }
  end
end

class Person
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :email, String
  belongs_to :activity, :required => false
  
  def gravatar
    digest = Digest::MD5.hexdigest(self.email)
    "http://www.gravatar.com/avatar.php?gravatar_id=#{digest}&s=60"
  end
  
  def working_on(activity_name)
    if activity_name
      wordcount = 8
      words = activity_name.split
      name = words[0...wordcount].join(" ") + (words.size > wordcount ? "..." : "")
      self.activity = Activity.first_or_create :name=>name
      self.save
    else
      self.activity = nil
      self.save
    end
  end
  
end
