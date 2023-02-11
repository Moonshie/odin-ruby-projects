array = [4,3,78,2,0,2]

def bubble_sort(array)
    switch = true
    until switch == false
        switch = false
        array.each_with_index do 
            |val, index|
            if index == (array.length - 1)
                next
            elsif array[index] > array[index+1]
                array[index], array[index+1] = array[index+1], array[index]
                switch = true
            end
        end
    end
    return array
end

p "Unsorted: #{array}"
p "Sorted: #{bubble_sort(array)}"