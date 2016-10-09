//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


class RequestManager {
    
}

class ViewController : UIViewController {
    
    var requestManager : RequestManager?
}

let viewController = ViewController()

viewController.requestManager = RequestManager()



protocol Serializer {
    func serialize(data:AnyObject)-> NSData?
}

class RequestSerializer : Serializer {
    func serialize(data:AnyObject) -> NSData? {
        
        return NSData()
    }
}

class RecieveSerializer : Serializer {
    func serialize(data:AnyObject) -> NSData? {
        
        return NSData()
    }
}


class MockSerializer : Serializer {
    func serialize(data:AnyObject) -> NSData? {
        
        return NSData()
    }
}

class Request {
    
}

class DataManager {
    let serializer: Serializer! // = RequestSerializer()
    
    init(serializer : Serializer) {
        self.serializer = serializer
    }
    
    func serializeRequest (request:Request, withSerializer serializer:Serializer)->NSData {
        return NSData()
    }
}


let serializer = RequestSerializer()
let dataManager = DataManager(serializer: serializer)


//dataManager.serializer = RequestSerializer()
//dataManager.serializer = RecieveSerializer()
//dataManager.serializer = MockSerializer()

