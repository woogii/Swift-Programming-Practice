//: ## Building URLs
//: In this playground, we will build URLs from **String** objects. Consider the following **String**: it represents a URL like the ones required in the *Flick Finder* app. Note: The API key used here is invalid; you will need to use your API key.
import UIKit
import XCPlayground

XCPSetExecutionShouldContinueIndefinitely()
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true 

let desiredURLString: String = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=df52b9fa8e1632a530e801c286f20f7c&text=baby+asian+elephant&format=json&nojsoncallback=1"

//: How can we build this URL in a clean, reusable way that is not hard-coded? Let's start by breaking it into its component parts. For example, here is the baseURL. This baseURL is always the same no matter the Flickr method.
let baseURL: String = "https://api.flickr.com/services/rest/"

//: Next are those pesky key-value pairs. Remember, by using key-value pairs, we are able to pass information along to an API in a structured way. A good way of organizing key-value pairs is by using a **Dictionary**. Note: I have substituted the spaces in "baby asian elephant" with "+" signs, but substituting with "%20" would also work (see this [w3schools article](http://www.w3schools.com/tags/ref_urlencode.asp) for an explanation). Of course, you cannot expect your users to know these nuance when they enter their searches, so will need to handle this in your code. Also, you may need to add extra key-value pairs!
let keyValuePairs = [
    "method": "flickr.photos.search",
    "api_key": "df52b9fa8e1632a530e801c286f20f7c",
    "text": "baby+asian+elephant",
    "format": "json",
    "nojsoncallback": "1"
]

//: Now, let's build that **String**! Here I do it in a very ugly, manual way. But, for your code, I recommend that you write a function which iterates through the key-value pairs and creates the URL.
var ourURLString = "\(baseURL)"
ourURLString += "?method=" + keyValuePairs["method"]!
ourURLString += "&api_key=" + keyValuePairs["api_key"]!
ourURLString += "&text=" + keyValuePairs["text"]!
ourURLString += "&format=" + keyValuePairs["format"]!
ourURLString += "&nojsoncallback=" + keyValuePairs["nojsoncallback"]!

//: Now, you will need to use the **String** to build a URL and issue your request. Hint: Refer to the *Sleeping in the Library* code as a guide, and adapt it for your needs!


//func escapeParameters(parameters:[String: AnyObject])

if ourURLString == desiredURLString {
    print("Success!")
} else {
    print("😓 Not quite...")
}

//let url = NSURL(string:ourURLString)!
//let request = NSURLRequest(URL:url)
//let session = NSURLSession.sharedSession()
//
//let task = session.dataTaskWithRequest(request) {data, response, downloadError in
//    print("Test")
//    if let error = downloadError {
//        print("Could not complete the request \(error)")
//    } else {
//        print("test")
//        var parsingError: NSError? = nil
//        let parsedResult: AnyObject!
//        
//        do {
//            parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
//            print(parsedResult)
//        } catch let error as NSError {
//            parsingError = error
//            parsedResult = nil
//        }
//        
//        if let photoDictionary = parsedResult.valueForKey("photos") as? NSDictionary{
//            print("test")
//            if let photoArray = photoDictionary.valueForKey("photo") as? [[String: AnyObject]] {
//                print(photoArray)
//                
//                /* 6 - Grab a single, random image */
//                let randomPhotoIndex = Int(arc4random_uniform(UInt32(photoArray.count)))
//                let photoDictionary = photoArray[randomPhotoIndex] as [String: AnyObject]
//                
//                /* 7 - Get the image url and title */
//                let photoTitle = photoDictionary["title"] as? String
//                print(photoTitle)
//                
//                let imageUrlString = photoDictionary["url_m"] as? String
//                let imageURL = NSURL(string: imageUrlString!)
//                
//                /* 8 - If an image exists at the url, set the image and title */
//                if let imageData = NSData(contentsOfURL: imageURL!) {
//                    dispatch_async(dispatch_get_main_queue(), {
//            
//                    })
//                }
//                print(photoTitle)
//            }
//        }
//        
//
//    }
//}
//
//task.resume()
let temp:String!

