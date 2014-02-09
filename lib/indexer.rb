require 'elasticsearch'

module LHC  
  class Indexer
    attr_reader :client
    
    require "./lib/mappings.rb"
    
    def initialize(server, port = nil)
      if port
        @client = Elasticsearch::Client.new host: server, port: port
      else
        @client = Elasticsearch::Client.new host: server
      end
    end
    
    def add_doc(index_name, type, doc)
      # example doc - { title: "Test1", text: "Hello World!"}
      @client.indices.create index: index_name, type: type, body: doc
    end
    
    def create_index(name)
      mappings = get_mappings(name)
      @client.indices.create index: name,
                            body: {
                              settings: {
                                index: {
                                  number_of_shards: 1,
                                  number_of_replicas: 0
                                },
                                analysis: {
                                  filter: {
                                    ngram: {
                                      type: 'nGram',
                                      min_gram: 3,
                                      max_gram: 25
                                    }
                                  },
                                  analyzer: {
                                    ngram: {
                                      tokenizer: 'whitespace',
                                      filter: ['lowercase', 'stop', 'ngram'],
                                      type: 'custom'
                                    },
                                    ngram_search: {
                                      tokenizer: 'whitespace',
                                      filter: ['lowercase', 'stop'],
                                      type: 'custom'
                                    }
                                  }
                                }
                              },
                              mappings: mappings[:contents]
                            }
    end
    
    def get_mappings(index_name)
      Mappings.all_mappings[index_name.to_sym]
    end
  end
end