module TrySailBlogNotification
  class DataLoader

    # JSON file path.
    #
    # @return [String]
    attr_reader :file

    # JSON string.
    #
    # @return [String]
    attr_reader :json

    # Raw statuses
    #
    # @return [Hash]
    attr_reader :raw_states

    # Statuses
    #
    # @return [Hash]
    attr_reader :states

    # Initialize DataLoader.
    #
    # @param [String] file JSON file path.
    def initialize(file)
      @file = file
      load_states
    end

    # To json
    #
    # @return [String]
    def to_json
      @json
    end

    # To hash
    #
    # @return [Hash]
    def to_h
      @raw_states
    end

    private

    # Load data
    def load_states
      @json = File.open(@file, 'r') do |f|
        f.read
      end
      @raw_states = JSON.parse(@json)
      @states = {}

      @raw_states.each do |name, status|
        @states[name] = TrySailBlogNotification::LastArticle.new(status['title'], status['url'], status['last_update'])
      end
    end

  end
end