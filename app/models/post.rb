require 'active_model'
require 'yaml/store'
class Post
  include ActiveModel::Model

  attr_accessor :author, :message, :created_at, :id

  validates_presence_of :author
  validates_presence_of :message

  STORE_FILE = File.join(File.dirname(__FILE__), "../../data/posts.yml")

  def initialize(attributes = {})
    self.author = attributes[:author]
    self.message = attributes[:message]
    self.created_at = attributes[:created_at]
    self.id = attributes[:id]
  end

  def save
    if valid?
      if !persisted?
        store.transaction do
          store[:posts] ||= {}
          self.id = store[:posts].size + 1
          self.created_at = Time.now
          store[:posts][id] = self.attributes
        end
      end
    else
      return false
    end
  end

  def persisted?
    id.present?
  end

  def attributes
    {
      author: self.author,
      message: self.message,
      id: self.id,
      created_at: self.created_at
    }
  end

  class << self
    def all
      posts = []
      store.transaction do
        posts = (store[:posts] || []).map do |key, attributes|
          new(attributes)
        end
      end
      posts
    end

    def store
      @store ||= YAML::Store.new(STORE_FILE)
    end
  end

  protected
  def store
    self.class.store
  end
end
