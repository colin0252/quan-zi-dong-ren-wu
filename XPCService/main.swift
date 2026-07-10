import Foundation

let delegate = XPCHelper()
let listener = NSXPCListener.service()
listener.delegate = delegate
listener.resume()
