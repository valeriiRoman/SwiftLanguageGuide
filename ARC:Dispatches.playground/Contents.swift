import Foundation


// MARK: - 🐙 ARC workflow 🐙

// ARC tracks how many properties, constants, and variables are currently referring to each class instance. ARC will not deallocate an instance as long as at least one active reference to that instance still exists.


// 🐙 Safe/Unsafe unowned references
// 👉🏼 unowned(safe) (the default). It is wrapped reference which will throw an exception when a dealloced instance is referenced. It's sort of like a weak optional reference that's implicitly unwrapped with x! every time it's accessed.
// 👉🏼 unowned(unsafe). It should not be used in a Swift program, because its purpose is to bridge to code written in Objective C. If you try to access a unsafe unowned reference after the instance that it refers to is deallocated, there will be no exception automatically, like when using a default, safe option. Your program will try to access the memory location where the instance used to be, which is an unsafe operation. It can return some garbage data, random data or crash.


// 🐙 Unowned References and Implicitly Unwrapped Optional Properties

// MARK: - 🐬 Strong Reference Cycles for Closures 🐬
// It occurs because closures, like classes, are reference types. When you assign a closure to a property, you are assigning a reference to that closure. In essence, it’s the same problem as above—two strong references are keeping each other alive. However, rather than two class instances, this time it’s a class instance and a closure that are keeping each other alive.

// MARK: - 🍀 Method Dispatch 🍀

// 🍀 About

/* Method dispatch is the algorithm used to decide which method should be invoked in response to a method call. */

// 🍀 STATIC DISPATCH (aka compile-time dispatch aka direct dispatch)
// 👉🏻 is the fastest method of dispatch
// 👉🏻 extension methods always use static dispatch
// 👉🏻 is not dynamic enough to support subclassing
// 👉🏻 used for: value types, static and final class members

// 🍀 TABLE DISPATCH (aka Runtime dispatch aka Dynamic dispatch)
// Uses an array of function pointers for each method in the class declaration. Most languages refer to this as a “virtual table,” but Swift uses the term “witness table.” Every subclass has its own copy of the table with a different function pointer for every method that the class has overridden.
// To increase performance you can reduce Dynamic Dispatch(Table Dispatch) by adding final when you know that a declaration does not need to be overridden & applying the private keyword (allows the compiler to find all potentially overriding declarations).

// 👉 is slower compared to direct dispatch (the compiler can’t perform any optimisations)
// 👉 the table is consulted at runtime to determine the method to run


// 🍀 MESSAGE DISPATCH
// 👉🏽 is the slowest method of dispatch
// 👉🏽 allows developers to modify the dispatch behavior at runtime
// 👉🏽 used by Cocoa for features like KVO, UIAppearance, and Core Data
// 👉🏽 enables method swizzling, which means that we can change the functionality of a method at runtime.
// 👉🏽 NSObject extensions use message dispatch

// Sources:
// https://medium.com/@pallavidipke07/method-dispatch-in-swift-b113a40a713a
// https://medium.com/@venki0119/method-dispatch-in-swift-effects-of-it-on-performance-b5f120e497d3
