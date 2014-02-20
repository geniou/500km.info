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
        'title' => '500km',
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
        tour['path'] = tour_path(file_path)
      end
    end

    def tour_path(file_path)
      File.basename(file_path, '.yml').gsub('_', '-')
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
