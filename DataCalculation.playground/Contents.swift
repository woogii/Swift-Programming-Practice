//: Playground - noun: a place where people can play

import UIKit

let formatter = DateComponentsFormatter()
formatter.unitsStyle = .full
formatter.includesApproximationPhrase = true
formatter.includesTimeRemainingPhrase = true
formatter.allowedUnits = [.minute]

// Use the configured formatter to generate the string.
let outputString = formatter.string(from: -300)

let now = Date()
let pastDate = Date(timeIntervalSinceNow: -60 * 60 * 25 * 8)



extension Date {
  
  func timeAgoDisplay()->String {
    let secondsAgo = Int(Date().timeIntervalSince(self))
    
    let minute = 60
    let hour = 60 * minute
    let day = 24 * hour
    let week = 7 * day
  
    if secondsAgo < minute {
      return "\(secondsAgo) seconds ago"
    } else if secondsAgo < hour {
      return "\(secondsAgo/minute) minutes ago"
    } else if secondsAgo < day {
      return "\(secondsAgo/hour) hours ago"
    } else if secondsAgo < week {
      return "\(secondsAgo/day) days ago"
    }
    
    return "\(secondsAgo/60/60/24/7) weeks ago"
  }
}

pastDate.timeAgoDisplay()
