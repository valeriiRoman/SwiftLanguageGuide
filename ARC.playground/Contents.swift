import Foundation


// MARK: - 🤌🏼 Overview 🤌🏼

// At a very high level, structs and classes can be thought of as constructs that are used to hold values (variables and constants) and functions.


// MARK: - 🧶 Value Types vs. Reference Types 🧶

// 🧶 About

// 👉 Value Type (struct, enum, and tuple): When you copy a value type (i.e., when it’s assigned, initialized or passed into a function), each instance keeps a unique copy of the data. If you change one instance, the other doesn’t change too.
// 👉 Reference Type (class, closure): When you copy a reference type, each instance shares the data. The reference itself is copied, but not the data it references. When you change one, the other changes too.

// 🧶 Value Types: when to use

// 👉🏼 Use structures by default.
// It is safer, as local changes to a structure aren’t visible to the rest of the app unless you intentionally communicate those changes as part of the flow of your app. As a result, you can look at a section of code and be more confident that changes to instances in that section will not have any undesired side effects.

// 👉🏼 They are thread-safe.
// In a multi-threaded environment, for instance with a database connection that’s opened in a different thread, structs are safer. They can be copied from one thread to another thread, without running the risk of a race condition or deadlock. Classes do not have this inherent safety, unless they’re deliberately made thread-safe.

// 👉🏼 Most of type`s properties are values.
// When the properties of a struct are mostly value types too, like String, it makes sense to wrap them in a struct instead of a class. It’s OK to use structs within class types, but pay extra attention if you use classes within struct types. Classes are reference types, so if you’re unaware that your struct references a shared class instance, and your struct gets copied, both structs share a reference to that class!

// 👉🏼 Don’t Need Inheritance.
// If you don’t need inheritance, it’s smarter to use structs (instead of classes). Structs can still conform to protocols, and they can be extended, so you still have a few options for creating flexible, composable code.

// 🧶 Reference Types: when to use

// 👉🏼 Use classes when you need Objective-C interoperability.
// Objective-C had no value types, and for example, many Objective-C frameworks expose classes that you are expected to subclass.

// 👉🏼 You need to control the identity of the data.
// Classes in Swift come with a built-in notion of identity because they’re reference types. This means that when two different class instances have the same value for each of their stored properties, they’re still considered to be different by the identity operator (===). Common use cases are file handles, network connections...

// 👉🏼 Classes can be deinitialized.

// 👉🏼 Copying Doesn’t Make Sense.
// When copying or comparing instances doesn’t make sense, e.g. with Window or UIViewController. It doesn’t make sense to copy an app window, since there’s only one active at a time.


// MARK: - 🐥 Mixed Types 🐥

// 🐥 Value inside a reference type.

struct Value {
    var value: String
}

class ReferenceType {
    var name: String
    var value: Value

    init(name: String, value: Value) {
        self.name = name
        self.value = value
    }
}

let value = Value(value: "Apple")

let referenceInstanceOne = ReferenceType(name: "iPhone", value: value)
let referenceInstanceTwo = ReferenceType(name: "iPhone", value: value)

referenceInstanceTwo.value.value = "Google"

print(referenceInstanceOne.value.value)
print(referenceInstanceTwo.value.value)

// The "same" reference will have different values.
// Even if we are using the same value object, two copies will be created when the instance is inside a reference type.

// 🐥 Reference inside a value type.

class Reference {
    var value: String

    init(value: String) {
        self.value = value
    }
}

struct ValueType {
    var reference: Reference
}

let reference = Reference(value: "Jet")

let objectOne = ValueType(reference: reference)
let objectTwo = ValueType(reference: reference)

objectTwo.reference.value = "Rocket"

print(objectOne.reference.value)
print(objectTwo.reference.value)

// Both of the value types objects have the same reference, the "Rocket". This is because we're referencing the same reference instance. Even if we created two instances of a struct, with the same reference, they won’t copy the reference type like value types.

// MARK: - 👻 Class 👻

// 👻 About

// Additional features over structs:
// 👉 Inheritance
// 👉 Type casting
// 👉 Deinitializers
// 👉 Reference counting allows more than one reference to a class instance

// MARK: - 👳🏿‍♂️ Struct 👳🏿‍♂️

// 👳🏿‍♂️ About

// 👳🏿‍♂️ Mutating
// The properties of value types cannot be modified within its instance methods by default. In order to modify the properties of a value type, you have to use the mutating keyword in the instance method. Take a look on an example:

