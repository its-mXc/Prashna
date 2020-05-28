class AnswerPresenter < ApplicationPresenter
  presents :answer

  # Methods delegated to Presented Class Answer object's answer
  @delegation_methods = [:body]

  delegate *@delegation_methods, to: :answer

  # Start the methods
  def markdown_body
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true).render(answer.body).html_safe
  end
end
