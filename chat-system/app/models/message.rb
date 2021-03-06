# require 'elasticsearch/model'

class Message < ApplicationRecord

  # model association
  belongs_to :chat


  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  index_name Rails.application.class.parent_name.underscore
  document_type self.name.downcase


  settings index: { number_of_shards: 1 } do
    mapping dynamic: false do
      indexes :content, analyzer: 'english'
      end
    end

  # overriding the default as_indexed_json method and choose which fields are included in the JSON representation of a record that is sent to ES.
  def as_indexed_json(options = nil)
    self.as_json( only: [ :content ] )
  end


end

Message.__elasticsearch__.create_index! force: true
Message.import force: true # for auto sync model with elastic search
