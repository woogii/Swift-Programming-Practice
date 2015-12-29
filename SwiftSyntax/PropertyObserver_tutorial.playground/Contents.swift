//: Playground - noun: a place where people can play

import UIKit


struct Person {
    var name : String
    var age : Int
   
    // Invoking functions with the 'mutating' keyword always results in the property observer being called once
    mutating func incrementAge() {
        if age < 100  {
            age++
        }
    }
}

class MyViewController : UIViewController {
    
    // Property observer are not executed. Instead the variable is assigned during initialization
    var person = Person(name: "Bob", age: 98){
        
        didSet {
            
            print("Person got set to \(person.name) with \(person.age)")
            
            if person.name != oldValue.name {
                person.age = 0
                print("The age of \(person.name) is set to 0")
            }
        }
    }
    
    override func viewDidLoad() {
        person.name = "Tim"
        // person.age = 30
        // person.incrementAge()
        // person.incrementAge()
        // person.incrementAge()
        // person.incrementAge()
    }
}

let myViewController = MyViewController()
// myViewController.viewDidLoad()
// print(myViewController.person.name)

class ViewController : UIViewController {
    
    var numbers: [Int] = [] {
        didSet {
            numbers.sortInPlace()
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        refreshNumbers()
    }
    
    func refreshNumbers() {
        numbers = [random()%10, random()%10, random()%10, random()%10]
        // If the below line is commented out, the property observer gets called twice 
        //numbers.sortInPlace()
    }
    
    func updateUI() {
        print("UI: \(numbers)")
    }
}

let viewController = ViewController()
viewController.viewDidLoad()

