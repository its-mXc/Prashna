class QuestionPresenter < ApplicationPresenter
  presents :question

  # Methods delegated to Presented Class Question object's question
  @delegation_methods = [:content]

  delegate *@delegation_methods, to: :question

  # Start the methods
  def markdown_content
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true).render(content).html_safe
  end
end
