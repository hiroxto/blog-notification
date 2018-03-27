# frozen_string_literal: true

module TrySailBlogNotification::Command
  class StartCommand < BaseCommand

    # Initialize StartCommand
    #
    # @param [Hash] options
    # @param [Array] args
    def initialize(options, args)
      super(options, args)

      @config = app.config
      @dump_file = app.dump_file
      @clients = app.clients
      @urls = app.urls
    end

    # Start command.
    def start
      logger.debug("Call \"#{__method__}\" method.")

      current_states = {}

      @urls.each do |name, info|
        url = info['url']
        parser_class = info['parser']

        logger.debug("Run \"#{name}\" : \"#{url}.\"")

        logger.debug('Get response.')

        http = http_request(url)
        http.request

        logger.debug(http.response)
        raise "Response http code : '#{http.response.code}'." unless http.response.code == '200'

        html = http.html
        nokogiri = Nokogiri::HTML.parse(html)
        last_article = get_last_article(nokogiri, parser_class)

        logger.debug(last_article)

        current_states[name] =last_article
      end

      logger.debug('current_states')
      logger.debug(current_states)

      check_diff(current_states)

      dump_to_file(current_states)
    rescue RuntimeError => e
      logger.error(e)
    end

    private

    # Send http request.
    #
    # @param [String] url
    # @return [String]
    def http_request(url)
      TrySailBlogNotification::HTTP.new(url)
    end

    # Get last article.
    #
    # @param [Nokogiri::HTML::Document] nokogiri
    # @param [TrySailBlogNotification::Parser::BaseParser] klass
    # @return [TrySailBlogNotification::LastArticle]
    def get_last_article(nokogiri, klass)
      logger.debug('Get last articles.')

      parser = klass.new
      parser.parse(nokogiri)
    end

    # Check updates.
    #
    # @param [Hash] current_states
    def check_diff(current_states)
      logger.debug('Check diff.')

      unless File.exists?(@dump_file)
        logger.debug("File \"#{@dump_file}\" is not exits.")
        logger.debug('Skip check.')
        return
      end

      old_states = get_old_states

      old_states.each do |name, old_state|
        logger.debug("Check diff of \"#{name}\".")

        if current_states[name].nil?
          logger.info("current_states[#{name}] is nil. Skip check diff.")
          next
        end

        new_state = current_states[name]
        if new_state.title != old_state.title || new_state.url != old_state.url
          if options['no-notification']
            logger.info('Option "--no-notification" is enabled. No send the notification.')
          else
            logger.debug("Call \"run_notification\".")
            run_notification(name, new_state)
          end
        end
      end
    end

    # Get old state.
    #
    # @return [Hash]
    def get_old_states
      logger.debug("Open dump file : \"#{@dump_file}\".")
      loader = TrySailBlogNotification::StateLoader.new(@dump_file)
      loader.states
    end

    # Check updates.
    #
    # @param [String] name
    # @param [TrySailBlogNotification::LastArticle] state
    def run_notification(name, state)
      logger.debug("Run notification of \"#{name}\".")

      @clients.each do |client|
        begin
          logger.debug("Call \"update\" method of \"#{client.class}\".")
          client.before_update(name, state)
          client.update(name, state)
        rescue Exception => e
          logger.error("Raised exception in #{client.class}#.update")
          logger.error(e)
        end
      end
    end

    # Write to dump file.
    #
    # @param [Hash] states
    def dump_to_file(states)
      hashed_states = {}
      states.each do |name, last_article|
        hashed_states[name] = last_article.to_h
      end

      logger.debug('Write to dump file.')
      dumper = TrySailBlogNotification::StateDumper.new(@dump_file)

      logger.debug('Run write.')
      dumper.dump(hashed_states)
    end

  end
end