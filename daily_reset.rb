require 'trello'

puts "Checking boards..."

public_key = ENV['TRELLO_DEVELOPER_PUBLIC_KEY']
member_token = ENV['TRELLO_MEMBER_TOKEN']
username = ENV['TRELLO_USERNAME']

Trello.configure do |config|
  config.developer_public_key = public_key
  config.member_token = member_token
end

user = Trello::Member.find(username)

user.boards.each do |board|
  next if board.closed?
  today_list = board.lists.find { |list| list.name == "Today"}
  next unless today_list
  puts "Found today list in #{board.name}"
  board.lists.each do |list|
    next if list.id == today_list.id
    list.cards.each do |card|
      next unless card.labels.any?{ |label| label.name == "Repeat Daily" }
      puts "Moving card #{card.name}"
      card.move_to_list(today_list)
    end
  end
end
