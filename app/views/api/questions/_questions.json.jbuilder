#FIXME_AB: api related templates should be inside api namespace
json.questions @questions do |question|
  json.title question.title
  json.content question.content
  json.votes question.reaction_count
  json.published_at question.published_at
  json.partial! 'api/comments/comments', comments: question.comments
  json.answers question.answers do |answer|
    json.body answer.body
    json.user answer.user, :name
    json.reaction_count answer.reaction_count
    json.created_at answer.created_at
  end
  json.topics question.topics, :name
end
