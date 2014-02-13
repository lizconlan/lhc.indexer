require 'elasticsearch'

module LHC  
  class Indexer
    attr_reader :client
    
    require "./lib/mappings.rb"
    
    def initialize(*args)
      @settings = YAML::parse(File.read("./config/indexer.yml")).to_ruby
      server = args[0]
      port = args[1]
      if port and server
        @client = Elasticsearch::Client.new host: server, port: port
      elsif server
        @client = Elasticsearch::Client.new host: server
      else
        @client = Elasticsearch::Client.new host: @settings[:server], port: @settings[:port]
      end
      
    end
    
    def add_doc(index_name, type, doc)
      # example doc - { title: "Test1", text: "Hello World!"}
      @client.create index: index_name, type: type, body: doc
    end
    
    def create_index(name)
      mappings = get_mappings(name)
      @client.indices.create index: name,
                            body: {
                              settings: {
                                index: {
                                  number_of_shards: 1,
                                  number_of_replicas: 0,
                                  analysis: {
                                    analyzer: {
                                      default: {
                                        type: "custom",
                                        tokenizer: "standard",
                                        filter: ["standard", "asciifolding", "lowercase", "stop"],
                                        stopwords: @settings[:stopwords]
                                      }
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