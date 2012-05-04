#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

items = (1..30000)
users = (1 .. 3000)

users.each { |u|
  print u, ","
  print items.sort_by{rand}[0 ... (2 + rand(16))].join(",")
  print "\n"

}
