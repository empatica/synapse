require "synapse/service_watcher/base"
require "synapse/service_watcher/aws_ecs"

module Synapse
  class ServiceWatcher

    @watchers = {
      'base' => BaseWatcher,
      'aws_ecs' => AwsEcsWatcher,
    }

    # the method which actually dispatches watcher creation requests
    def self.create(name, opts, synapse)
      opts['name'] = name

      raise ArgumentError, "Missing discovery method when trying to create watcher" \
        unless opts.has_key?('discovery') && opts['discovery'].has_key?('method')

      discovery_method = opts['discovery']['method']
      raise ArgumentError, "Invalid discovery method #{discovery_method}" \
        unless @watchers.has_key?(discovery_method)

      return @watchers[discovery_method].new(opts, synapse)
    end
  end
end
