#require "fileutils"


require_relative '../../lib/utils/app_logger'
# HOOK_LOGGER = Logger.new($stdout)
# HOOK_LOGGER.level = Logger::INFO

def get_feature_name(scenario)
  #Lê o arquivo .feature para encontrar a linha "Feature: ..."
  if scenario.respond_to?(:location) && scenario.location.respond_to?(:file)
    feature_path = scenario.location.file
    if File.exist?(feature_path)
      File.foreach(feature_path) do |line|
        return $1.strip if line.strip =~ /^Feature:\s*(.*)$/i
      end
    end
  end
  #Fallback
  "Desconhecida"
end

Before do |scenario|
  @start_time = Time.now
end


After do |scenario|
  end_time = Time.now
  duration = end_time - @start_time

  if scenario.failed?
    ex = scenario.exception

    # Cria diretório de logs se não existir
    #FileUtils.mkdir_p("logs")
    feature_name = get_feature_name(scenario)
    expected, actual = ex&.message.scan(/<"([^"]*)">/).flatten
    # Monta o texto do log
    log_entry = <<~LOG

      ===============================
      Erro no teste
      ------------- 
      DATA Execução: [#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}] 
      Feature : #{feature_name}
      Cenário : #{scenario.name}
      Tags    : #{scenario.source_tag_names.join(', ')}
      Local   : #{scenario.respond_to?(:location) ? scenario.location.to_s : 'N/D'}
      Status  : #{scenario.status}
      Erro    : Expected: #{expected}, Actual: #{actual}"
      Cenário #{scenario.name} executado em #{duration.round(2)} segundos
      -------------------------------
      Backtrace:
      #{ex&.backtrace&.join("\n")}
      ===============================
    LOG

    # Salva no arquivo
    #File.open("logs/errors.log", "a") { |f| f.puts(log_entry) }

    AppLogger.error("\n[HOOK] Erro registrado no arquivo logs/errors.log")
    AppLogger.error("#{log_entry}")

  end
end
