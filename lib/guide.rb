require_relative 'MyStaticTest'

class Guide

  def self.populate_authorities_cache
    languages = {"english" => "eng", "german" => "deu", "finish" => "fsh"}
    get_vocabularies["languages"] = languages

    prodpersonrole = { "artist" => "art", "engineer" => "eng"}
    get_vocabularies["prodpersonrole"] = prodpersonrole

    person = { "john muir" => "john_muir", "luke skywalker" => "luke_skywalker"}
    get_personauthorities["person"] = person
  end

  def self.get_vocabularies
    @@authorities_cache[VOCABULARIES]
  end

  def self.get_personauthorities
    @@authorities_cache[PERSONAUTHORITIES]
  end

  VOCABULARIES = "vocabularies"
  PERSONAUTHORITIES = "personauthorities"

  @@authorities_cache = {VOCABULARIES => {}, PERSONAUTHORITIES => {}}

  a = MyStaticTest.new

  def initialize(path=nil)
    #
    # Populated the authority cache with terms
    #
    self.class.populate_authorities_cache
  end

  def launch!
    @@authorities_cache.each do |authority_type, authority_map|
      puts authority_type
      authority_map.each do |authority_id, term_map|
        puts "    " + authority_id
        term_map.each do |name, term_id|
          puts "    " + "    " + name + ":" + term_id
        end
      end
    end
    puts "***************************"

    #
    # Example set of column data for an authority term
    #
    field_value_list = ["personauthorities::person::::John Muir", "prodpersonrole::::Artist", "English", "German", "eng::English", "languages::eng::English", "vocabularies::languages::eng::English"]

    field_value_list.each do |field_value|
      segments = get_term_parts field_value

      if segments[:authority_type] == nil || segments[:authority_type].empty?
        segments[:authority_type] = "vocabularies"
      end

      if segments[:authority_id] == nil || segments[:authority_id].empty?
        segments[:authority_id] = "languages"
      end

      if segments[:term_id] == nil || segments[:term_id].empty?
        vocab_id = segments[:authority_id]
        term_id = lookup_authority_term_id segments[:authority_type], segments[:authority_id], segments[:display_name]
        puts "Found short ID =" + term_id if term_id
        segments[:term_id] = term_id if term_id
      end


      #
      # Output segments
      #
      puts "display_name:" + segments[:display_name] if segments[:display_name]
      puts "short_id:" + segments[:term_id] if segments[:term_id]
      puts "authority_id:" + segments[:authority_id] if segments[:authority_id]
      puts "authority_type:" + segments[:authority_type] if segments[:authority_type]
      puts "------------------"
    end
  end

  def split_term(field_value)
    values = []
      values << field_value
                  .to_s
                  .split("::")
                  .map(&:strip)
    values.flatten.compact
  end

  def get_term_parts(field_value)
    parts = split_term field_value
    parts_map = { :display_name => parts.pop, :term_id => parts.pop, :authority_id => parts.pop,
                    :authority_type => parts.pop }
  end

  def lookup_authority_term_id(authority_type, authority_id, display_name)
    authority_type = @@authorities_cache[authority_type]
    authority = authority_type[authority_id]
    term_id = authority[display_name.downcase]
  end



end
