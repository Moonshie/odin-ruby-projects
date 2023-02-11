dictionary = ["below","down","go","going","horn","how","howdy","it","i","low",
    "own","part","partner","sit"]
def substrings(words, dictionary)
    hash = Hash.new
    array = words.downcase.split(' ')
    dictionary.each do |dic_word|
        array.each do |word|
            if word.include?(dic_word)
                if hash[dic_word] != nil
                    hash[dic_word] += 1
                else
                    hash[dic_word] = 1
                end
            end
        end
    end
    return hash
end

puts substrings("Howdy! How's it going, partner? Sit or go low.", dictionary)