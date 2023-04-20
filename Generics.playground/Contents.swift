import Foundation
import SwiftUI
import UIKit

// MARK: - 0️⃣ Generic Functions 0️⃣

// 0️⃣ About

// Generic programming is a way to write functions and data types while making minimal assumptions about the type of data being used.
// An example of a generic you will have already encountered in Swift is the Optional type (or arrays, dictionaries etc.). You can have an optional of any data type you want.

// 0️⃣ Example

func swapTwoValues<T>(_ a: inout T, _ b: inout T) {}
// <T> - type parameter


// MARK: - 0️⃣ Generic Types 0️⃣

struct Stack<Element> {
    var items: [Element] = []
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
}

var stackOfStrings = Stack<String>()
stackOfStrings.push("uno")

// 0️⃣ Extending a Generic Type

extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}

// 0️⃣ Extensions with Where Clause

// With type:
extension Stack where Element: Equatable {
    func isTop(_ item: Element) -> Bool {
        guard let topItem = items.last else {
            return false
        }
        return topItem == item
    }
}

// With protocol:
protocol Container {
    associatedtype Item: Equatable
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

extension Container where Item: Equatable {
    func startsWith(_ item: Item) -> Bool {
        return count >= 1 && self[0] == item
    }
}


// 0️⃣ Contextual Where Clauses (in methods, in extensions to generic types)
// Where clauses in the example below specify what type constraints have to be satisfied to make these new methods available on a container:

extension Container {
    
    // this method will be added to Container only when the items are integers:
    func average() -> Double where Item == Int {
        var sum = 0.0
        for index in 0..<count {
            sum += Double(self[index])
        }
        return sum / Double(count)
    }
    
    // this method will be added to Container only when the items are equatable:
    func endsWith(_ item: Item) -> Bool where Item: Equatable {
        return count >= 1 && self[count-1] == item
    }
}

// ❗️ The "longer" alternative is to write two separate extensions with "where" in extension declarations, like:
// extension Container where Item == Int
// extension Container where Item: Equatable


// 0️⃣ Associated Types with a Generic Where Clause
protocol ContainerTwo {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
    
    associatedtype Iterator: IteratorProtocol where Iterator.Element == Item
    func makeIterator() -> Iterator
}

// MARK: - 1️⃣ Generic Subscripts 1️⃣

extension Container {
    subscript<Indices: Sequence>(indices: Indices) -> [Item]
    where Indices.Iterator.Element == Int {
        var result: [Item] = []
        for index in indices {
            result.append(self[index])
        }
        return result
    }
}


// MARK: - 2️⃣ Type Constraints 2️⃣

// For example, Swift’s Dictionary type needs it`s keys to be hashable. This requirement is enforced by a type constraint on the key type for Dictionary, which specifies that the key type must conform to the Hashable protocol.

// Custom type example:
class SomeClass {}
struct CustomDict<Element: Hashable, Reference: SomeClass> {}


// Function example:
func someFunction<T: Numeric, U: StringProtocol>(someT: T, someU: U) {}


// MARK: - 3️⃣ Associated Type 3️⃣

// It is a replacement of a specific type within a protocol definition.
// They mark holes in protocols that must be filled by whatever types conform to those protocols.


// 3️⃣ A useful example of associated types in action

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}

public protocol BrandColorSupporting {
    associatedtype ColorValue
    static func colorFor(hex: String, alpha: CGFloat) -> ColorValue
}

extension UIColor: BrandColorSupporting {
    public static func colorFor(hex: String, alpha: CGFloat) -> UIColor {
        return UIColor(hex: hex)!.withAlphaComponent(alpha)
    }
}

@available(iOS 13.0, *)
extension Color: BrandColorSupporting {
    public static func colorFor(hex: String, alpha: CGFloat) -> Color {
        return Color(UIColor.colorFor(hex: hex, alpha: alpha))
    }
}

// Not all colors required to define an alpha component we added a default extension to our BrandColorSupporting protocol:

extension BrandColorSupporting {
    static func colorFor(hex: String) -> ColorValue {
        return colorFor(hex: hex, alpha: 1.0)
    }
}

// Both UIColor and Color now conform to the BrandColorSupporting protocol which means that we can define extensions that become available to both.

public extension BrandColorSupporting {
    
    static var orangeCollectHero: ColorValue {
        colorFor(hex: "FF7217")
    }
}

let colorForSwiftUI: Color = Color.orangeCollectHero
let colorForUIKit: UIColor = UIColor.orangeCollectHero

// 3️⃣ Conforming a protocol to a protocol with a defined Associated Type
// ❓❓❓❓❓❓❓

// Sources:
// https://www.avanderlee.com/swift/associated-types-protocols/
