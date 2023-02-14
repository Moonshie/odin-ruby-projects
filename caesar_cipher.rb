def get_shift_amount
    num_string = gets.chomp
    num = num_string.to_i
    if num.is_a? Integer
        if num < 1 || num > 25
            puts "Incorrect input. Please try again."
            return 0
        else
            puts "You have chosen shift of #{num}."
            return num
        end
    else
        puts "Incorrect input. Please try again."
        return 0
    end
end

def get_shift_direction
    direction_string = gets.chomp
    direction = direction_string.downcase
    case direction when 'left', 'right'
        puts "You have chosen #{direction}."
        return direction
    end
    puts "Incorrect input. Please try again."
    return ''
end

def split_text(text, shift, direction)
    temp_array = text.split('')
    shift = shift
    if direction == 'left'
        temp_array.map! {|char| char = shift_left(char, shift)}
    else
        temp_array.map! {|char| char = shift_right(char, shift)}
    end
    return temp_array.join
end

def shift_left(char, shift)
    ascii = char.ord
    if ascii.between?(65,90)
        ascii -= shift
        if ascii < 65
            ascii +=26
        end
    elsif ascii.between?(97,122)
        ascii -= shift
        if ascii < 97
        ascii +=26
        end
    end
    return ascii.chr
end

def shift_right(char, shift)
    ascii = char.ord
    if ascii.between?(65,90)
        ascii += shift
        if ascii > 90
            ascii -=26
        end
    elsif ascii.between?(97,122)
        ascii += shift
        if ascii > 122
        ascii -=26
        end
    end
    return ascii.chr
end


puts "Welcome to Caesar Cipher. Please enter your text bellow:"
text = gets.chomp
puts "Now enter shift amount:"
shift = 0
while shift == 0 do
    shift = get_shift_amount
end
puts "Now choose shift direction (left or right):"
direction = ''
while direction == '' do
    direction = get_shift_direction
end
puts "Here is you ciphered text:"
puts split_text(text, shift, direction)