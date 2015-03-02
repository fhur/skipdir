require 'minitest/autorun'
require 'skipdir.rb'

describe SkipDir do

  before :each do
    @location = "./pkg/tmp-#{(rand*(10**15)).to_i}.skipdir"
    @skipdir = SkipDir.new @location
  end

  after :each do
    `rm #{@location}`
  end

  describe 'add' do
    it 'should add a new entry to skipdir' do
      @skipdir.add 'foo','./tmp/bar/foo/'
      @skipdir.get('foo').wont_be_nil
    end

    it 'should return a map of all existing entries' do
      entries = {
        'foo': './tmp/dir1',
        'bar': './tmp/dir2',
        'baz': './tmp/dir3'
      }
      entries.each do |key, val|
        @skipdir.add key, val
      end

      stored_entries = @skipdir.add 'new','./dir/to/file'
      stored_entries.size.must_equal 4
      stored_entries['new'].must_equal './dir/to/file'
    end
  end

  describe 'get' do
    it 'should return nil for non existing entires' do
      entry = @skipdir.get('some-non-existing-entry')
      entry.must_equal nil
    end

    it 'should return the dir of an entry if it matches' do
      entries = {
        'foo': './tmp/dir1',
        'bar': './tmp/dir2',
        'baz': './tmp/dir3'
      }
      entries.each do |key, val|
        @skipdir.add key, val
      end

      @skipdir.get('foo').must_equal './tmp/dir1'
    end

  end

end
