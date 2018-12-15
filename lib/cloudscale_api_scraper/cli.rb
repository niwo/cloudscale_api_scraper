require "thor"
require "yaml"

module CloudscaleApiScraper
  class CLI < Thor
    include Thor::Actions

    package_name "cloudstats"

    # exit with return code 1 in case of a error
    def self.exit_on_failure?
      true
    end

    desc "version", "Print version number"
    def version
      say "CloudscaleApiScraper v#{CloudscaleApiScraper::VERSION}"
    end
    map %w(-v --version) => :version

    desc "scrape", "Pull API definitions from the CloudScale docs"
    option :api_url,
      default: CloudscaleApiScraper::Scraper::DEFAULT_URL,
      aliases: '-A',
      desc: 'CloudScale API docs URL'
    def scrape
      puts CloudscaleApiScraper::Scraper.new(
        url: options[:api_url]
      ).run.to_yaml
    rescue => e
      say "ERROR: ", :red
      puts e.message
    end
  end
end
