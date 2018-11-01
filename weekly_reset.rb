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

chores_board = user.boards.find { |board| board.name == "Chores" }
chores_board.lists.each do |list|
  if list.name =~ /Completed Stuff$/
    target_list_name = "#{list.name.split[0]} - Stuff"
    target_list = chores_board.lists.find { |l| l.name == target_list_name }
    list.cards.each do |card|
      puts "Moving card #{card.name} to #{target_list.name}"
      card.move_to_list(target_list)
      card.checklists.each do |checklist|
        checklist.items.each do |item|
          checklist.update_item_state(item.id, "incomplete") if item.complete?
        end
      end
    end
  end
end
