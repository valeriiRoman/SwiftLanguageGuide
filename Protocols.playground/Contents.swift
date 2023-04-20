import UIKit

// MARK: - 🅿️ Protocols - General info 🅿️

// 🅿️ Dispatching Protocols

/*
All the required protocol methods uses Dynamic Dispatch because the compiler has to look for the specific implementation of that method.

There are some exceptions for example, when you create a variable without type but which only conforms to the protocol instead, it is always created in the existential container which uses static dispatch.
*/



// 🅿️ Mutating Method Requirements
// For instance methods on value types you can place the mutating keyword before a method’s func keyword to indicate that the method is allowed to modify the instance it belongs to and any properties of that instance.

// ❗️ You don’t need to write the mutating keyword when writing an implementation of that method for a class

protocol Togglable {
    mutating func toggle()
}

enum OnOffSwitch: Togglable {
    case off, on
    mutating func toggle() {
        switch self {
        case .off:
            self = .on
        case .on:
            self = .off
        }
    }
}
var lightSwitch = OnOffSwitch.off
lightSwitch.toggle()
// lightSwitch is now equal to .on

// 🅿️ Protocols as Types
// Protocols don’t actually implement any functionality themselves.
// But, You can use a protocol in many places where other types are allowed, including:

// 👉🏼 As a parameter type or return type in a function, method, or initializer
// 👉🏼 As the type of a constant, variable, or property
// 👉🏼 As the type of items in an array, dictionary, or other container

// 🅿️ Declaring Protocol Adoption with an Extension
// If a type already conforms to all of the requirements of a protocol, but hasn’t yet stated that it adopts that protocol, you can make it adopt the protocol with an empty extension:
enum OnOffSwitchTwo {
    case off, on
    mutating func toggle() {
        switch self {
        case .off:
            self = .on
        case .on:
            self = .off
        }
    }
}

extension OnOffSwitchTwo: Togglable {}

// 🅿️ Protocol Inheritance
// A protocol can inherit one or more other protocols and can add further requirements on top.

protocol SomeProtocol {
    var someProperty: String { get }
    
}
protocol AnotherProtocol {
    var anotherProperty: String { get }
}


protocol InheritingProtocol: SomeProtocol, AnotherProtocol {
    var additionalProperty: String { get }
}

struct SomeType: InheritingProtocol {
    // must satisfy all of the requirements from inherited protocols
    var someProperty = ""
    var anotherProperty = ""
    
    // plus requirements from the inheriting protocol
    var additionalProperty = ""
}

// 🅿️ Class-Only Protocols

// You can limit protocol adoption to class types (and not structures or enumerations) by adding the AnyObject protocol to a protocol’s inheritance list, like:

protocol SomeClassOnlyProtocol: AnyObject {}

// 🅿️ Protocol Extensions
// Protocols can be extended to provide method, initializer, subscript, and computed property implementations to conforming types.
// Can be used to provide a default implementation to any method or computed property requirement of that protocol.
// ❗️ If a conforming type provides its own implementation of a required method or property it will be used instead of the one, provided by the extension.

// ❗️ Protocol requirements with default implementations provided by extensions are distinct from optional protocol requirements. Although conforming types don’t have to provide their own implementation. ❗️

// 🅿️ Combining protocols with typealias
// We can combine protocols with classes to be even more precise about what we accept:
typealias Codable = Decodable & Encodable

func showUserDetails(on vc: SomeClassOnlyProtocol & UIViewController) {}

// 🅿️ Checking for Protocol Conformance
// 👉🏼 ❗️is❗️ operator returns true if an instance conforms to a protocol and returns false if it does not.
// 👉🏼 ❗️as?❗️ version of the downcast operator returns an optional value of the protocol’s type, and this value is nil if the instance does not conform to that protocol.
// 👉🏼 ❗️as!❗️ version of the downcast operator forces the downcast to the protocol type and triggers a runtime error if the downcast does not succeed.

