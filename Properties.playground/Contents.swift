import Foundation

// Computed properties are provided by classes, structures, and enumerations. Stored properties are provided only by classes and structures.

// MARK: - 🍑 Stored Properties 🍑
// 🍑 About:
// 💥 When an instance of a value type is marked as a constant, so are all of its properties.
// 💥 If you assign an instance of a reference type to a constant, you can still change that instance’s variable properties.



// MARK: - 🥝 Lazy Properties 🥝

// 🥝 About:
// 💥 A lazy property is a property whose initial value isn’t calculated until the first time it’s used.
// 💥 Constant properties must always have a value before initialization completes, and therefore can’t be declared as lazy.
// 💥 if lazy property is accessed by multiple threads simultaneously and the property hasn’t yet been initialized, there’s no guarantee that the property will be initialized only once.

// 🥝 Use cases:
// 💥 initial value for a property is dependent on outside factors whose values aren’t known until after an instance’s initialization is complete.
// 💥 when the initial value for a property requires complex or computationally expensive setup that shouldn’t be performed unless or until it’s needed


// MARK: - 🍓 Computed Properties 🍓

// 🍓 About:
// 💥 don`t store any value, they provide a getter and an optional setter to retrieve and set other properties and values indirectly.
// 💥 Shopuld be alvays declared as variables, not constants with the var keyword, because their value isn’t fixed.

// 💥 Read-Only Computed Properties - with a getter but no setter




// MARK: - 🌖 Property Observers 🌖

// 🌖 About:
// 💥 observe and respond to changes in a property’s value
// 💥 are called every time a property’s value is set, even if the new value is the same as the property’s current value
// 💥 are declared with var and not the let keyword
// 💥 A property with observers on it when declared should have initial value assigned to it. This actually makes the difference between computed properties and property observers. This value could be optional type or any other type.
// 💥 have a default parameters newValue and oldValue
// 💥 property observers cannot be used on lazy variable because a property with observers on it need to have initial value.
// 💥 If you pass a property that has observers to a function as an in-out parameter, the willSet and didSet observers are always called. This is because of the copy-in copy-out memory model for in-out parameters: The value is always written back to the property at the end of the function.

// 🌖 Can be added to:
// 💥 Stored properties that you define
// 💥 Stored properties that you inherit
// 💥 Computed properties that you inherit

// 🌖 Example:
class StepCounter {
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) {
            print("About to set totalSteps to \(newTotalSteps)")
        }
        didSet {
            if totalSteps > oldValue  {
                print("Added \(totalSteps - oldValue) steps")
            }
        }
    }
}
let stepCounter = StepCounter()
stepCounter.totalSteps = 200
// About to set totalSteps to 200
// Added 200 steps
stepCounter.totalSteps = 360
// About to set totalSteps to 360
// Added 160 steps
stepCounter.totalSteps = 896
// About to set totalSteps to 896
// Added 536 steps

// MARK: - 📦 Property Wrappers 📦

// 📦 About

// When you use a property wrapper, you write the management code once when you define the wrapper, and then reuse that management code by applying it to multiple properties.

// 📦 Example

// The example wrapper ensures that the value it wraps always contains a number less than or equal to 12. If you ask it to store a larger number, it stores 12 instead.

// Declaration:
@propertyWrapper
struct TwelveOrLess {
    private var number = 0
    var wrappedValue: Int {
        get { return number }
        set { number = min(newValue, 12) }
    }
}

// Usage:
struct SmallRectangle {
    @TwelveOrLess var height: Int
    @TwelveOrLess var width: Int
}

// IS THE SAME AS:

struct SmallRectangleNonWrapping {
    private var _height = TwelveOrLess()
    private var _width = TwelveOrLess()
    var height: Int {
        get { return _height.wrappedValue }
        set { _height.wrappedValue = newValue }
    }
    var width: Int {
        get { return _width.wrappedValue }
        set { _width.wrappedValue = newValue }
    }
}

var rectangle = SmallRectangle()
print(rectangle.height)
// Prints "0"

rectangle.height = 10
print(rectangle.height)
// Prints "10"

rectangle.height = 24
print(rectangle.height)
// Prints "12"

// 📦 Initial values

@propertyWrapper
struct MultipleInitsNumber {
    private var maximum: Int
    private var number: Int

    var wrappedValue: Int {
        get { return number }
        set { number = min(newValue, maximum) }
    }

    init() {
        maximum = 12
        number = 0
    }
    init(wrappedValue: Int) {
        maximum = 12
        number = min(wrappedValue, maximum)
    }
    init(wrappedValue: Int, maximum: Int) {
        self.maximum = maximum
        number = min(wrappedValue, maximum)
    }
}

struct MultipleHeightRectangle {
    @MultipleInitsNumber var height: Int // calls init()
    @MultipleInitsNumber var heightTwo: Int = 1 // calls init(wrappedValue: Int)
    @MultipleInitsNumber(wrappedValue: 2, maximum: 5) var heightThree: Int // calls init(wrappedValue: Int, maximum: Int)
}

// 📦 Projected values
 

// MARK: - 🧭 Global and Local Variables 🧭

// 💥 Global variables - variables that are defined outside of any function, method, closure, or type context.
// 💥 Local variables are variables that are defined within a function, method, or closure context.

// if computed:

// 💥 Global - always computed lazily
// 💥 Local - never computed lazily.


// MARK: - 🪣 Type Properties 🪣

// 💥 Computed type properties are always declared as variable properties (just like instance ones)
// 💥 Stored type properties should always have a default value
// 💥 Stored type properties are lazily initialized by default


// Stored Properties and Instance Variables ‼️‼️‼️‼️‼️‼️‼️
// Links:
