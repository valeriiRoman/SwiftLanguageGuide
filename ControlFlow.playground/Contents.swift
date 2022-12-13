import Foundation

// MARK: - 🟩 Sequence protocol 🟩

// 🟩 About

/* A sequence is a list of values that you can step through one at a time. The most common way to iterate over the elements of a sequence is to use a for-in loop */

// While seemingly simple, this capability gives you access to a large number of operations that you can perform on any sequence. As an example, to check whether a sequence includes a particular value, you can test each value sequentially until you’ve found a match or reached the end of the sequence. This example checks to see whether a particular insect is in an array.

let bugs = ["Aphid", "Bumblebee", "Cicada", "Damselfly", "Earwig"]
var hasMosquito = false
for bug in bugs {
    if bug == "Mosquito" {
        hasMosquito = true
        break
    }
}
print("'bugs' has a mosquito: \(hasMosquito)")

// The Sequence protocol provides default implementations for many common operations that depend on sequential access to a sequence’s values. For clearer, more concise code, the example above could use the array’s contains(_:) method, which every sequence inherits from Sequence, instead of iterating manually:

if bugs.contains("Mosquito") {
    print("Break out the bug spray.")
} else {
    print("Whew, no mosquitos!")
}

// 🟩 Conforming to Sequence

// A sequence protocol requires a factory method that returns an Iterator type.
// An iterator is a type that conforms to Iterator protocol. The protocol has a mutating method next() that returns individual values one after the other until it can’t anymore, in which case it returns a nil.
// So, in order to be able to iterate on th type You can either create custom Iterator, implementing it`s next() method OR implement the requirements of the IteratorProtocol protocol and declare conformance to both Sequence and IteratorProtocol:

struct Countdown: Sequence, IteratorProtocol {
    var count: Int

    mutating func next() -> Int? {
        if count == 0 {
            return nil
        } else {
            defer { count -= 1 }
            return count
        }
    }
}

let threeToGo = Countdown(count: 3)
for i in threeToGo {
    print(i)
}


// MARK: - 🟧 While Loops 🟧

// These kinds of loops are best used when the number of iterations isn’t known before the first iteration begins.

var count = 0
// 🟧 while - evaluates its condition at the start of each pass through the loop:
while count < 5 {
    count += 1
}

// 🟧 repeat-while - evaluates its condition at the end of each pass through the loop:
repeat {
    count += 1
} while count < 5

// MARK: - 🟦 Switches 🟦

// 🟦 No Implicit Fallthrough

// In contrast with switch statements in C and Objective-C, switch statements in Swift don’t fall through the bottom of each case and into the next one by default. Instead, the entire switch statement finishes its execution as soon as the first matching switch case is completed, without requiring an explicit break statement. This makes the switch statement safer and easier to use than the one in C and avoids executing more than one switch case by mistake.

// 🟦 Value Bindings

// This behavior is known as value binding, because the values are bound to temporary constants or variables within the case’s body:

let someTuple = (2, 0)
switch someTuple {
case (let firstValue, 0):
    print("the first `binded` value is \(firstValue)")
case (2, let secondValue):
    print("the second `binded` value is \(secondValue)")
case (let value, 0), (0, let value): print("we can add multiple matching cases inside a single case for tuples")

case let (firstValue, secondValue):
    print("both values are: \(firstValue) and \(secondValue)")
}

// 🟦 Checking type

let something = "" as AnyObject

switch something {
case is NSString:
    print("if you simply want to check type")
case let nsData as NSData:
    print("I have got some data here: \(nsData)")
    print("if you want to retain the cast for future use")
default:
    break
}

// 🟦 Where clause:

let anotherTuple = (5, -5)
switch anotherTuple {
case let (x, y) where x == y:
    print("the x (\(x)) == y (\(y))")
case let (x, y) where x == -y:
    print("the x (\(x)) == -y (\(-y))")
case let (x, y):
    print("hmmm...the x is (\(x)), and the y is (\(y))")
}

// MARK: - ⬜️ Control Transfer Statements ⬜️

// ⬜️ continue - tells a loop to stop what it’s doing and start again at the beginning of the next iteration through the loop. It says “I am done with the current loop iteration” without leaving the loop altogether.

// ⬜️ break - ends execution of an entire control flow statement immediately. The break statement can be used inside a switch or loop statement when you want to terminate the execution of the switch or loop statement earlier than would otherwise be the case.

// ⬜️ fallthrough - means `go further and execute the next case`. Unlike C and Obj-C if the first case condition is satisfied - it`s code is executed and execution ends. If we want the C-like switch - to be able to execute multiple cases - use `fallthrough`.

// The fallthrough keyword doesn’t check the case conditions for the switch case that it causes execution to fall into.

// ⬜️ return

// ⬜️ throw

// MARK: - ⬛️ Checking API Availability ⬛️

/* Ensures that you don’t accidentally use APIs that are unavailable on a given deployment target. */

// The compiler uses the information from the availability condition when it verifies that the APIs in that block of code are available.

// An asterisk (*), denoting that the API is available for all other platforms. An asterisk is always required for platform availability annotations to handle potential future platforms
if #available(iOS 10, macOS 10.12, *) {
    // Use iOS 10 APIs on iOS, and use macOS 10.12 APIs on macOS
} else {
    // Fall back to earlier iOS and macOS APIs
}

// OR

guard #available(iOS 10, macOS 10.12, *) else  {
    // Fall back to earlier iOS and macOS APIs
}
// Use iOS 10 APIs on iOS, and use macOS 10.12 APIs on macOS

// OR

if #unavailable(iOS 10) {
    // Fallback code
}
