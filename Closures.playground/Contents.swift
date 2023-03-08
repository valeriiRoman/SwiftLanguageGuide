import Foundation
import UIKit

/*
Closures take one of three forms:

 ✅ Global functions are closures that have a name and don’t capture any values.

 ✅ Nested functions are closures that have a name and can capture values from their enclosing function.

 🚹 Closure expressions are unnamed closures written in a lightweight syntax that can capture values from their surrounding context.
 */

/*
Functions and closures are first-class citizens in Swift because you can treat then like a normal value. For example, you can:
 ❕ assign a function/closure to a local variable.
 ❕ pass a function/closure as an argument.
 ❕ return a function/closure.
 */

// ⭕️ Creating instance method references
// For each instance method a type has, there's a corresponding static method that lets you retrieve that instance method as a closure, by passing an instance as an argument.

// For example, we can use the following to retrieve a reference to the removeFromSuperview method for a given UIView instance:

let view = UIView()
let closure = UIView.removeFromSuperview(view)

// MARK: - ✅ Functions ✅

// ✅ About
// Functions are self-contained chunks of code that perform a specific task.

// ✅ Argument Label & Parameter Name
func someFunction(argumentLabel parameterName: Int) {
// From inside the local function`s scope only parameterName is visible.
    print(parameterName)
}

// Argument Label is "external"
someFunction(argumentLabel: .zero)


// ✅ In-Out Parameters

/*
 In-out parameters aren’t the same as returning a value from a function. The swapTwoInts example above doesn’t define a return type or return a value, but it still modifies the values of someInt and anotherInt. In-out parameters are an alternative way for a function to have an effect outside of the scope of its function body.
 */

func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)
print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")

/*
 Inout mechanism in Swift uses "copy-in copy-out" or "call by value result" behavior:
1. When the function is called, the value of the argument is copied.
2. In the body of the function, the copy is modified.
3. When the function returns, the copy’s value is assigned to the original argument.
 
 The "optimized" alternative of this is a "call by reference" behavior. It satisfies all of the requirements of the copy-in copy-out model while removing the overhead of copying (when the argument is a value stored at a physical address in memory, the same memory location is used both inside and outside the function body).
 */

// You place an ampersand (&) directly before a variable’s name when you pass it as an argument to an in-out parameter, to indicate that it can be modified by the function.
// In-out parameters can’t have default values.
// You can only pass a variable as the argument for an in-out parameter.
// Within a function, don’t access the original "var" that was passed as an in-out argument, even if the original value is available in the current scope. Accessing the original is a simultaneous access of the value, which violates Swift’s memory exclusivity guarantee. For the same reason, you can’t pass the same value to multiple in-out parameters.

// ✅ defer keyword

// Code in defer closure inside function will be executed "no metter what, but exactly before the function ends it`s execution"
// defer can be used in e.g. do {} blocks, or on loops (in this case it will be executed at the end of each iteration):
for i in 1...10 {
    print ("In \(i)")
    defer { print ("Deferred \(i)") }
    print ("Out \(i)")
}

// multiple defers can be declared - they will be executed in the order they were declared.

// ✅ Function Types

// Every function has a specific function type, made up of the parameter types and the return type of the function:

func addTwoInts(_ a: Int, _ b: Int) -> Int {
    return a + b
}
func multiplyTwoInts(_ a: Int, _ b: Int) -> Int {
    return a * b
}
// Both are (Int, Int) -> Int.

func printHelloWorld() {
    print("hello, world")
}
// It is just () -> Void

// Because of this You can assign functions to property, like:
let mathFunction: (Int, Int) -> Int = addTwoInts

// and call a variable, like:
print("Result: \(mathFunction(2, 3))")

// functions of a certain type can be inserted inside another function during calling, like:
func printMathResult(_ mathFunction: (Int, Int) -> Int, _ a: Int, _ b: Int) {
    print("Result: \(mathFunction(a, b))")
}
printMathResult(addTwoInts, 3, 5)

// functions of a certain type can be a return type of another functions, like:
func stepForward(_ input: Int) -> Int {
    return input + 1
}
func stepBackward(_ input: Int) -> Int {
    return input - 1
}
func chooseStepFunction(backward: Bool) -> (Int) -> Int {
    return backward ? stepBackward : stepForward
}
let correctFunction = chooseStepFunction(backward: true)
print(correctFunction(.zero))

