module E9Polls
  module GlobalHelper
    def poll_answered?(poll, answer = nil)
      if cookie = e9_polls_cookie
        cookie[poll.id] && !answer || cookie[poll.id].to_s == answer.id.to_s
      end
    end

    def poll_results_link(poll, options = {})
      text = I18n.t(:poll_results_link, :scope => :e9_polls)
      options.reverse_merge! :title => t(:poll_results_link_title, :scope => :e9_polls)
      link_to text, options.delete(:url) || results_poll_path(poll), options.merge(:class => 'view-poll-results')
    end

    def poll_form_link(poll, options = {})
      text = I18n.t(:poll_form_link, :scope => :e9_polls)
      options.reverse_merge! :title => t(:poll_show_link_title, :scope => :e9_polls)
      link_to text, options.delete(:url) || poll_path(poll), options.merge(:class => 'view-poll-form')
    end

    def e9_polls_cookie
      return if @_e9_polls_cookie == false
      @_e9_polls_cookie ||= Marshal.load(cookies[E9Polls.cookie_name]) rescue false
    end
  end
end
