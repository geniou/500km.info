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

    def load_data(name)
      tour = Tour.new(tour_path(name))
      tour.data.merge('layout' => 'tour')
    end

    def tour_path(name)
      File.join(@base, "_tours/#{name}.yml")
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
