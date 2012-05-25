class Packup
  VERSION = '0.0.1'

  def self.stuff name, &block
    package = self.new name
    package.instance_eval &block if block_given?
    package
  end

  attr_reader :name

  def initialize name
    @name = name
    @version = nil
    @author = nil
  end

  def version value = nil
    return @version if value.nil?
    @version = value
  end

  def author value = nil
    return @author if value.nil?
    @author = value
  end
end
