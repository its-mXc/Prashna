json.comments comments do |comment|
  json.body comment.body
  json.votes comment.reaction_count
  json.user comment.user, :name
  json.partial! 'api/comments/comments', comments: comment.comments
  json.created_at comment.created_at
end
