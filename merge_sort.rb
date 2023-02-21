def merge_sort(arr)
  return arr if arr.length <= 1

  mid = arr.length / 2
  left = arr[0...mid]
  right = arr[mid..]

  left = merge_sort(left)
  right = merge_sort(right)

  merge(left, right)
end

def merge(left, right)
  result = []

  until left.empty? || right.empty?
    if left.first <= right.first
      result << left.shift
    else
      result << right.shift
    end
  end

  result.concat(left).concat(right)
end

arr = [4, 8, 6, 2, 1, 7, 5, 3]
puts merge_sort(arr)
