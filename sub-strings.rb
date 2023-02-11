dictionary = ["below","down","go","going","horn","how","howdy","it","i","low",
    "own","part","partner","sit"]
def substrings(word, dictionary)
    hash = Hash.new
    dictionary.each do |dic_word|
        if word.include?(dic_word)
            hash[dic_word] = 1
        end
    end
    return hash
end

puts substrings("below", dictionary)