require 'bundler'
Bundler.setup

require 'pg'
require './lib/indexer'
require "./lib/mappings"

require "./models/section"
require "./models/paragraph"
require "./models/component"
require "./models/daily_part"

task :environment do
  env = ENV["RACK_ENV"] ? ENV["RACK_ENV"] : "development"
  config = YAML::load(File.open('config/database.yml'))
  ActiveRecord::Base.establish_connection(config[env])
  puts "** #{env}"
end

desc "create indexes"
task :create_indexes do
  host = ENV['host']
  port = ENV['port']
  
  if host and port
    indexer = LHC::Indexer.new(host, port)
  else
    indexer = LHC::Indexer.new
  end
  
  Mappings.index_names.each do |index_name|
    begin
      indexer.create_index(index_name)
      p "created index: #{index_name}"
    rescue Elasticsearch::Transport::Transport::Errors::BadRequest => e
      if e.message.include?("IndexAlreadyExistsException")
        p "skipped index: #{index_name} (already exists)"
      else
        raise e # re-raise if it's not the error we were expecting
      end
    end
  end
end

desc "index all the things"
task :index_queue => :environment do
  #ensure the indexes are created properly
  Rake::Task["create_indexes"].execute
  
  require "action_view/helpers/sanitize_helper"
  
  host = ENV['host']
  port = ENV['port']
  
  if host and port
    indexer = LHC::Indexer.new(host, port)
  else
    indexer = LHC::Indexer.new
  end
  section = Section.where.not(indexed: true, type: ["Preamble", "Container"]).order("ident ASC").limit(1).last
  
  while section
    # do index
    if section.house == "Commons"
      index_name = "commons_hansard"
    else
      index_name = "lords_hansard"
    end
    
    p section.hansard_ref
    
    sanitizer = HTML::FullSanitizer.new
    
    text = section.paragraphs.map { |x| sanitizer.sanitize(x.content) }
    doc = {
        id: section.ident,
        title: section.title,
        text: text,
        date: section.component.daily_part.date,
        url: section.url,
        hansard_ref: section.hansard_ref,
        hansard_component: section.component.name,
        members: section.members,
        chair: section.chair,
        number: section.number,
        question_type: section.question_type
      }
    
    indexer.add_doc(index_name, doc)
    
    # ToDo - if the :delete_indexed_text is set, clear the unneccesary fields
    
    # update the flag
    section.indexed = true
    section.save
    #
    # get the next one
    section = Section.where.not(indexed: true, type: ["Preamble", "Container"]).order("ident ASC").limit(1).last
  end
end