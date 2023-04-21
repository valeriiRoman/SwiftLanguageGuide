
// MARK: - 🔴 Big O notation 🔴

/* Big O notation is used to describe the performance of a function or algorithm that is applied to a set of data where the size of that set might not be known. This is done through a notation that looks as follows: O(1). */

// 🔴 O(1) or or "constant performance"

// O(1) algorithm you might be familiar with is getting an element from an array using a subscript:

let array = [1, 2, 3]
array[0] // this is done in O(1)

// This means that no matter how big your array is, reading a value at a certain position will always have the same performance implications.

// 🔴 O(n) or "linear performance" where "n" is the size of the data collection.

// This notation communicates linear growth. The algorithm's execution time or performance grow linearly with the size of the data set.

// A lot of Swift's built-in functional operators have similar performance and have O(n) complexity: map, filter, compactMap, and even first(where:). All these have to loop over all items in your collection, so the time needed, complexity grow along and proportionally to the size of the collection.

// Even a first(where:) is considered as a O(n), as Big O notation is most commonly used to depict a "worst case" or "most common" scenario. In the case of first(where:) it makes sense to assume the worst-case scenario. first(where:) is not guaranteed to find a match, and if it does, it's equally likely that the match is at the beginning or end of the data set.

// 🔴 O(n^2) or "quadratic performance"

// Example:

let integers = (0..<5)
let squareCoords = integers.flatMap { i in
    return integers.map { j in
        return (i, j)
    }
}
 
print(squareCoords)

// Generating the squareCoords requires me to loop over integers using flatMap. In that flatMap, I loop over squareCoords again using a map. This means that the line return (i, j) is invoked 25 times which is equal to 5^2. Or in other words, n^2. For every element we add to the array, the time it takes to generate squareCoords grows exponentially. Creating coordinates for a 6x6 square would take 36 loops, 7x7 would take 49 loops, 8x8 takes 64 loops and so forth.

// 🔴 O(log n) or "logarithmic performance"

// An algorithm with O(log n) complexity will often perform worse than some other algorithms for a smaller data set. However, as the data set grows and n approaches an infinite number, the algorithm's performance will degrade less and less. An example of this is a binary search:

extension RandomAccessCollection where Element: Comparable, Index == Int {
    func binarySearch(for item: Element) -> Index? {
        guard self.count > 1 else {
            if let first = self.first, first == item {
                return self.startIndex
            }  else {
                return nil
            }
        }

        let middleIndex = (startIndex + endIndex) / 2
        let middleItem = self[middleIndex]

        if middleItem < item {
            return self[index(after: middleIndex)...].binarySearch(for: item)
        } else if middleItem > item {
            return self[..<middleIndex].binarySearch(for: item)
        } else {
            return middleIndex
        }
    }
}

let words = ["Hello", "world", "how", "are", "you"].sorted()
print(words.binarySearch(for: "world"))

// This implementation of a binary search assumes that the input is sorted in ascending order. In order to find the requested element, it finds the middle index of the data set and compares it to the requested element. If the requested element is expected to exist before the current middle element, the array is cut in half and the first half is used to perform the same task until the requested element is found. If the requested element should come after the middle element, the second half of the array is used to perform the same task.
/* A search algorithm is very efficient because the number of lookups grows much slower than the size of the data set. Consider the following:

    For 1 item, we need at most 1 lookup
    For 2 items, we need at most 2 lookups
    For 10 items, we need at most 3 lookups
    For 50 items, we need at most 6 lookups
    For 100 items, we need at most 7 lookups
    For 1000 items, we need at most 10 lookups */

