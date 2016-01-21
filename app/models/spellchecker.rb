require 'set'

class Spellchecker

  
  ALPHABET = 'abcdefghijklmnopqrstuvwxyz'

  #constructor.
  #text_file_name is the path to a local file with text to train the model (find actual words and their #frequency)
  #verbose is a flag to show traces of what's going on (useful for large files)
  def initialize(text_file_name)
    #read file text_file_name
    file = File.open(text_file_name, "r")
    #extract words from string (file contents) using method 'words' below.
    word_iteration = words file.read
    #put in dictionary with their frequency (calling train! method)
    train! word_iteration
  end

  def dictionary
    #getter for instance attribute
    @dictionary
  end
  
  #returns an array of words in the text.
  def words (text)
    return text.downcase.scan(/[a-z]+/) #find all matches of this simple regular expression
  end

  #train model (create dictionary)
  def train!(word_list)
    #create @dictionary, an attribute of type Hash mapping words to their count in the text {word => count}. Default count should be 0 (argument of Hash constructor).
    @dictionary = Hash.new(0)
    word_list.each do |word|
	@dictionary[word] += 1
    end
    @dictionary.keys.sort
  end

  #lookup frequency of a word, a simple lookup in the @dictionary Hash
  def lookup(word)
    @dictionary[word]
  end
  
  #generate all correction candidates at an edit distance of 1 from the input word.
  def edits1(word)
	
    #all strings obtained by deleting a letter (each letter)
    deletes    = []
    index = 0
    while index < word.length do
	deletes.push(word[0...index] + word[index+1..-1])
	index += 1
    end

    #all strings obtained by switching two consecutive letters
    transposes = []
    index = 0
    while index < word.length-1 do
	temp = word.split(/./)
	temp[index], temp[index+1] = temp[index+1], temp[index]
        transposes.push(temp.join(""))
	index += 1
    end

    # all strings obtained by inserting letters (all possible letters in all possible positions)
    inserts = []
    index = 0
    while index < word.length+1 do
	ALPHABET.scan(/./).each do |letter|
	    inserts.push(word[0...index] + letter + word[index..-1])
	end
	index += 1
    end

    #all strings obtained by replacing letters (all possible letters in all possible positions)
    replaces = []
    index = 0
    while index < word.length do
        ALPHABET.scan(/./).each do |letter|
            temp = word
            temp[index] = letter
	    replaces.push(temp)
	end
	index += 1
    end

    return (deletes + transposes + replaces + inserts).to_set.to_a #eliminate duplicates, then convert back to array
  end
  

  # find known (in dictionary) distance-2 edits of target word.
  def known_edits2 (word)
    # get every possible distance - 2 edit of the input word. Return those that are in the dictionary.
  end

  #return subset of the input words (argument is an array) that are known by this dictionary
  def known(words)
    return words.find_all {true } #find all words for which condition is true,
                                    #you need to figure out this condition
    
  end


  # if word is known, then
  # returns [word], 
  # else if there are valid distance-1 replacements, 
  # returns distance-1 replacements sorted by descending frequency in the model
  # else if there are valid distance-2 replacements,
  # returns distance-2 replacements sorted by descending frequency in the model
  # else returns nil
  def correct(word)
  end
    
  
end

