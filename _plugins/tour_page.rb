module Jekyll
  class TourPage < Page
    def initialize(site, name)
      @site = site
      @base = site.source
      @dir  = "/#{name.gsub('_', '-')}"
      @name = 'index.html'

      process(@name)
      self.data = load_data(name)
    end

    private

    def load_data(name)
      load_yaml("_tours/#{name}.yml").tap do |data|
        data['layout'] = 'tour'
        data['images'] = load_images(name)
      end
    end

    def load_yaml(path)
      YAML.load(File.read(File.join(@base, path)))
    end

    def load_images(name)
      Dir["images/#{name}/*.*"]
        .sort
    end
  end

  class TourGenerator < Generator
    safe true

    def generate(site)
      Dir['_tours/*.yml'].each do |path|
        name = File.basename(path, '.yml')
        write_tour_page(site, path, name)
      end
    end

    def write_tour_page(site, path, name)
      TourPage.new(site, name).tap do |tour|
        tour.render(site.layouts, site.site_payload)
        tour.write(site.dest)

        site.pages << tour
        site.static_files << tour
      end
    end
  end
end
