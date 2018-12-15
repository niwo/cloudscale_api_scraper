require "nokogiri"
require "open-uri"

module CloudscaleApiScraper
  class Scraper
    DEFAULT_URL = "https://www.cloudscale.ch/en/api/v1"
    API_GROUPS = %w(servers flavors images volumes floating-ips)

    def initialize(url: DEFAULT_URL)
      @url = url
    end

    def run
      doc = Nokogiri::HTML(open @url)
      api = {
        api_version: "v" + @url[/\/v(\d|.+)$/][2],
        groups: API_GROUPS.map{|group| { name: group, commands: [] } }
      }

      doc.css("ul.nav li a").each do |a|
        API_GROUPS.each do |group|
          if a.attribute("href").to_s[/#{group + "-"}/]
            command_id = a.attribute("href").to_s[1..-1]
            c_hash = { name: command_id[(group.size + 1)..-1] }

            c_hash[:summary] = doc.xpath("//h3[@id=\"#{command_id}\"]").text
            # description is found in the 2nd paragraph after the title
            c_hash[:description] = doc.xpath("//p[preceding::h3[@id=\"#{command_id}\"]]")[1].text
            c_hash[:method] = doc.xpath("//h3[@id=\"#{command_id}\"]/following-sibling::p/span")[0].content
            c_hash[:path] = doc.xpath("//h3[@id=\"#{command_id}\"]/following-sibling::p/span")[1].content

            c_hash[:values] = []
            # find the table which folows the h3 tag of the command
            if table = doc.at_xpath("//table/tbody[preceding::h3[@id=\"#{command_id}\"]]")
              table.xpath("tr").each do |line|
                if line.css("td").size == 3
                  c_hash[:values] << {
                    name: line.css("td")[0].text,
                    type: line.css("td")[1].text,
                    # strip html tags from description
                    description: line.css("td")[2].children.to_s.gsub(/<\/?[^>]*>/, "").chomp
                  }
                end
              end
            end
            api[:groups].detect {|g| g[:name] == group }[:commands] << c_hash
          end
        end
      end
      api
    end

  end
end
