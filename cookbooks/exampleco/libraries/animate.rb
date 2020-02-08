require 'base64'
require 'restclient'
require 'json'

#===============================================
#Start of function to fetch uuid of environment 
#Author: Jsky
#Date: 05-Feb-2020
#===============================================
def circleClock
spinner = Enumerator.new do |e|
  loop do
    e.yield '🕐'
    e.yield '🕑'
    e.yield '🕒'
    e.yield '🕓'
    e.yield '🕔'
    e.yield '🕕'
    e.yield '🕖'
    e.yield '🕗'
    e.yield '🕘'
    e.yield '🕙'
    e.yield '🕚'
    e.yield '🕛'
  end
end
spinner
end
def circleClockWise
spinner = Enumerator.new do |e|
  loop do
    e.yield '◒ ◑'
    e.yield '◐ ◓'
    e.yield '◓ ◐'
    e.yield '◑ ◒'
  end
end
spinner
end
def circleAntiClockWise
spinner = Enumerator.new do |e|
  loop do
    e.yield '◑ '
    e.yield '◓ '
    e.yield '◐ '
    e.yield '◒ '
  end
end
spinner
end

def lineStraight
spinner = Enumerator.new do |e|
  loop do
    e.yield '▏'
    e.yield '▎'
    e.yield '▍'
    e.yield '▌'
    e.yield '▋'
    e.yield '▊'
    e.yield '▉'
    e.yield '█'
    e.yield '▉'
    e.yield '▊'
    e.yield '▋'
    e.yield '▌'
    e.yield '▍'
    e.yield '▎'
    e.yield '▏'
  end
end
spinner
end

def lineReverse()
spinner = Enumerator.new do |e|
  loop do
    e.yield '█'
    e.yield '▉'
    e.yield '▊'
    e.yield '▋'
    e.yield '▌'
    e.yield '▍'
    e.yield '▎'
    e.yield '▏'
    e.yield '▏'
    e.yield '▎'
    e.yield '▍'
    e.yield '▌'
    e.yield '▋'
    e.yield '▊'
    e.yield '▉'
    e.yield '█'
  end
end
spinner
end

def spinnerRotateNoWheel
  spinner = Enumerator.new do |e|
    loop do
      e.yield '+'
      e.yield 'x'
      e.yield '+'
      e.yield 'x'
    end
  end
  spinner
end
