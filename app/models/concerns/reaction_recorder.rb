module ReactionRecorder
  extend ActiveSupport::Concern

  def record_reaction(reaction_type, user)
    reaction = reactions.find_by(user: user)
    if reaction
      reaction.reaction_type = Reaction.reaction_types[reaction_type]
      reaction.save
    else
      reactions.create(user: user, reaction_type: Reaction.reaction_types[reaction_type])
    end
  end
end