// ✅ Nested functions

// Unlike global functions discussed above, You can also define functions inside the bodies of other functions.

func chooseStepFunctionFromNesteds(backward: Bool) -> (Int) -> Int {
    func stepForward(input: Int) -> Int { return input + 1 }
    func stepBackward(input: Int) -> Int { return input - 1 }
    return backward ? stepBackward : stepForward
}

// MARK: - 🚹 Closure expressions 🚹

// 🚹 About

/*
 Closures are self-contained blocks of functionality that can be passed around and used in your code. Closures in Swift are similar to blocks in C and Objective-C and to lambdas in other programming languages.
 */

// Parameters in closure expression can’t have a default value.

// 🚹 Inferring Type From Context, Implicit Returns from Single-Expression Closures & Shorthand Argument Names

// If a closure expressions is passed as an argument to a method, Swift can infer the types of its parameters and the type of the value it returns, omitting the return keyword from the declaration and omit the closure’s argument list, like:
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
var reversedNames = names.sorted(by: { $0 > $1 } )

// instead of:

reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in
    return s1 > s2
})

// 🚹 Operator Methods
// Classes and structures can provide their own implementations of existing operators. This is known as overloading the existing operators.
// So You can use:

reversedNames = names.sorted(by: >)

// 🚹 Capturing Values
// A closure can capture constants and variables from the surrounding context in which it’s defined.
// As an optimization, Swift may instead capture and store a copy of a value if that value isn’t mutated by a closure, and if the value isn’t mutated after the closure is created.

// 🚹 Strong Reference Cycles for Closures.

// An escaping closure that refers to self needs special consideration if self refers to an instance of a class.
// An escaping closure can’t capture a mutable reference to self when self is an instance of a structure or an enumeration. Structures and enumerations don’t allow shared mutability

/* Let’s see where closures are by default escaping:

 ❕ Variables of function type are implicitly escaping
 ❕ typealiases are implicitly escaping
 ❕ Optional closures are implicitly escaping
 */
// 🚹 Closures Are Reference Types

// ????

// 🚹 Autoclosures
// An autoclosure is a closure that’s automatically created to wrap an expression that’s being passed as an argument to a function.
// The code inside isn’t run until you call the closure. It is useful for code that has side effects or is computationally expensive, because it lets you control when that code is evaluated.

var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
print(customersInLine.count)
// Prints "5"

let customerProvider = { customersInLine.remove(at: 0) }
print(customersInLine.count)
// Prints "5"

print("Now serving \(customerProvider())!")
// Prints "Now serving Chris!"
print(customersInLine.count)
// Prints "4"

// Explicit closure:
// customersInLine is ["Alex", "Ewa", "Barry", "Daniella"]
func serve(customer customerProvider: () -> String) {
    print("Now serving \(customerProvider())!")
}
serve(customer: { customersInLine.remove(at: 0) } )
// Prints "Now serving Alex!"

// Autoclosure:
// customersInLine is ["Ewa", "Barry", "Daniella"]
func serve(customer customerProvider: @autoclosure () -> String) {
    print("Now serving \(customerProvider())!")
}
serve(customer: customersInLine.remove(at: 0))
// Prints "Now serving Ewa!"

// Pros of using autoclosures:
// 1. Is used inside wherever code needs to be passed in and executed only if conditions are right. For example, the && operator uses @autoclosure to allow short-circuit evaluation. If we insert normal expression as a parameter to a function and use it later, inside this func based on a condition it will be accessed and computed at the begginning of the function call no matter what condition will be. So, to solve this problem we need closure to wrap a parameter value and call it later.
// 2. To avoid braces inside a function call we use @autoclosure, so You will be able to insert arguments as normal expressions, but they will be wrapped to a closure inside a function under the hood and will be "independant" from the function call.


var computedValue: String {
    print("I am accessed")
    return "computedValue"
}

let condition = false

func normalConditionalPrint(normalArgument: String) {
    if condition {
        print(normalArgument)
    }
}

func autoclosureConditionalPrint(autoclosure: @autoclosure () -> String) {
    if condition {
        print(autoclosure())
    }
}

normalConditionalPrint(normalArgument: computedValue)
autoclosureConditionalPrint(autoclosure: computedValue)

// MARK: - ♈️ Methods ♈️

// ♈️ About
// Methods are functions that are associated with a particular type.


