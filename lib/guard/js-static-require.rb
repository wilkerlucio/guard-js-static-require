require 'guard'
require 'guard/guard'

module Guard
  class Jsstaticrequire < Guard
    DEFAULT_OPTIONS = {
      :build_on_start => false,
      :libs           => [],
      :start_delim    => /<!-- START JS_STATIC_REQUIRE -->/,
      :end_delim      => /<!-- END JS_STATIC_REQUIRE -->/
    }

    attr_accessor :files

    # Initialize a Guard.
    # @param [Array<Guard::Watcher>] watchers the Guard file watchers
    # @param [Hash] options the custom Guard options
    def initialize(watchers = [], options = {})
      defaults = DEFAULT_OPTIONS.clone

      @files = []

      options[:libs].each do |lib|
        watchers << ::Guard::Watcher.new(%r{^#{ lib }/(.+\.js)$})
      end

      super(watchers, defaults.merge(options))
    end

    # Call once when Guard starts. Please override initialize method to init stuff.
    # @raise [:task_has_failed] when start has failed
    def start
      run_all if options[:build_on_start]
    end

    # Called when `stop|quit|exit|s|q|e + enter` is pressed (when Guard quits).
    # @raise [:task_has_failed] when stop has failed
    def stop
    end

    # Called when `reload|r|z + enter` is pressed.
    # This method should be mainly used for "reload" (really!) actions like reloading passenger/spork/bundler/...
    # @raise [:task_has_failed] when reload has failed
    def reload
    end

    # Called when just `enter` is pressed
    # This method should be principally used for long action like running all specs/tests/...
    # @raise [:task_has_failed] when run_all has failed
    def run_all
      UI.info "Injecting scripts on #{options[:updates]}"

      reset_files
      inject_script_load

      Notifier.notify("Success injected scripts on #{options[:updates]}")
    end

    # Called on file(s) modifications that the Guard watches.
    # @param [Array<String>] paths the changes files or paths
    # @raise [:task_has_failed] when run_on_change has failed
    def run_on_change(paths)
      return unless contains_new_path?(paths)
      run_all
    end

    # Called on file(s) deletions that the Guard watches.
    # @param [Array<String>] paths the deleted files or paths
    # @raise [:task_has_failed] when run_on_change has failed
    def run_on_deletion(paths)
      run_all
    end

    def reset_files
      @files = scan_libs(options[:libs])
    end

    def scan_libs(libs)
      libs.map { |path| scan_path(path) }.flatten.uniq
    end

    def scan_path(path)
      if File.directory? path
        Dir.glob(path + "/**/*.js").sort do |a, b|
          da = a.split(File::SEPARATOR)
          db = b.split(File::SEPARATOR)

          comp = da.length <=> db.length

          if comp == 0
            a <=> b
          else
            comp
          end
        end
      else
        [path]
      end
    end

    def contains_new_path?(paths)
      (paths - @files).length > 0
    end

    def inject(value, source)
      if os = source.match(options[:start_delim]) and oe = source.match(options[:end_delim])
        os = os.end(0)
        oe = oe.begin(0)
        source[os...oe] = value
      end

      source
    end

    def tabulation(source)
      if os = source.match(options[:start_delim])
        line = source[0...os.begin(0)].split(/\r\n|\r|\n/).last

        spaces = line.match(/^([\s\t]*)/)
        spaces[1]
      else
        nil
      end
    end

    def build_load_string(source)
      tab = tabulation(source)
      scripts = "\n"

      @files.each do |file|
        scripts += %Q{#{tab}<script type="text/javascript" src="#{relative_path(options[:updates], file)}"></script>\n}
      end

      scripts += tab
      scripts
    end

    def relative_path(target, path)
      target_dir = File.expand_path(File.dirname(target)).split(File::SEPARATOR)
      path_dir = File.expand_path(File.dirname(path)).split(File::SEPARATOR)

      while target_dir.length > 0 and target_dir.first == path_dir.first
        target_dir.shift
        path_dir.shift
      end

      (".." + File::Separator) * (target_dir.length) + path_dir.push(File.basename(path)).join(File::SEPARATOR)
    end

    def inject_script_load
      source = File.read(options[:updates])
      loader = build_load_string(source)
      result = inject(loader, source)

      File.open(options[:updates], "wb") do |file|
        file << result
      end
    end
  end
end