struct Stack {
    public private(set) var items = [Int]() // Empty items array
    
    mutating func push(_ item: Int) {
        items.append(item)
    }
    
    mutating func pop() -> Int? {
        if !items.isEmpty {
           return items.removeLast()
        }
        return nil
    }
}

var stack = Stack()
stack.push(4)
stack.push(78)
stack.items // [4, 78]
stack.pop()
stack.items // [4]

// 👳🏿‍♂️ Nonmutating
// There is also a nonmutating keyword, which can specify that a constant can be set without modifying the containing instance, but instead has global side effects.

struct Cat {

    var name: String? {
        get {
            return UserDefaults.standard.string(forKey: "CatName")
        }
        nonmutating set {
            if let newValue = newValue {
                UserDefaults.standard.set(newValue, forKey: "CatName")
            } else {
                UserDefaults.standard.removeObject(forKey: "CatName")
            }
        }
    }

}

let cat = Cat()
cat.name = "Sam"
let tiger = Cat()
tiger.name = "Olly"

// Both the cats have "Olly" as their name because they’re using UserDefaults to get their name. Also, even if both are constants, you can set their name property without any warning or error.

// MARK: - 🐷 Enum 🐷

// 🐷 About

/* An enumeration defines a common type for a group of related values and enables you to work with those values. */

// 🐷 Raw value
// 👉🏼 Each raw value must be unique within its enumeration declaration.
// 👉🏼 The raw value for a particular enumeration case is always the same.

// 🐷 Recursive Enumerations
// A recursive enumeration is an enumeration that has another instance of the enumeration as the associated value for one or more of the enumeration cases. You indicate that an enumeration case is recursive by writing "indirect" before it (or before the beginning of the enumeration if all the cases are recursive), which tells the compiler to insert the necessary layer of indirection. Example:

enum ArithmeticExpression {
    case number(Int)
    indirect case addition(ArithmeticExpression, ArithmeticExpression)
    indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
}

let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sum = ArithmeticExpression.addition(five, four)
let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))

print("The result \(product) is (5 + 4) * 2 expression")

// MARK: - 👔 Memory Management 👔

// 👔 About

/* There are two ways in which memory is managed in Swift for value and reference types: stack allocation and heap allocation. */

// 👔 Stack

// In stack memory allocation, the program provides you with the amount of memory it needs to run a particular scope of code. The stack then adds that same amount of memory to itself, and once the scope is de-scoped (i.e. the code has finished executing), the memory is de-allocated.

// 👉🏽 Is fast. The cost of allocating/de-allocation memory on that stack is moving the stack pointer by the amount of memory required, and that just takes a single instruction to execute. This makes value types much faster to use.
// 👉🏽 Stack is used for static memory allocation. Can be calculated at compile time itself since they are not dynamic and do not need reference count semantics to decide how long they have to live (if they are either not contained by or contain a reference type).
// 👉🏽 A linear data structure that behaves like LIFO (objects inputted into a stack last will be the first ones to be evicted).
// 👉🏽 Every thread has its own stack and objects allocated in that stack memory are exclusive to that thread, which makes objects allocated on a stack thread-safe.
// 👉🏽 Memory that can be allocated on a stack is lesser than heap memory.

// 👔 Heap

// 👉🏻 Heap is used for dynamic memory allocation. Variable allocated on the heap have their memory allocated at run time and accessing their memory is bit slower than for Stack.
// 👉🏻 De-allocation of memory happens using Automatic Reference Counting.
// 👉🏻 It`s a global hosting space and therefore thread-unsafe since it is not specific to a thread. This requires you to manage thread safety for it while accessing heap memory.
// 👉🏻 Heap is used when you don't know how much data you need to allocate or they are too big.
// 👉🏻 Objects in here can be accessed and removed randomly.


// Sources:

// https://betterprogramming.pub/classes-vs-structs-basics-and-memory-management-4707714d82e7
// https://developer.apple.com/documentation/swift/choosing-between-structures-and-classes
// https://www.appypie.com/struct-vs-class-swift-how-to#:~:text=In%20Swift%2C%20structs%20are%20value,choice%20between%20classes%20or%20structs.
// https://www.codementor.io/blog/value-vs-reference-6fm8x0syje#:~:text=In%20Swift%20there%20are%20two,type%20is%20usually%20a%20class%20.
// https://www.iosiqa.com/2018/10/difference-stack-and-heap-datastructure.html
