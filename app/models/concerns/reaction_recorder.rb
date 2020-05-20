module ReactionRecorder
  extend ActiveSupport::Concern

  def record_reaction(reaction_type, user)
    reaction = reactions.find_by(user: user)
    if reaction
      p "hello"
      reaction.reaction_type = Reaction.reaction_types[reaction_type]
      reaction.save
      p reaction.errors
    else
      p "bye"
      a = reactions.create(user: user, reaction_type: Reaction.reaction_types[reaction_type])
      p a.errors
    end
  end
end