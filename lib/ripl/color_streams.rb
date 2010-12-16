require 'ripl'

module Ripl
  module ColorStreams
    VERSION = '0.1.1'
    COLORS = {
      :nothing      => '0;0',
      :black        => '0;30',
      :red          => '0;31',
      :green        => '0;32',
      :brown        => '0;33',
      :blue         => '0;34',
      :purple       => '0;35',
      :cyan         => '0;36',
      :light_gray   => '0;37',
      :dark_gray    => '1;30',
      :light_red    => '1;31',
      :light_green  => '1;32',
      :yellow       => '1;33',
      :light_blue   => '1;34',
      :light_purple => '1;35',
      :light_cyan   => '1;36',
      :white        => '1;37',
    }

    def before_loop
      # patch $stdout/$stderr
      Ripl::ColorStreams.patch_stream :stdout
      Ripl::ColorStreams.patch_stream :stderr

      # call ripl / next plugin
      super
    end

    def loop_eval(input)
      Ripl::ColorStreams.set_stream_status :stdout, true
      Ripl::ColorStreams.set_stream_status :stderr, true
      super
    ensure
      Ripl::ColorStreams.set_stream_status :stdout, false
      Ripl::ColorStreams.set_stream_status :stderr, false
    end

    class << self
      def write_stream(stream_name, data)
        stream = Object.const_get stream_name.to_s.upcase
        color_config = Ripl.config[ ('color_streams_' + stream_name.to_s).to_sym ]
        color_code   = !color_config || color_config.to_s[/^[\d;]+$/] ?
          color_config : Ripl::ColorStreams::COLORS[color_config.to_sym]

        stream.real_write color_code ? "\e[#{ color_code }m#{ data }\e[0;0m" : data.to_s
      end

      # patch stream output (but do not activate)
      def patch_stream(stream_name)
        stream = Object.const_get stream_name.to_s.upcase

        stream.instance_eval do
          alias real_write write
          def color_write(*args) # define_method is not defined for singletons :/
            stream_name = (self == $stdout) ? :stdout : :stderr
            Ripl::ColorStreams.write_stream stream_name, *args
          end
        end
      end

      def set_stream_status(stream_name, true_or_false)
        stream = Object.const_get stream_name.to_s.upcase

        # check if stream object has changed
        unless stream.respond_to?(:real_write) && stream.respond_to?(:color_write)
          Ripl::ColorStreams.patch_stream stream_name
        end

        # (de)activate
        if true_or_false
          stream.instance_eval do alias write color_write end
        else
          stream.instance_eval do alias write real_write  end
        end
      end
    end
  end
end

Ripl::Shell.send :include, Ripl::ColorStreams

# default settings
Ripl.config[:color_streams_stdout] ||= :dark_gray
Ripl.config[:color_streams_stderr] ||= :light_red

# J-_-L
