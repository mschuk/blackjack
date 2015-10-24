# Basic Blackjack game

puts 'Welcome to the Blackjack game!'
puts 'What is your name?'
PLAYER_NAME = gets.chomp

def create_deck
  values = %w(2 3 4 5 6 7 8 9 10 J K Q A)
  suites = %w(Spade Heart Diamond Club)
  deck = {}
  values.each do |value|
    suites.each do |suite|
      if %w(J K Q).include?(value)
        deck["#{value} #{suite}"] = 10
      elsif value == 'A'
        deck["#{value} #{suite}"] = 11
      else
        deck["#{value} #{suite}"] = value.to_i
      end
    end
  end
  deck
end


def deal_hand(deck)
  deck = create_deck if deck.empty?
  hand = {}
  first_card_key = deck.keys.sample
  hand[first_card_key] = deck[first_card_key]
  deck.delete(first_card_key)

  second_card_key = deck.keys.sample
  hand[second_card_key] = deck[second_card_key]
  deck.delete(second_card_key)
  hand
end

def print_hand(hand)
  display = ''
  hand.keys.each do |name|
    display << "'#{name}' "
  end
  display
end

def hit(deck, hand)
  new_card = deck.keys.sample
  hand[new_card] = deck[new_card]
  deck.delete(new_card)
  return deck, hand
end

def calculate_hand(hand)
  hand.values.inject(:+)
end

def adjust_ace_value(hand)
  # if hand includes an 11 and is over 22, change the value of 11 to 1
  hand.each do |suite, num|
      if num == 11 && calculate_hand(hand) > 22
        hand[suite] = 1
      end
    end
end

# deal hand to player and dealer
deck = create_deck
players_hand = deal_hand(deck)
player_value = calculate_hand(players_hand)
puts "#{PLAYER_NAME} your hand is: #{print_hand(players_hand)}"
puts ''
dealers_hand = deal_hand(deck)
dealer_value = calculate_hand(dealers_hand)
# only display one of the dealer's cards
puts "Dealer's first card is: '#{dealers_hand.keys[0]}'"
puts ''

if player_value == 21 && dealer_value == 21
  puts "It's a tie!"
  exit
end


# players turn
while player_value < 22
  puts "Your total is: #{calculate_hand(players_hand)}. Do you want to hit or stay? (enter h to hit, s to stay)"
  action = gets.chomp
  unless %w(h s).include?(action)
    puts 'You did not enter h or s'
    next
  end
  if action == 'h'
    hit(deck, players_hand)
    adjust_ace_value(players_hand)
    player_value = calculate_hand(players_hand)
    puts "#{PLAYER_NAME} your hand is now: #{print_hand(players_hand)}"
  else
    puts 'You chose to stay.'
    break
  end
  if player_value > 21
    puts "Your total is: #{calculate_hand(players_hand)}."
    puts "#{PLAYER_NAME} you busted."
    exit
  end
end

puts "Dealer's hand is #{print_hand(dealers_hand).strip} and total is: #{dealer_value}"
while dealer_value < 17
  puts 'Dealer hits'
  hit(deck, dealers_hand)
  # adjust ace values if needed
  adjust_ace_value(dealers_hand)
  dealer_value = calculate_hand(dealers_hand)
  puts "Dealer's hand is now #{print_hand(dealers_hand).strip} and total is: #{dealer_value}"
  if dealer_value > 21
    puts 'Dealer busted, you win!'
    exit
  end
end

if player_value == 21 && dealer_value == 21
  puts "It's a tie."
  exit
end

if player_value == 21
  puts "#{PLAYER_NAME} you win!"
  exit
end

if player_value > dealer_value
  puts "#{PLAYER_NAME} you win!"
else
  puts 'Dealer wins!'
end


