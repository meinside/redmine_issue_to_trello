module RedmineTrello

  # Public: Formatter to turn an issue/project tuple into a textual representation
  # used in a Trello card.
  class CardFormatter
    include Rails.application.routes.url_helpers

    # project - A Project model instance
    # issue   - An Issue model instance
    def initialize(project, issue)
      @project = project
      @issue = issue
    end

    def title
      "##{@issue.id} #{@project.name} / #{@issue.subject}"
    end

    def description
      [:due_date, :url, :issue_description].reduce('') do |memo, obj|
        content = send(obj)
        memo += "#{content}\n" if !content.nil?
        memo
      end
    end

private

    def issue_description
      "\n#{@issue.description}"
    end

    def url
      "* URL: #{Setting['protocol']}://#{Setting['host_name']}#{issue_path(@issue)}"
    end

    def due_date
      "* Due date: #{@issue.due_date}" if !@issue.due_date.nil?
    end
  end
end
