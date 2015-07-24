require "synapse/service_watcher/base"
require "synapse/service_watcher/aws_ecs"
require "synapse/service_watcher/zookeeper"
require "synapse/service_watcher/ec2tag"
require "synapse/service_watcher/dns"
require "synapse/service_watcher/docker"
require "synapse/service_watcher/zookeeper_dns"

module Synapse
  class ServiceWatcher

    @watchers = {
      'base' => BaseWatcher,
      'aws_ecs' => AwsEcsWatcher,
      'zookeeper' => ZookeeperWatcher,
      'ec2tag' => EC2Watcher,
      'dns' => DnsWatcher,
      'docker' => DockerWatcher,
      'zookeeper_dns' => ZookeeperDnsWatcher,
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