// ♈️ Instance method
// Are methods that you call on an instance of a particular type.
// It is just a regular functio, declared within the type. It can be used only with the use of the instance of this type, like :

class Counter {
    var count = 0
    func increment() {
        count += 1
    }
}

let counter = Counter()
// the initial counter value is 0
counter.increment()
// the counter's value is now 1


// ♈️ Type Methods (static)
// Are methods that are called on the type itself.
// Classes can use the class keyword instead, to allow subclasses to override the superclass’s implementation of that method.


// ♈️ self in methods
// 👉🏼 in instance methods:
// Every instance of a type has an implicit property called self, which is exactly equivalent to the instance itself. If you don’t explicitly write self, Swift assumes that you are referring to a property or method of the current instance. The main exception to this rule occurs when a parameter name for an instance method has the same name as a property of that instance. Without the self prefix, Swift would assume that both uses of x referred to the method parameter called x:
struct Point {
    var x = 0.0, y = 0.0
    func isToTheRightOf(x: Double) -> Bool {
        return self.x > x
    }
}

// 👉🏼 in value types instance methods:
// Mutating methods can assign an entirely new instance to the implicit self property.
struct Point {
    var x = 0.0, y = 0.0
    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
        self = Point(x: x + deltaX, y: y + deltaY)
    }
}

// 👉🏼 in type methods:
// Within the body of a type method, the implicit self property refers to the type itself


// ♈️ @discardableResult attribute
// Mark methods with @discardableResult when it returns something but You will not necessarily need the result. Example:

struct ExampleStruct {
    
    func log(_ message: String) -> String {
        let logLine = "\(Date.now): \(message)"
        print(logLine)
        return logLine
    }
    
    @discardableResult func discardableLog(_ message: String) -> String {
        let logLine = "\(Date.now): \(message)"
        print(logLine)
        return logLine
    }
}

let exampleStruct = ExampleStruct()
_ = exampleStruct.log("Hello, world!")
exampleStruct.discardableLog("Hello, world!")

/* Sources:

https://medium.com/swift-india/functional-swift-closures-67459b812d0#id_token=eyJhbGciOiJSUzI1NiIsImtpZCI6IjhlMGFjZjg5MWUwOTAwOTFlZjFhNWU3ZTY0YmFiMjgwZmQxNDQ3ZmEiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJuYmYiOjE2NzIwNjIwMTEsImF1ZCI6IjIxNjI5NjAzNTgzNC1rMWs2cWUwNjBzMnRwMmEyamFtNGxqZGNtczAwc3R0Zy5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsInN1YiI6IjEwNzY3MDE4NDQ2NjU0MjUyNDIzOSIsImVtYWlsIjoibW90cnVrMDA3QGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJhenAiOiIyMTYyOTYwMzU4MzQtazFrNnFlMDYwczJ0cDJhMmphbTRsamRjbXMwMHN0dGcuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJuYW1lIjoiVGFyYXMgTW90cnVrIiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hL0FFZEZUcDVjVE9pX3pTTkZibE9VVHVRRmZwSC1GUzVlYV9CYnRmNURmYk1JPXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6IlRhcmFzIiwiZmFtaWx5X25hbWUiOiJNb3RydWsiLCJpYXQiOjE2NzIwNjIzMTEsImV4cCI6MTY3MjA2NTkxMSwianRpIjoiZTY3NzViNjY3NTVmNWM2YWEyYzE3OTQ0NDg4MmRmZDNlMWYwOWY2ZCJ9.O4ATcPlpI26NADIRcxJK8NA7nF4rTqWsGvDvtJEfZBq2C3nKBGAfiwiQaOibSbXInxp0Ri3C5wL2IyVQe0dhoz9trs0Fh-okub_tUspfW8PSpAqinIyfSpMr2x6m2XsnmB8QzCWqjLCqhFjxyUQqQsrsAgC7ASgoWr_MyQfpmUR0ngaMnL51FkSZOCcuLIVEuCc4aDveORoZ0jTUXxJelxcMGET1Z-52CFUjJybuGbCEoNDMUZQ0HlKzkyKz-ZrixkmpGjRvCvqI1PZSO_DqzMSbcODf6Ck1Rszkhf0GhtENWBum0oRhXvjDzMyCgAJ9I0qFjZlXehsFa8DKfHCi8A
 
 https://www.hackingwithswift.com/example-code/language/how-to-ignore-return-values-using-discardableresult
 */
