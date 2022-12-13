import Foundation

// MARK: - 🟡 Arrays 🟡

/* An array stores values of the same type in an ordered list. The same value can appear in an array multiple times at different positions. */

// 🟡 Creating an Array with a Default Value
/* Initializing an array of a certain size with all of its values set to the same default value. */

var tenZeros = Array(repeating: 0, count: 10)
// repeating: - default value of the appropriate type
// count: - number of times the value is repeated in the array

// 🟡 Adding items
tenZeros.append(1)
// OR
tenZeros += [1]

// 🟡 Change an existing value

// use subscript syntax
tenZeros[0] = 2
// OR
tenZeros.insert(3, at: 0)
// The new element is inserted before the element currently at the specified index.

// 🟡 Replacing ranges of items
/* You can also use subscript syntax to change a range of values at once, even if the replacement set of values has a different length than the range you are replacing. */

tenZeros[4...6] = [4, 5]

// 🟡 Removing items
tenZeros.remove(at: 0)
// OR
tenZeros.removeLast()
// OR
tenZeros.removeFirst()
// OR
let removedElement = tenZeros.remove(at: 0)
// you can assign remove(at:) to a property, then the method will return the removed value

// OR
tenZeros.removeAll()

// 🟡 Iteration

let enumeratedSequence = ["🐮", "🐔", "🐑", "🐶", "🐱"].enumerated()
// .enumerated() returns EnumeratedSequence<Self>, with a sequence of pairs (n, x), where n represents a consecutive integer starting at zero and x represents an element of the sequence.

for (index, value) in enumeratedSequence {
    print("Item \(index): \(value)")
}

// MARK: - ⚪️ Hashable ⚪️

// ⚪️ Hash value
/* A key in Dictionarry od an element of a Set must be hashable - the type must provide a way to compute a hash value for itself. A hash value is an Int value that’s the same for all objects that compare equally, such that if a == b, the hash value of a is equal to the hash value of b.
 */

// ⚪️ Hashable Protocol

/*
 All of Swift’s basic types (such as String, Int, Double, and Bool) and even sets are hashable by default. Some other types, such as optionals, arrays and ranges automatically become hashable when their type arguments implement the same. To conform to Hashable you have to implement hash(into:) method. For structs whose stored properties are all Hashable, and for enum types that have all-Hashable associated values, the compiler is able to provide an implementation of hash(into:) automatically.
 */

// ⚪️ hash(into:) method

/*
 Two instances that are equal must feed the same values to Hasher in hash(into:), in the same order.
 You can conform your custom type to Hashable if:
 * For a struct, all its stored properties must conform to Hashable.
 * For an enum, all its associated values must conform to Hashable. (An enum without associated values has Hashable conformance even without the declaration.)
 Hashable inherits from Equatable, so You have to implement it`s == (lhs:, rhs:) as well.
 */

// ⚪️ Example:

struct CustomType {
    var name: String
    var number: Int
}

extension CustomType: Hashable {
    static func == (lhs: CustomType, rhs: CustomType) -> Bool {
        return lhs.name == rhs.name && lhs.number == rhs.number
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(number)
    }

    // the hash(into:) feeds the CustomType point’s name and number properties into the provided hasher. These properties are the same ones used to test for equality in the == operator function.
}


// MARK: - 🔵 Sets 🔵

/* A set stores distinct values of the same type in a collection with no defined ordering. */

var emojiesSet: Set = ["🌼", "☃️", "🌎", "🌹", "🌓", "🔥", "🪐", "🍋", "💧"]

// 🔵 Modifying a Set

emojiesSet.remove("☃️")
emojiesSet.insert("☃️")

// OR
// Assign to a property - value will be Optional (if operation is successful - returns removed/inserted element, if not - returns nil
if let removedEmoji = emojiesSet.remove("☃️") {
    print("Element removed from a set: \(removedEmoji)")  // goes here
} else {
    print("element not found")
}

if let nilString = emojiesSet.remove("this value is not in a set") {
    print("Element removed from a set: \(nilString)")
} else {
    print("element not found")  // goes here
}

print(emojiesSet)

// 🔵 Iteration

/* Swift’s Set type doesn’t have a defined ordering. To iterate over the values of a set in a specific order, use the sorted(). */

