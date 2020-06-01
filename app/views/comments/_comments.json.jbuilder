json.comments comments do |comment|
  json.body comment.body
  json.reaction_count comment.reaction_count
  json.user comment.user, :name
  json.partial! 'comments/comments', comments: comment.comments
  json.created_at comment.created_at
end