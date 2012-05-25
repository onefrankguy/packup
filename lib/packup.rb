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
  end
end
