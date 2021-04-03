#!/usr/bin/env ruby

class Numeric
  def norm
    self
  end
end

class Rational
  def norm
    denominator == 1 ? numerator : self
  end
end

class Point
  attr_accessor :x, :y
  def initialize(x,y)
    @x = x
    @y = y
  end

  def to_s
    "(#{x.norm},#{y.norm})"
  end
  alias inspect to_s
end

class Segment
  attr_accessor :y1, :y2, :x1, :x2
  def initialize(x1,y1,x2,y2)
    @x1 = x1
    @y1 = y1
    @x2 = x2
    @y2 = y2
  end

  class << self
    def from_points(a,b)
      new(a.x,a.y,b.x,b.y)
    end
  end

  def dy
    y2 - y1
  end
  alias rise dy

  def dx
    x2 - x1
  end
  alias run dx

  def slope 
    dy.to_r/dx.to_r # rise / run
  end
  alias a slope

  def y_intercept
    #   y = ax + b
    # -ax  -ax
    # b = y - ax
    y1 - a * x1
  end
  alias b y_intercept

  def line
    Line.new(a,b)
  end

  def to_s
    "(#{x1.norm},#{y1.norm}-#{x2.norm},#{y2.norm})"
  end
  alias inspect to_s
end

class Line
  attr_accessor :a, :b

  def initialize(a, b)
    @a = a
    @b = b
  end

  def to_s
    "y = #{a.norm}x + #{b.norm}"
  end
  alias inspect to_s

  def y(x) # y = ax + b
    a * x + b
  end

  def x(y) # x = (y - b) / a
    (y - b) / a
  end
  
  def y_offset(d)
    c = a * d
    Math.sqrt(d * d + c * c)
  end

  def border(d)
    dy = y_offset(d)
    [Line.new(a, b + dy), Line.new(a, b - dy)]
  end

  def intersect(o)
    # a1x + b1 = y = a2x + b2
    # a1x + b1 = a2x + b2
    x = (o.b - b) / (a - o.a)
    Point.new(x,y(x))
  end
end

$pts = [ [2, 2], [4, 3], [1, 6] ].map { |a| Point.new(*a) }

puts $pts.inspect

segment1 = Segment.from_points($pts[0], $pts[1])
segment2 = Segment.from_points($pts[1], $pts[2])

line1 = segment1.line
line2 = segment2.line

puts line1
puts line2
puts line1.intersect(line2)
line1.border(1).each do |border1|
  line2.border(1).each do |border2|
    puts border1.intersect(border2)
  end
end

puts (0..8).map{ |x| Point.new(x,line1.y(x)) }.inspect
