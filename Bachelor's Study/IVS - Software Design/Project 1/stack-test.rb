# Projekt č. 1
# Jméno: Petr Dvořáček
# E-mail: xdvora0n@stud.fit.vutbr.cz
# 
require 'test/unit'
require 'stack'

class StackTest < Test::Unit::TestCase
  # spousti se pred kazdym testem, tj. novy zasobnik vznika pro kazdy test
  def setup
    @stack = Stack.new
  end
  
  # enqueue se netestuje zvlast, protoze je nutnou prerekvizitou
  # pro funkcnost ostatnich testu
  
  def test_topOnEmptyStack
    assert_nil(@stack.top)
  end
  
  def test_topOnNonEmptyStack
    @stack.push( 42 )
    assert_not_nil(@stack.top)
  end
  
  def test_popOnEmptyStack
    assert_nil(@stack.pop)
  end
  
  def test_popOnNonEmptyStack
    @stack.push( 42 )
    assert_not_nil(@stack.pop)
  end
  
  def test_isEmptyOnEmptyStack
    assert(@stack.empty?)
  end
  
  def test_isEmptyOnNonEmptyStack
    @stack.push ( 42 )
    assert(! @stack.empty?)
  end
  
  # vlozeni a vybrani alespon dvou elementu a test na poradi
  def test_orderOfElements
    @stack.push( 42 )
    assert_equal(@stack.top, 42)
    @stack.push( 84 )
    assert_equal(@stack.top, 84)
    @stack.pop
    assert_equal(@stack.top, 42)
    @stack.pop
    assert_nil(@stack.top)
  end
end
