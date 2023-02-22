class LinkedList
  attr_accessor :name
  attr_reader :head, :tail

  def initialize(name)
    @name = name
    @head = nil
    @tail = nil
  end

  def append(value)
    if @head.nil?
      @head = Node.new(value)
      @tail = @head
      return
    end
    @tail = @tail.next = Node.new(value)
  end

  def prepend(value)
    if @head.nil?
      @head = Node.new(value)
      @tail = @head
      return
    end
    shifting_head = @head
    @head = Node.new(value)
    @head.next = shifting_head
    @tail = shifting_head if size == 2
  end

  def pop
    if size == 1
      @head = nil
      @tail = nil
      return
    end
    current = @head
    until current.next.next.nil?
      current = current.next
    end
    current.next = nil
    @tail = current
  end

  def find(value)
    current = @head
    count = 0
    until current.nil?
      if current.value == value
        return count
      end
      count += 1
      current = current.next
    end
    'Not found'
  end

  def form_array
    arr = []
    current = @head
    until current.nil?
      arr << current.value
      current = current.next
    end
    arr
  end

  def to_s
    form_array.join(' -> ')
  end

  def size
    current = @head
    count = 0
    until current.nil?
      count += 1
      current = current.next
    end
    count
  end

  def at(index)
    current = @head
    count = 0
    until current.nil?
      return current.value if index == count

      count += 1
      current = current.next
    end
  end

  def contains?(value)
    current = @head
    until current.nil?
      return true if current.value == value

      current = current.next
    end
    false
  end

  def head_value
    return nil if @head.nil?

    @head.value
  end

  def tail_value
    return nil if @tail.nil?

    @tail.value
  end
end

class Node
  attr_accessor :next, :value

  def initialize(value)
    @next = nil
    @value = value
  end
end

my_list = LinkedList.new('List')
my_list.prepend(2)
my_list.prepend(3)
my_list.prepend(8)
my_list.append(6)
my_list.append(10)
my_list.pop
my_list.append(24)
my_list.prepend(56)
my_list.append(56)
my_list.append(74)
my_list.pop
my_list.pop
my_list.pop
my_list.pop
my_list.pop
my_list.pop
my_list.pop
my_list.pop
my_list.append(5)
my_list.append(10)
my_list.prepend(15)
my_list.pop
my_list.pop
my_list.pop
my_list.prepend(5)
my_list.prepend('test')
my_list.prepend(11)
my_list.append(8)

p "A string: #{my_list.to_s}"
p "Size: #{my_list.size}"
p "Value at 0: #{my_list.at(0)}"
p "Value at 1: #{my_list.at(1)}"
p "Value at 2: #{my_list.at(2)}"
p "Value at 3: #{my_list.at(3)}"

p "Head: #{my_list.head}"
p "Head value: #{my_list.head_value}"
p "Tail: #{my_list.tail}"
p "Tail value: #{my_list.tail_value}"

p "Contains 8: #{my_list.contains?(8)}"
p "Contains 11: #{my_list.contains?(11)}"

p "Finding 8: #{my_list.find(8)}"
p "Finding 11: #{my_list.find(11)}"
p "Finding 20: #{my_list.find(20)}"