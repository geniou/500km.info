module Jekyll
  class TourOverviewPage < Page
    def initialize(site)
      @site = site
      @base = site.source
      @dir  = '/'
      @name = 'index.html'

      process(@name)
      self.data = page_data
    end

    private

    def page_data
      {
        'layout' => 'tour_overview',
        'title' => 'Radtour-Chronik',
        'tours'  => tours
      }
    end

    def tours
      load_tours
        .sort { |a, b| a['year'] <=> b['year'] }
        .reverse
    end

    def load_tours
      Dir['_tours/*.yml'].map do |path|
        tour_data(path)
      end
    end

    def tour_data(file_path)
      YAML.load(File.read(file_path)).tap do |tour|
        file_name = File.basename(file_path, '.yml')
        tour['path'] = tour_path(file_name)
        tour['into_image'] = intro_image(file_name)
      end
    end

    def tour_path(file_name)
      "/#{file_name.gsub('_', '-')}"
    end

    def intro_image(file_name)
      "/images/#{file_name}.jpg"
    end
  end

  class TourOverviewGenerator < Generator
    safe true

    def generate(site)
      TourOverviewPage.new(site).tap do |page|
        page.render(site.layouts, site.site_payload)
        page.write(site.dest)

        site.pages << page
        site.static_files << page
      end
    end
  end
end
