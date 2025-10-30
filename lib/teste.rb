require 'logger'
require_relative '../lib/utils/app_logger'
# class AppLogger
#   COLORS = {
#     'DEBUG' => "\e[34m",  # Blue
#     'INFO'  => "\e[32m",  # Green
#     'WARN'  => "\e[33m",  # Yellow
#     'ERROR' => "\e[31m",  # Red
#     'FATAL' => "\e[35m",  # Magenta
#     'RESET' => "\e[0m"
#   }
#
#   def self.instance
#     @logger ||= begin
#                   logger = Logger.new($stdout)
#                   logger.level = Logger::DEBUG
#                   logger.formatter = proc do |severity, datetime, progname, msg|
#                     color = COLORS[severity] || COLORS['RESET']
#                     reset = COLORS['RESET']
#                     "#{color}[#{datetime.strftime('%Y-%m-%d %H:%M:%S')}] #{severity}: #{msg}#{reset}\n"
#                   end
#                   logger
#                 end
#   end
#
#   class << self
#     %i[debug info warn error fatal].each do |method|
#       define_method(method) { |msg| instance.send(method, msg) }
#     end
#   end
#
# end

# --- Example test ---
AppLogger.debug("Debug in blue")
AppLogger.info("Info in green")
AppLogger.warn("Warning in yellow")
AppLogger.error("Error in red")
AppLogger.fatal("Fatal in magenta")
