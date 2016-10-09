//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var someInts = [Int]()
print("someInts is of type [Int] with \(someInts.count) items.")

someInts.append(3)
someInts = []


var threeDoubles = Array(repeating: 0.0, count: 3)
var anotherThreeDoubles = Array(repeating : 2.5, count: 3)

var sixDoubles = threeDoubles + anotherThreeDoubles

var shoppingList:[String] = ["Eggs", "Milk"]

print("The shopping list contains \(shoppingList.count) items.")

if shoppingList.isEmpty {
    print("The shopping list is empty.")
} else {
    print("The shopping list is not empty.")
}

shoppingList.append("Flour")

shoppingList += ["Baking Powder"]
shoppingList += ["Chocolate Spread", "Cheese", "Butter"]

var firstItem = shoppingList[0]
shoppingList[0] = "Six eggs"
shoppingList[4...6] = ["Banana", "Apple"]
print(shoppingList)
shoppingList.insert("Maple Syrup", at:0)
shoppingList.remove(at: 0)

firstItem = shoppingList[0]
let apples = shoppingList.removeLast()

for item in shoppingList {
    print(item)
}

for( index, value) in shoppingList.enumerated() {
    print("Item \(index + 1) : \(value)")
}

var letters = Set<Character>()

print("letter is of type Set<Character> with \(letters.count) items.")

letters.insert("a")
letters = []

// Set must be explicitly declared
var favoriteGenres : Set = ["Rock", "Classical", "Hip hop"]

print("I have \(favoriteGenres.count) favoriate music genres.")

if favoriteGenres.isEmpty {
    print("As far as music goes, I'm not picky.")
} else {
    print("I have particular music preferences.")
}

favoriteGenres.insert("Jazz")

if let removedGenre = favoriteGenres.remove("Rock") {
    print("\(removedGenre)? I'm over it")
} else {
    print("I never much cared for that.")
}


if favoriteGenres.contains("Funk") {
    print("I get up on the good foot")
} else {
    print("It's too funky in here.")
}


for genre in favoriteGenres.sorted() {
    print("\(genre)")
}


let oddDigits: Set = [1,3,5,7,9]
let evenDigits: Set = [0,2,4,6,8]
let singleDigitPrimeNumbers:Set = [2,3,5,7]

oddDigits.union(evenDigits).sorted()
oddDigits.intersection(evenDigits).sorted()
oddDigits.subtracting(evenDigits).sorted()
oddDigits.symmetricDifference(singleDigitPrimeNumbers)

let houseAnimals :Set = ["🐶","🐱"]
let farmAnimals : Set = ["🐮","🐔","🐑","🐶","🐱"]
let cityAnimals : Set = ["🐦","🐭"]

houseAnimals.isSubset(of: farmAnimals)
farmAnimals.isSuperset(of: houseAnimals)
farmAnimals.isDisjoint(with: cityAnimals)

var namesOfIntegers = [Int:String]()

namesOfIntegers[16] = "sixteen"
namesOfIntegers = [:]


var airports = ["YYZ":"Toronto Pearson", "DUB":"Dublin"]

print("The airports dictionary contains \(airports.count) items.")

if airports.isEmpty {
    print("The airports dictionary is empty.")
} else {
    print("The airports dictionary is not empty.")
}

airports["LHR"] = "London"
airports["LHR"] = "London Heathrow"

if let oldValue = airports.updateValue("Dublin Airport", forKey: "DUB") {
  print("The old value for DUB was \(oldValue)")
}

if let airportName =  airports["DUB"] {
    print("The name of the airport is \(airportName).")
} else {
    print("That airport is not in the airpots dictionary.")
}

airports["APL"] = "Apple International"
airports["APL"] = nil
print(airports)

if let removedValue = airports.removeValue(forKey: "DUB") {
    print("The removed airport's name is \(removedValue).")
} else {
    print("The airports dictionary does not contain a value for DUB.")
}

for (airportCode, airportName) in airports {
    print("\(airportCode): \(airportName)")
}

for airportCode in airports.keys {
    print("Airport code : \(airportCode)")
}

for airportName in airports.values {
    print("Airport name : \(airportName)")
}

let airportCodes = [String](airports.keys)
let airportNames = [String](airports.values)

//Swift’s Dictionary type does not have a defined ordering. To iterate over the keys or values of a dictionary in a specific order, use the sorted() method on its keys or values property.





