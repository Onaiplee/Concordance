#!/usr/bin/env ruby
#
# This program is the answer of BridgeWater coding assignment.
# The code based on below two assumptions below:
#
# 1) The text is well formed. The first word of each sentence begin with
#    a capital letter.
# 2) A sentence only ends with a full stop[.],  a question mark[?] or an 
#    exclamation mark[!].
# 3) The text does not contain Arabic numbers.
#
#
# There are three type of words may appear in text:
#
# 1) Cap_word means the first word in each sentence, which must start with
#    an upper case letter.
#
# 2) Reg_word means the type of words in the middle of each sentences, but
#    not the first one.
#
# 3) Abbr_word means the type of words in abbreviation form, (i.e., e.g., or
#    U.S.)
#
# So sentence can be formed by:
#         cap_word (white_space (reg_word|abbr_word))*[?!.] white_space

if ARGV.length == 1
  filename, = ARGV
else
  print "Too many arguments!\nUsage: ruby word_index.rb [FILE]\n"
  exit
end

word_pool = {}
f = File.open(filename, "r")
buffer = String.new
f.each {|line| buffer << line}
f.close

# add a space to garantee there is at lease one white space in the end.
buffer << " "

# reduce white spaces that appear consecutively more than once to one space.
buffer.gsub!(/\s+/, " ")

# this is the signs that do nothing about sentence 
# seperation. I use some for example. But they are 
# expected to be incrementally refined depends on the text. 
buffer.gsub!(/[:,;()]/, "")

# first word in a sentence (A, An, USA, English, U.S., ...)
cap_word = /(?:(?:[A-Z](?:[a-z]*|[A-Z]*))|(?:(?:[A-Z][.])(?:(?:[A-Z][.])+|(?:[a-z][.])+)))/

# regular word in a sentence (use, English or USA)
reg_word = /(?:[A-Z]+|[a-z]+|[A-Z][a-z]*)/

# abbreviation word in a sentence (i.e. or U.S., ...)
abbr_word = /(?:(?:[a-z][.])+|(?:[A-Z][.])+)/

# senctence pattern that clarified in the beginning
sentence = /(#{cap_word}(?:\s(?:#{reg_word}|#{abbr_word}))*[.?!]\s)/

sents = buffer.scan(sentence)
sents.flatten!
sents.each {|s| s.gsub!(/[.?!]\s$/, "") }
sents.each {|s| s.downcase! }
sents.each_with_index do |s, i|
  words = s.split(" ")
  words.each do |w|
    if word_pool[w] == nil
      word_pool[w] = [1,[i+1]]
    else
      freq, no = word_pool[w]
      freq += 1
      no << i+1
      word_pool[w] = [freq, no]
    end
  end
end 

dict = []
word_pool.each {|k,v| dict << k }
dict.sort!
letter_index = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
dict.each_with_index do |d, i|
  letter_repeat = i/26
  letter_ii = i%26
  (0..letter_repeat).each {print letter_index[letter_ii]}

  freq, no = word_pool[d]
  print ".\t" + d

  # The longest word in Shakespare's works is 27 letters long
  (27 - d.length).downto(0) {|i| print " "}

  print "\t{#{freq}:"
  ss = no.inject("") {|ss, n| ss << (n.to_s + ",")}
  print ss.chop! + "}\n"
end
