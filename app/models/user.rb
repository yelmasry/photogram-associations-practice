# == Schema Information
#
# Table name: users
#
#  id             :integer          not null, primary key
#  comments_count :integer
#  likes_count    :integer
#  private        :boolean
#  username       :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class User < ApplicationRecord
  validates(:username, {
    :presence => true,
    :uniqueness => { :case_sensitive => false },
  })

  has_many(:comments, class_name: "Comment", foreign_key: "author_id")
  has_many(:own_photos, class_name: "Photo", foreign_key: "owner_id")
  has_many(:likes, class_name: "Like", foreign_key: "fan_id")
  has_many(:sent_follow_requests, class_name: "FollowRequest", foreign_key: "sender_id")
  has_many(:received_follow_requests, class_name: "FollowRequest", foreign_key: "recipient_id")
  has_many(:accepted_sent_follow_requests, -> { where status: "accepted" }, class_name: "FollowRequest", foreign_key: :sender_id)
  has_many(:accepted_received_follow_requests, -> { where status: "accepted" }, class_name: "FollowRequest", foreign_key: :recipient_id)
  has_many(:liked_photos, through: :likes, source: :photo)
  has_many(:commented_photos, through: :comments, source: :photo)
  has_many(:followers, through: :accepted_received_follow_requests, source: :sender)
  has_many(:leaders, through: :accepted_sent_follow_requests, source: :recipient)
  has_many(:feed, through: :leaders, source: :own_photos)
  has_many(:discover, through: :leaders, source: :liked_photos)

  # Association accessor methods to define:
  
  ## Direct associations

  # User#comments: returns rows from the comments table associated to this user by the author_id column

  # User#own_photos: returns rows from the photos table  associated to this user by the owner_id column

  # User#likes: returns rows from the likes table associated to this user by the fan_id column

  # User#sent_follow_requests: returns rows from the follow requests table associated to this user by the sender_id column

  # User#received_follow_requests: returns rows from the follow requests table associated to this user by the recipient_id column


  ### Scoped direct associations

  # User#accepted_sent_follow_requests: returns rows from the follow requests table associated to this user by the sender_id column, where status is 'accepted'

  # User#accepted_received_follow_requests: returns rows from the follow requests table associated to this user by the recipient_id column, where status is 'accepted'


  ## Indirect associations

  # User#liked_photos: returns rows from the photos table associated to this user through its likes

  # User#commented_photos: returns rows from the photos table associated to this user through its comments


  ### Indirect associations built on scoped associations

  # User#followers: returns rows from the users table associated to this user through its accepted_received_follow_requests (the follow requests' senders)

  # User#leaders: returns rows from the users table associated to this user through its accepted_sent_follow_requests (the follow requests' recipients)

  # User#feed: returns rows from the photos table associated to this user through its leaders (the leaders' own_photos)

  # User#discover: returns rows from the photos table associated to this user through its leaders (the leaders' liked_photos)
end
