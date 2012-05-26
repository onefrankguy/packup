require 'rake'
require 'erb'

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
    make_wxs_file_task
    make_wixobj_file_task
    make_msi_file_task
  end

  def make_wix_folder_task
    return if Rake::FileTask.task_defined? 'wix'
    wix = Rake::FileTask.define_task 'wix' do |t|
      FileUtils.mkpath t.name
    end
    wix.comment = 'Create the WiX folder'
  end

  def make_wxs_file_task
    return if Rake::FileTask.task_defined? "wix/#{name}.wxs"
    wxs = Rake::FileTask.define_task "wix/#{name}.wxs" do |t|
      template_file = File.join(File.dirname(__FILE__), '..', 'templates', 'product.wxs.erb')
      template_data = File.read template_file
      template = ERB.new template_data
      template_results = template.result send(:binding)
      File.open(t.name, 'w') { |io| io << template_results }
    end
    wxs.comment = "Create the #{name}.wxs file"
    wxs.enhance ['wix']
  end

  def make_wixobj_file_task
    return if Rake::FileTask.task_defined? "wix/#{name}.wixobj"
    wixobj = Rake::FileTask.define_task "wix/#{name}.wixobj" do |t|
      sh "candle -nologo wix/#{name}.wxs -o #{t.name}"
    end
    wixobj.comment = "Create the #{name}.wixobj file"
    wixobj.enhance ["wix/#{name}.wxs"]
  end

  def make_msi_file_task
    return if Rake::FileTask.task_defined? "wix/#{name}.msi"
    msi = Rake::FileTask.define_task "wix/#{name}.msi" do |t|
      FileUtils.touch t.name
    end
    msi.comment = "Create the #{name}.msi file"
    msi.enhance ['wix']
  end
end
