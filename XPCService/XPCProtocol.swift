import Foundation

@objc protocol XPCServiceProtocol {
    func performBackgroundTask(with reply: @escaping (Bool) -> Void)
}
