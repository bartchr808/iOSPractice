//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, world"
print(str)
func greet(n name: String, g greeting: String) -> String {
    return "\(greeting), \(name)!"
}
print(greet(n: "Jim", g: "Hi")) // Hi, Jim!

struct s {
    var n: String
    var g: Int {
        return 5 + 5
    }
}

var t = s(n: "hey")
t.n = "g"

print(t.g)

struct Player{
    var name: String
    var surname: String
    var age: Int
    var instrument: String
    var fullname: String {
        get { return "\(name) \(surname)" }
        set(newFullname) {
            let names = newFullname.components(separatedBy: " ")
            name = names[0]
            surname = names[1]
        } }
}
var guitarPlayer = Player(name: "John", surname: "Lennon",
                          age: 29,
                          instrument: "guitar")
guitarPlayer.fullname = "Joe Satriani"
print(guitarPlayer.name)    //Joe
print(guitarPlayer.surname) //Satriani


enum Instrument{
    case Guitar(numStrings: Int)
    case Keyboard(brand: String)
}
let instrument = Instrument.Guitar(numStrings: 7)

switch instrument {
case .Guitar(numStrings: let numStrings) where numStrings == 7:
    print("Let's play 'For the Love of God'")
case .Guitar(numStrings: let numStrings) where numStrings == 12:
    print("Let's play 'Stairway to Heaven'")
case .Keyboard(brand: let brand) where brand == "Hammond":
    print("Let's play 'Tarkus'")
case .Keyboard(brand: let brand) where brand == "Korg":
    print("Let's play 'The Show Must Go On'")
case .Guitar( _):
    print("Guitar")
case .Keyboard( _):
    print("Keyboard")
}


var anUnknownObjct: Any?
anUnknownObjct = "Hello, World"
switch anUnknownObjct {
case nil:
    print("I cannot handle nil element")
case is UIView:
    print("I cannot handle graphic element")
case let value as String:
    print(value)
case let value as Int:
    print("The successor is \(value + 1)")
default:
    print("Unmatched object \(String(describing: anUnknownObjct))")
}

func tttt() {
    defer {
        print(3)
    }
    defer {
        print(2)
    }
    print(1)
}
tttt()

func filterGreaterThan50(value: Int?) -> Int? {
    guard let value = value else {
        return nil }
    if value < 50 {
        return value
    }
    return nil }
let notes: [Int?] = [5, nil, 10, 20, nil, 50, 20, 10]
let a = notes.map{filterGreaterThan50(value: $0)}.flatMap{ $0 }
print(a)
// [5, 10, 20, 20, 10]

var av = { first in
    return first + "world"
}
print(av("hello "))