func encodeParameters( params: [String: String]) -> String {
    let queryItems = params.map { NSURLQueryItem(name:$0, value:$1)}
    var components = NSURLComponents()
    components.queryItems = queryItems
    return components.percentEncodedQuery ?? ""
}

//print(encodeParameters(["hello":"world","inject":"param1=value1&param2=value2"]))
//print(ourURLString)

//let url = NSURL(string: "http://www.stackoverflow.com")

//let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
//    print(NSString(data: data!, encoding: NSUTF8StringEncoding))
//}
//
//task.resume()


//let url = NSURL(string: "http://www.stackoverflow.com")
//let request = NSURLRequest(URL: url!)

//NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
    //print(NSString(data: data!, encoding: NSUTF8StringEncoding))
//}


let val = "\u{ae40}\u{c131}\u{d0dc}"
print(val)



//func tmdbURLFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
//    
//    let components = NSURLComponents()
//    components.scheme =  "http"
//    components.host = "api.themoviedb.org"
//    components.path = "/3" + (withPathExtension ?? "")
//    components.queryItems = [NSURLQueryItem]()
//    
//    for (key, value) in parameters {
//        let queryItem = NSURLQueryItem(name: key, value: "\(value)")
//        components.queryItems!.append(queryItem)
//    }
//    
//    return components.URL!
//}
//
//
//let methodParameters = [
//    "api_key": "12316a351a060d40e3793632edc8e41b"
//]
//
///* 2/3. Build the URL, Configure the request */
//print(tmdbURLFromParameters(methodParameters, withPathExtension: "/authentication/token/new"))
//
//let request = NSMutableURLRequest(URL: tmdbURLFromParameters(methodParameters, withPathExtension: "/authentication/token/new"))
//request.addValue("application/json", forHTTPHeaderField: "Accept")
//
//let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ (data, response, error) in
//    
// 
//    let parsedResult:AnyObject!
//
//    do {
//        parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
//    } catch {
//        print("error")
//        return
//    }
//    
//     print(parsedResult)
//}
//task.resume()


//let url = NSURL(string:"http://api.popong.com/v0.1/person/?assembly_id=19&api_key=test")
// var urlString = "http://api.popong.com/v0.1/bill/?per_page=200&api_key=test"



//urlString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())

//let url = NSURL(string:"http://api.popong.com/v0.1/party/?sort=logo&per_page=196&api_key=test")

//var urlString = "http://api.popong.com/v0.1/bill/search?q=데이터&s=김영환&api_key=test"
//let url = NSURL(dataRepresentation:urlString.dataUsingEncoding(NSUTF8StringEncoding)!, relativeToURL:nil)
//let url = NSURL(dataRepresentation:urlString.dataUsingEncoding(NSUTF8StringEncoding)!, relativeToURL:nil)

//let url = NSURL(string: urlString)

//var urlString = "http://api.popong.com/v0.2/people/search?assembly_id=19&api_key=test"

// var urlString =  "http://api.popong.com/v0.1/person/search?q=박&api_key=test"
var urlString = "http://api.popong.com/v0.1/bill/search?q=데이터&s=김영환&api_key=test"
// http://api.popong.com/v0.1/bill/search?q=데이터&s=김영환&api_key=test
let url = NSURL(dataRepresentation:urlString.dataUsingEncoding(NSUTF8StringEncoding)!, relativeToURL:nil)
//let url = NSURL(string:urlString)
print(url)
let request = NSURLRequest(URL:url)

let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ (data, response, error) in
    
 
    let parsedResult:AnyObject!

    do {
        guard let parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? NSDictionary else {
            print("error")
            return
        }
        print(parsedResult)
        guard let dictionaryArray = parsedResult.valueForKey("items") as? [[String:AnyObject]]
                //, let page = //parsedResult.valueForKey("next_page")  
            else {
            print("error")
            return
        }
    
        //print("page: \(page)")
        //print(dictionaryArray)
        for dict in dictionaryArray {
            print(dict["name"])
            //print(dict["document_url"])
            print(dict["sponsor"])
            //print(dict["assembly_id"])
        }
        
    
 //api_key=test&q=%EC%95%88%EC%B2%A0%EC%88%98
    } catch {
        print("error")
        return
    }
    
}
task.resume()




