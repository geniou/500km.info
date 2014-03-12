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
        Tour.new(path).data
      end
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
