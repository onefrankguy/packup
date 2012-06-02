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
  attr_reader :files

  def initialize name
    @name = name
    @version = nil
    @author = nil
    @files = {}
  end

  def version value = nil
    return @version if value.nil?
    @version = value
  end

  def author value = nil
    return @author if value.nil?
    @author = value
  end

  def file values
    @files.merge! values
  end

  def make_tasks
    make_wix_folder_task
    make_source_file_tasks
    make_destination_file_tasks
    make_sourcery_wxs_file_task
    make_product_wxs_file_task
    make_product_wixobj_file_task
    make_sourcery_wixobj_file_task
    make_msi_file_task
  end

  def make_source_file_tasks 
    files = @files.keys.reject { |src| Rake::FileTask.task_defined?(src) }
    files.each do |source|
      type = File.directory?(source) ? 'folder' : 'file'
      task = Rake::FileTask.define_task source
      task.comment = "Create the #{source} #{type}"
    end
  end

  def make_destination_file_tasks
    @files.each do |source, destination|
      dest = File.join('wix', 'src', destination)
      next if Rake::FileTask.task_defined? dest
      type = File.directory?(source) ? 'folder' : 'file'
      task = Rake::FileTask.define_task dest do |t|
        folder = File.dirname(t.name)
        FileUtils.mkpath folder unless File.directory? folder
        FileUtils.copy source, t.name
      end
      task.comment = "Create the #{dest} #{type}"
      task.enhance ['wix', source]
    end
  end

  def make_wix_folder_task
    return if Rake::FileTask.task_defined? 'wix'
    wix = Rake::FileTask.define_task 'wix' do |t|
      FileUtils.mkpath t.name
    end
    wix.comment = 'Create the WiX folder'
  end

  def make_sourcery_wxs_file_task
    return if Rake::FileTask.task_defined? 'wix/Sourcery.wxs'
    return if @files.empty?
    sourcery = Rake::FileTask.define_task 'wix/Sourcery.wxs' do |t|
      args = []
      args << '-nologo' # Skip printing of the WiX logo
      args << '-sfrag'  # Suppress fragments
      args << '-srd'    # Don't harvest the root directory e.g. wix\src
      args << '-ag'     # Auto generate GUIDs
      args << '-ke'     # Keep empty directories
      args << '-template fragment'
      args << '-dr INSTALLDIR'
      args << '-var var.Source'
      args = args.join(' ')
      sh "heat dir wix/src #{args} -out #{t.name}"
    end
    sourcery.comment = 'Create the Sourcery.wxs file'
    sourcery.enhance ['wix']
    sourcery.enhance @files.values.map { |dest| File.join('wix', 'src', dest) }
  end

  def make_product_wxs_file_task
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
    if Rake::FileTask.task_defined? 'wix/Sourcery.wxs'
      wxs.enhance ['wix/Sourcery.wxs']
    end
  end

  def make_product_wixobj_file_task
    return if Rake::FileTask.task_defined? "wix/#{name}.wixobj"
    wixobj = Rake::FileTask.define_task "wix/#{name}.wixobj" do |t|
      sh "candle -nologo wix/#{name}.wxs -o #{t.name}"
    end
    wixobj.comment = "Create the #{name}.wixobj file"
    wixobj.enhance ["wix/#{name}.wxs"]
  end

  def make_sourcery_wixobj_file_task
    return unless Rake::FileTask.task_defined? 'wix/Sourcery.wxs'
    wixobj = Rake::FileTask.define_task 'wix/Sourcery.wixobj' do |t|
      sh "candle -nologo wix/Sourcery.wxs -dSource=wix/src -o #{t.name}"
    end
    wixobj.comment = 'Create the Sourcery.wixobj file'
    wixobj.enhance ['wix/Sourcery.wxs']
  end

  def make_msi_file_task
    return if Rake::FileTask.task_defined? "wix/#{name}.msi"
    wixobjs = Rake::FileTask.tasks.select { |t| t.name.end_with? '.wixobj' }
    wixobjs.map! { |t| t.name }
    msi = Rake::FileTask.define_task "wix/#{name}.msi" do |t|
      sh "light -nologo #{wixobjs.join(' ')} -o #{t.name}"
    end
    msi.comment = "Create the #{name}.msi file"
    msi.enhance wixobjs
  end
end
