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
    house_letter = house[0].upcase()
    ref_date = component.daily_part.date.strftime("%e %B %Y")
    vol = component.daily_part.volume
    part = component.daily_part.part
    if columns.length > 1 and columns.first < columns.last
      significant_digits = column_significant_digits(columns.first.to_i, columns.last.to_i)
      if columns.first =~ /\d+(.*)$/
        suffix = $1
      else
        suffix = ""
      end
      col = "cc#{columns.first.gsub(suffix, '')}-#{significant_digits}#{suffix}"
    else
      col = "c#{columns.first}"
    end
    %Q|H#{house_letter} Deb #{component.date.strftime("%e %b %Y")} vol #{vol} #{col}|.squeeze(" ")
  end
  
  
  private
  
  def column_significant_digits(start_number, end_number)
    start_text = start_number.to_s
    end_text = end_number.to_s
    if end_text.size > start_text.size
      significant_digits = end_text
    else
      start_part = start_text
      end_part = end_text
      while start_part && end_part && start_part[0] == end_part[0]
        start_part = start_part[1, (start_part.size - 1)]
        end_part = end_part[1, (end_part.size - 1)]
      end
      significant_digits = end_part
    end
    significant_digits
  end
end

class Container < Section
end

class Debate < Section
end

class Statement < Section
end

class Petition < Section
end

class PetitionObservation < Section
end

class MinisterialCorrection < Section
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

class SectionGroup < Section
end

class QuestionGroup < Section
end