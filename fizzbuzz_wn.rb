#!/usr/bin/env ruby
=begin
1から20までの数をプリントするプログラムを書け。
ただし3の倍数のときは数の代わりに｢Fizz｣と、5の倍数のときは｢Buzz｣とプリントし、
3と5両方の倍数の場合には｢FizzBuzz｣とプリントすること。
=end

puts "#if-elsifでやってみた"
num_set = 1..20
for i in num_set
  if i%3 == 0 && i%5 == 0
    outputs = "FizzBuzz"
  elsif i%3 == 0
    outputs = "Fizz"
  elsif i%5 == 0
    outputs = "Buzz"
  else
    outputs = i  
  end  
  puts outputs
end


puts "#casewhenでやってみた"
num_set = 1..20
for i in num_set
  case 
  when i%3 == 0 && i%5 == 0
    puts "FizzBuzz"
  when i%3 == 0
    puts "Fizz"
  when i%5 == 0
    puts "Buzz"
  else
    puts i
  end
end

puts "#whileでやってみた"
num_rc = 0
while num_rc < 20
  num_rc += 1
  case 
  when num_rc%3 == 0 && num_rc%5 == 0
    puts "FizzBuzz"
  when num_rc%3 == 0
    puts "Fizz"
  when num_rc%5 == 0
    puts "Buzz"
  else
    puts num_rc
  end
end
