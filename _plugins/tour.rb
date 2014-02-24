class Tour
  def initialize(path)
    @path = path
  end

  def data
    yaml.tap do |data|
      data.merge!({
        'path' => tour_path,
        'images' => images,
        'intro_image' => intro_image
      })
    end
  end

  private

  def yaml
    YAML.load(File.read(@path))
  end

  def images
    Dir["images/#{file_name}/*.*"].sort
  end

  def tour_path
    "/#{file_name.gsub('_', '-')}"
  end

  def intro_image
    "/images/#{file_name}.jpg"
  end

  def file_name
    @file_name ||= File.basename(@path, '.yml')
  end
end
