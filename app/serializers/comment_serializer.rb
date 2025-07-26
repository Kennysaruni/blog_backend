class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body
  belongs_to :post
  belongs_to :user, serializer: UserSerializer
end
