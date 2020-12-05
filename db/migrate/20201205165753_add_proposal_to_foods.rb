class AddProposalToFoods < ActiveRecord::Migration[6.0]
  def change
    add_reference :foods, :proposal, null: true, foreign_key: true, type: :uuid
  end
end
