require 'set'

class SkipDir

  def initialize(location)
    @location = location
    unless File.exist? @location
      File.open(@location, 'w') do end
    end

    @entries = read_map
  end

  # Adds a mapping from the given name to the given directory
  # @return a list of all current mappings as an array
  def add(name, dir)
    @entries[name.to_s] = dir.to_s
    save_map
    return @entries
  end

  # The current mapping for the given alias or nil if there is no mapping
  def get(name)
    entry = @entries[name]
    if entry
      return entry
    else
      @entries.each do |name_alias, dir|
        return dir if name_alias.start_with? name
      end
    end
    return nil
  end

  # A list of all current mappings
  def all
    @entries
  end


  # removes the entry with the given name.
  # @return the removed dir or nil if no entry was found with that name
  def remove(name)
    if @entries.include? name
      dir = @entries[name]
      @entries.delete name
      save_map
      return dir
    else
      return nil
    end
  end

  private

  # Reads from the file at @location (which is expected to exist)
  # and creates a map. This file should be composed of lines where each
  # line is a "name value" pair. There can only be one " " character per line
  # which is the separation character.
  def read_map
    file = File.read(@location)

    lines = file.split("\n")
    entries = {}
    lines.each do |line|
      entry = line.gsub("alias 'sd-",'')
        .gsub("'cd ",'')
        .gsub("'",'')
        .split("=")
      entries[entry[0]] = entry[1]
    end

    return entries
  end

  # Saves the current @entries map to the file at @location
  def save_map
    File.open(@location, 'w') do |file|
      @entries.each do |key, value|
        file.write "alias 'sd-#{key}'='cd #{value}'\n"
      end
    end
  end
end
