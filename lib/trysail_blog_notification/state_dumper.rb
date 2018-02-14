require 'json'

module TrySailBlogNotification
  class StateDumper

    # Dump file path.
    #
    # @return [String]
    attr_reader :file

    # States.
    #
    # @return [Hash]
    attr_reader :states

    # JSON states.
    #
    # @return [String]
    attr_reader :json_states

    # Initialize dumper.
    #
    # @param [String] file Dump file path.
    def initialize(file)
      @file = file
    end

    # Dump to file.
    #
    # @param [Hash] states Current states.
    def dump(states)
      @states = states
      @json_states = JSON.pretty_generate(@states)
      File.open(@file, 'w') do |f|
        f.write(@json_states)
      end
    end

  end
end