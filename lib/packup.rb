require 'rake'
require 'erb'

class Packup
  ##
  # In a pre-alpha state at the moment.

  VERSION = '0.0.1'

  ##
  # Excutes the Packup DSL to define your package's definition
  # (which internalliy creates Rake tasks). All Packup attributes and
  # methods are available within +block+. Eg:
  #
  #   Packup.stuff name do
  #     # ... package specific data ...
  #   end

  def self.stuff name, &block
    package = self.new name
    package.instance_eval &block if block_given?
    package.post_process
    package
  end

  ##
  # *MANDATORY*: The name of the package.
  #
  # Set with Packup.stuff.

  attr_reader :name

  ##
  # Optional: Files the package will install. 

  attr_reader :files

  ##
  # Creates a newly initialized package description.

  def initialize name
    @name = name
    @version = nil
    @author = nil
    @files = {}
  end

  ##
  # Returns the package's version. Sets the version to +value+ if given.

  def version value = nil
    return @version if value.nil?
    @version = value
  end

  ##
  # Returns the package's author. Sets the author to +value+ if given.

  def author value = nil
    return @author if value.nil?
    @author = value
  end

  ##
  # Adds files to the package. +values+ is a Hash from source to
  # destination. Eg:
  #
  #   file 'source/file' => 'destination/file'
  #
  # or
  #
  #   file {
  #     'src/wand.exe' => 'bin/wand.exe',
  #     'src/wand.chm' => 'doc/wand.chm'
  #   }
  #
  # Implicitly, this creates Rake tasks to copy the files from source to
  # destination. You can skip the creation of those tasks by manually
  # placing your files in the <tt>wix/src</tt> folder. Eg:
  #
  #   task :setup do
  #     mkpath 'wix/src'
  #     cp_r 'src', 'wix/src'
  #   end
  #
  #   Packup.stuff 'Magic'
  #
  #   Rake::Task['wix/Sourcery.wxs'].enhance [:setup]

  def file values
    @files.merge! values
  end

  ##
  # Finalizes the package description.

  def post_process
    bind_files
    make_tasks
  end

  ##
  # Makes all destination file paths relative to INSTALLDIR.

  def bind_files
    @files.each do |source, destination|
      @files[source] = File.join('wix', 'src', destination)
    end
  end

  ##
  # Generates all the Rake tasks.

  def make_tasks
    make_clean_task
    make_wix_folder_task
    make_copy_file_tasks
    make_sourcery_wxs_file_task
    make_sourcery_wixobj_file_task
    make_product_wxs_file_task
    make_product_wixobj_file_task
    make_msi_file_task
    make_msi_task
    make_test_task
  end

  ##
  # Generates the :clean task, which deletes all the generated files.

  def make_clean_task
    return if Rake::Task.task_defined? :clean
    task = Rake::Task.define_task :clean do
      FileUtils.remove_dir 'wix', true
    end
    task.comment = 'Remove the WiX folder'
  end

  ##
  # Generates the 'wix' task.

  def make_wix_folder_task
    return if Rake::FileTask.task_defined? 'wix'
    wix = Rake::FileTask.define_task 'wix' do |t|
      FileUtils.mkpath t.name
    end
    wix.comment = 'Create the WiX folder'
  end

  ##
  # Generates tasks to copy files from source to destination. One task
  # is generated for each file. Destination file tasks trigger source
  # file tasks if they exist. So you can preprocess files. Eg:
  #
  #   file 'magic.min.js' do
  #     sh 'compress magic.js > magic.min.js'
  #   end
  #
  #   Packup.stuff 'Magic' do
  #     file 'magic.min.js' => 'scripts/magic.min.js'
  #   end

  def make_copy_file_tasks
    @files.each do |source, destination|
      next if Rake::FileTask.task_defined? destination
      type = File.directory?(source) ? 'folder' : 'file'
      task = Rake::FileTask.define_task destination do |t|
        folder = File.dirname(t.name)
        FileUtils.mkpath folder unless File.directory? folder
        FileUtils.copy source, t.name
      end
      task.comment = "Create the #{destination} #{type}"
      task.enhance ['wix']
      if Rake::FileTask.task_defined? source
        task.enhance [source]
      end
    end
  end

  ##
  # Generates the 'wix/Sourcery.wxs' task.

  def make_sourcery_wxs_file_task
    return if Rake::FileTask.task_defined? 'wix/Sourcery.wxs'
    sourcery = Rake::FileTask.define_task 'wix/Sourcery.wxs' do |t|
      if File.directory? 'wix/src'
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
        Rake.sh "heat dir wix/src #{args} -out #{t.name}"
      end
    end
    sourcery.comment = 'Create the Sourcery.wxs file'
    sourcery.enhance ['wix']
    sourcery.enhance @files.values
  end

  ##
  # Generates the 'wix/Sourcery.wixobj' task.

  def make_sourcery_wixobj_file_task
    return unless Rake::FileTask.task_defined? 'wix/Sourcery.wxs'
    wixobj = Rake::FileTask.define_task 'wix/Sourcery.wixobj' do |t|
      Rake.sh "candle -nologo wix/Sourcery.wxs -dSource=wix/src -o #{t.name}"
    end
    wixobj.comment = 'Create the Sourcery.wixobj file'
    wixobj.enhance ['wix/Sourcery.wxs']
  end

  ##
  # Generates the 'wix/name.wxs' task.

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

  ##
  # Generates the 'wix/name.wixobj' task.

  def make_product_wixobj_file_task
    return if Rake::FileTask.task_defined? "wix/#{name}.wixobj"
    wixobj = Rake::FileTask.define_task "wix/#{name}.wixobj" do |t|
      Rake.sh "candle -nologo wix/#{name}.wxs -o #{t.name}"
    end
    wixobj.comment = "Create the #{name}.wixobj file"
    wixobj.enhance ["wix/#{name}.wxs"]
  end

  ##
  # Generates the 'wix/name.msi' task.

  def make_msi_file_task
    return if Rake::FileTask.task_defined? "wix/#{name}.msi"
    wixobjs = Rake::FileTask.tasks.select { |t| t.name.end_with? '.wixobj' }
    wixobjs.map! { |t| t.name }
    msi = Rake::FileTask.define_task "wix/#{name}.msi" do |t|
      Rake.sh "light -nologo -sval #{wixobjs.join(' ')} -o #{t.name}"
    end
    msi.comment = "Create the #{name}.msi file"
    msi.enhance wixobjs
  end

  ##
  # Generates the :msi task, which creates the MSI.

  def make_msi_task
    return if Rake::Task.task_defined? :msi
    msi = Rake::Task.define_task :msi
    msi.comment = "Create the MSI"
    msi.enhance ["wix/#{name}.msi"]
  end

  ##
  # Generates the :test task, wich validates the MSI.

  def make_test_task
    return if Rake::Task.task_defined? :test
    test = Rake::Task.define_task :test do
      Rake.sh "smoke -nologo wix/#{name}.msi"
    end
    test.comment = 'Test the MSI'
  end
end
