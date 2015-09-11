module Synapse
  module Logging

    def log
      @logger ||= Logging.logger_for(self.class.name)
    end

    # Use a hash class-ivar to cache a unique Logger per class:
    @loggers = {}

    class << self
      def logger_for(classname)
        @loggers[classname] ||= configure_logger_for(classname)
      end

      def configure_logger_for(classname)
        logger = Logger.new(STDERR)

        if ENV['DEBUG']
          logger.level = Logger::DEBUG
        else
          logger.level = Logger::INFO
        end

        logger.progname = classname
        return logger
      end
    end
  end
end