for emoji in emojiesSet.sorted() {
    print("\(emoji)")
}

// 🔵 Fundamental Set Operations

// intersection(_:) - create a new set with only the values common to both sets.
// symmetricDifference(_:) - create a new set with values in either set, but not both.
// union(_:) - create a new set with all of the values in both sets.
// subtracting(_:) - create a new set with values not in the specified set.

let oddDigits: Set = [1, 3, 5, 7, 9]
let evenDigits: Set = [0, 2, 4, 6, 8]
let singleDigitPrimeNumbers: Set = [2, 3, 5, 7]

oddDigits.union(evenDigits).sorted()
// [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
oddDigits.intersection(evenDigits).sorted()
// []
oddDigits.subtracting(singleDigitPrimeNumbers).sorted()
// [1, 9]
oddDigits.symmetricDifference(singleDigitPrimeNumbers).sorted()
// [1, 2, 9]

// 🔵 Membership and Equality

// isSubset(of:) - determine whether all of the values of a set are contained in the specified set.
// isSuperset(of:) - determine whether a set contains all of the values in a specified set.
// isStrictSubset(of:) or isStrictSuperset(of:) - determine whether a set is a subset or superset, but not equal to, a specified set.
// isDisjoint(with:) - determine whether two sets have no values in common.

let houseAnimals: Set = ["🐶", "🐱"]
let farmAnimals: Set = ["🐮", "🐔", "🐑", "🐶", "🐱"]
let cityAnimals: Set = ["🐦", "🐭"]

houseAnimals.isSubset(of: farmAnimals)
// true
farmAnimals.isSuperset(of: houseAnimals)
// true
farmAnimals.isDisjoint(with: cityAnimals)
// true

// MARK: - 🟣 Dictionaries 🟣

/* A dictionary stores associations between keys of the same type and values of the same type in a collection with no defined ordering. Each value is associated with a unique key. */

var weatherEmojiesDict = ["sun": "☀️", "snow": "❄️", "rain": "🌧", "wind": "💨"]

// 🟣 Modifying Dictionary

weatherEmojiesDict["rainbow"] = "🌈"
// add new key (or an existing one) as the subscript index, and assign a new value

// OR

weatherEmojiesDict.updateValue("🌬", forKey: "wind")
// modifies an existing key/value or creates a new value

// updateValue(_:forKey:) method can return the old value after performing an update
if let oldValue = weatherEmojiesDict.updateValue("🌤", forKey: "sun") {
    print("The old value is: \(oldValue)") // goes here
}

// This optional value contains the old value for that key if one existed before the update, or nil if no value existed

if let oldValue = weatherEmojiesDict.updateValue("⚡️", forKey: "lightning") {
    print("The old value is: \(oldValue)")
} else {
    print("The value has not existed in a dictionary before") // goes here
}

// Even if it returns nil above ☝️, it will still add a key/value pair to a dict
print("Does the dict contain that value now? - \(weatherEmojiesDict.contains { $0.key == "lightning" })")

// removing:

if let removedValue = weatherEmojiesDict.removeValue(forKey: "lightning") {
    print("The removed value is: \(removedValue)") // goes here
} else {
    print("The value has not existed in a dictionary before")
}

// OR

weatherEmojiesDict["sun"] = nil

// 🟣 Iteration

// while iteration you get tuple with key and value
for (name, emoji) in weatherEmojiesDict {
    print("\(name): \(emoji)")
}

// OR

for emoji in weatherEmojiesDict.values {
    print("value: \(emoji)")
}

// to create an array with keys or values:
let weatherKeys = [String](weatherEmojiesDict.keys)

// MARK: - 🟤 Foundation collection types 🟤

// 🟤 NSArray

/* NSArray is immutable by default. If you want to add, remove or modify items after creating the array, you must use the mutable variant class NSMutableArray. */

 /* An NSArray is heterogeneous, meaning it can contain Cocoa objects of different types. Swift arrays are homogeneous, meaning that each Array is guaranteed to contain only one type of object. */

 /* However, you can still define a single Swift Array so it stores various types of Cocoa objects by specifying that the one type is AnyObject, since every Cocoa type is also a subtype of this. */


// 🟤 NSDictionary

/* Unlike Swift Dictionary, NSDictionary objects are able to take any NSObject as a key and store any object as a value. */

