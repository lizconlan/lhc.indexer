#encoding: utf-8

require 'active_record'

class Section < ActiveRecord::Base
  belongs_to :component
  has_many :paragraphs
  has_many :sections, :foreign_key => 'parent_section_id', :dependent => :destroy
  belongs_to :parent_section, :class_name => "Section", :foreign_key => 'parent_section_id'
  
  def house
    component.daily_part.house
  end
  
  def hansard_ref
    house_letter = house[0]
    ref_date = component.daily_part.date.strftime("%e %B %Y")
    vol = component.daily_part.volume
    part = component.daily_part.part
    if columns.length > 1 and columns.first < columns.last
      col = "cc #{columns.first} to #{columns.last}"
    else
      col = "c#{columns.first}"
    end
    %Q|H#{house_letter} Deb vol #{vol} #{col} (Part #{part})|.squeeze(" ")
  end
end

class Container < Section
end

class Debate < Section
end

class Statement < Section
end

class Question < Section
end

class Preamble < Section
end

class MemberIntroduction < Section
end

class Tribute < Section
end

class Division < Section
end