// MARK: - ❇️ Initializer Requirements ❇️

protocol Initializable {
    init(someParameter: Int)
}

// ❗️ While conforming to a class the protocol init can be either a designed or a convenience one but should be marked as required:
class SomeClass: Initializable {
    required init(someParameter: Int) {}
}

// The use of the required modifier ensures that you will have to provide an explicit or inherited implementation of the initializer requirement on ❗️all subclasses❗️ of the conforming class, such as if they also conform to the protocol.

// If You conform from the final class you don`t have to mark init as required, as they can’t be subclassed.

// MARK: - ⚛️ Adopting a Protocol Using a Synthesized Implementation ⚛️

// ❗️ Swift can automatically provide the protocol conformance for Equatable, Hashable, and Comparable in many simple cases.

// ⚛️ Swift provides a synthesized implementation of Equatable for:
// 👉🏼 Structures that have only stored properties that conform to the Equatable protocol
// 👉🏼 Enumerations that have only associated types that conform to the Equatable protocol
// 👉🏼 Enumerations that have no associated types

// ⚛️ Swift provides a synthesized implementation of Hashable for:
// 👉🏼 Structures that have only stored properties that conform to the Hashable protocol
// 👉🏼 Enumerations that have only associated types that conform to the Hashable protocol
// 👉🏼 Enumerations that have no associated types


// Example:
struct SynthesizedEquatable: Equatable {
    var x = 0.0, y = 0.0, z = 0.0
}

enum SynthesizedHashable: Hashable {
    case x, y, z
}

// ⚛️ Swift provides a synthesized implementation of Comparable for enumerations that don’t have a raw value.
// The implementation of a < func will be synthesized, and the rest of funcs (<=, >, and >=) will be provided by The Comparable protocol’s default implementation.

enum SkillLevel: Comparable {
    case beginner
    case intermediate
    case expert(stars: Int)
}
var levels = [SkillLevel.intermediate, SkillLevel.beginner,
              SkillLevel.expert(stars: 5), SkillLevel.expert(stars: 3)]
for level in levels.sorted() {
    print(level)
}
// Prints "beginner"
// Prints "intermediate"
// Prints "expert(stars: 3)"
// Prints "expert(stars: 5)"

// MARK: - ✴️ Protocol Composition ✴️

// It can be useful to require a type to conform to multiple protocols at the same time. You can combine multiple protocols into a single requirement, like:

protocol Named {
    var name: String { get }
}
protocol Aged {
    var age: Int { get }
}
struct Person: Named, Aged {
    var name: String
    var age: Int
}
func wishHappyBirthday(to celebrator: Named & Aged) {
    print("Happy birthday, \(celebrator.name), you're \(celebrator.age)!")
}
let birthdayPerson = Person(name: "Malcolm", age: 21)
wishHappyBirthday(to: birthdayPerson)
// Prints "Happy birthday, Malcolm, you're 21!"

// MARK: - 🅾️ Optional Protocol Requirements 🅾️

// 👉🏼 Optional requirements are prefixed by the optional modifier as part of the protocol’s definition.
// 👉🏼 Both the protocol and the optional requirement must be marked with the @objc attribute.
// 👉🏼 When you use a method or property in an optional requirement, its type automatically becomes an optional.
// ❗️ @objc protocols can be adopted only by classes

// Example:
@objc protocol CounterDataSource {
    @objc optional func increment(forCount count: Int) -> Int
    @objc optional var fixedIncrement: Int { get }
}

class CounterDataClass: CounterDataSource {
    var dataSource: CounterDataSource?
    var count: Int?
    init() {
        // An optional protocol requirement can be called with optional chaining, like:
        count = dataSource?.increment?(forCount: .zero)
    }
}

// ❗️❗️❗️❗️❗️❗️ Delegation - ???????


// Sources:
// https://betterprogramming.pub/protocols-from-zero-to-hero-72423dfdfe21
