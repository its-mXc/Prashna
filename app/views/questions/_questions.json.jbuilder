json.questions @questions do |question|
  json.title question.title
  json.content question.content
  json.reaction_count question.reaction_count
  json.published_at question.published_at
  json.partial! 'comments/comments', comments: question.comments
  # json.comments question.comments do |comment|
  #   json.body comment.body
  #   json.reaction_count comment.reaction_count
  #   json.user comment.user, :name
  #   json.comments comment.comments do |comment|
  #     json.body comment.body
  #     json.user comment.user, :name
  #     json.reaction_count comment.reaction_count
  #     json.created_at comment.created_at
  #   end
  #   json.created_at comment.created_at
  # end
  json.answers question.answers do |answer|
    json.body answer.body
    json.user answer.user, :name
    json.reaction_count answer.reaction_count
    json.created_at answer.created_at
  end
  json.topics question.topics, :name
end 