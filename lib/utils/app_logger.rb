require 'logger'

class AppLogger
  COLORS = {
    'DEBUG' => "\e[34m",  # Blue
    'INFO'  => "\e[32m",  # Green
    'WARN'  => "\e[33m",  # Yellow
    'ERROR' => "\e[31m",  # Red
    'FATAL' => "\e[35m",  # Magenta
    'RESET' => "\e[0m"
  }

  def self.instance
    @logger ||= begin
                  logger = Logger.new($stdout)
                  logger.level = Logger::DEBUG

                  # Force colors always
                  colorize = true

                  logger.formatter = proc do |severity, datetime, progname, msg|
                    color = colorize ? COLORS[severity] : ''
                    reset = colorize ? COLORS['RESET'] : ''
                    "#{color}[#{datetime.strftime('%Y-%m-%d %H:%M:%S')}] #{severity}: #{msg}#{reset}\n"
                  end
                  logger
                end
  end

  class << self
    %i[debug info warn error fatal].each do |method|
      define_method(method) { |msg| instance.send(method, msg) }
    end
  end

end