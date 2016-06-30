class MoveToPublicComments < ActiveRecord::Migration
  def change
    Comment.update_all(role: 'public_comments')
  end
end
