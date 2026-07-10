import Foundation

class XPCHelper: NSObject, XPCServiceProtocol {
    func performBackgroundTask(with reply: @escaping (Bool) -> Void) {
        print("XPC Helper 执行任务")
        reply(true)
    }
}