/* You’ll see this in action when you call a Cocoa API that takes or returns an NSDictionary. From Swift, this type appears as [NSObject: AnyObject]. This indicates that the key must be an NSObject subclass, and the value can be any Swift-compatible object. */

// 🟤 NSSet

/* Unlike Swift Dictionary, NSDictionary objects are able to take any NSObject as a key and store any object as a value. */

// 🟤 NSCache

/* Using NSCache is very similar to using NSMutableDictionary – you just add and retrieve objects by key. The difference is that NSCache is designed for temporary storage for things that you can always recalculate or regenerate. If available memory gets low, NSCache might remove some objects. They are thread-safe, but Apple's documentation warns the cache may decide to automatically mutate itself asynchronously behind the scenes if it is called to free up memory. */

/* This means that an NSCache is like an NSMutableDictionary, except that Foundation may automatically remove an object at any time to relieve memory pressure. This is good for managing how much memory the cache uses, but can cause issues if you rely on an object that may potentially be removed. */

/* NSCache also stores weak references to keys rather than strong references. */

// This API has its roots in the Objective-C days, and as such the generic parameters are constrained to conform to AnyObject, meaning that we cannot use structs and must uses classes instead.

// 🟤 NSCountedSet

/* NSCountedSet tracks how many times you've added an object to a mutable set. It inherits from NSMutableSet, so if you try to add the same object again it will only be reflected once in the set. */

/* However, an NSCountedSet tracks how many times an object has been added. You can see how many times an object was added with .count(for:). */

let countedMutable = NSCountedSet()
let object = "name"
    countedMutable.add(object)
    countedMutable.add(object)

print("NSCountedSet count is \(countedMutable.count), but object: \(object) was added \(countedMutable.count(for: object)) times")

// 🟤 NSOrderedSet

/* An NSOrderedSet along with its mutable counterpart, NSMutableOrderedSet, is a data structure that allows you to store a group of distinct objects in a specific order. */

/* You can use ordered sets as an alternative to arrays when element order matters and performance while testing whether an object is contained in the set is a consideration -- testing for membership of an array is slower than testing for membership of a set. */

/* Because of this, the ideal time to use an NSOrderedSet is when you need to store an ordered collection of objects that cannot contain duplicates. */

// 🟤 NSHashTable and NSMapTable

// 🟤 NSHashTable is similar to NSMutableSet, but you can set memory management and equality comparison terms explicitly using NSHashTableOptions enum.

// 🟤 NSMapTable is a dictionary-like data structure, but with similar behaviors to NSHashTable when it comes to memory management. Like an NSCache, an NSMapTable can hold weak references to keys. However, it can also remove the object related to that key automatically whenever the key is deallocated. These options can be set from the NSMapTableOptions enum.


// MARK: - ⚫️ Copy-on-Write mechanism ⚫️

// ⚫️ About
// By default Value Type[About] does not support COW(Copy on Write) mechanism.
// Warning: copy on write is a feature specifically added to Swift arrays and dictionaries; you don't get it for free in your own data types.

// how to check address:

// Print memory address
func address(_ object: UnsafeRawPointer) -> String {
    let address = Int(bitPattern: object)
    return NSString(format: "%p", address) as String
}

// At a basic level, Array is just a structure that holds a reference to a heap-allocated buffer containing the elements – therefore multiple Array instances can reference the same buffer. When you come to mutate a given array instance, the implementation will check if the buffer is uniquely referenced, and if so, mutate it directly. Otherwise, the array will perform a copy of the underlying buffer in order to preserve value semantics.

// ⚫️ Implementing COW in custom value types

final class Ref<T> {
  var val : T
  init(_ v : T) {val = v}
}

struct Box<T> {
    var ref : Ref<T>
    init(_ x : T) { ref = Ref(x) }

    var value: T {
        get { return ref.val }
        set {
          if (!isKnownUniquelyReferenced(&ref)) {
            ref = Ref(newValue)
            return
          }
          ref.val = newValue
        }
    }
}
// This code was an example taken from the swift repo doc file OptimizationTips
// Link: https://github.com/apple/swift/blob/master/docs/OptimizationTips.rst#advice-use-copy-on-write-semantics-for-large-values

