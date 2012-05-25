require 'rake'

class Packup
  VERSION = '0.0.1'

  include Rake::DSL

  def self.stuff name, &block
    package = self.new name
    package.instance_eval &block if block_given?
    package.make_tasks
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

  def make_tasks
    make_wix_folder_task
  end

  def make_wix_folder_task
    return if Rake::FileTask.task_defined? 'wix'
    wix = Rake::FileTask.define_task 'wix' do |t|
      mkpath t.name
    end
    wix.comment = 'Create the WiX folder'
  end
end
