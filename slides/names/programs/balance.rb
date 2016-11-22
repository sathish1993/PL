#!/usr/bin/env ruby

def new_account(balance)  #@1@
  #returns hash of functions
  { withdraw: 
      lambda { |amount| balance -= amount },
    deposit:
      lambda { |amount| balance += amount },
  }
end

#create 2 new acounts
a1, a2 = new_account(100), new_account(150)
print a1[:withdraw].call(24), "\n"
print a2[:deposit].call(20), "\n"
print a1[:withdraw].call(26), "\n"

