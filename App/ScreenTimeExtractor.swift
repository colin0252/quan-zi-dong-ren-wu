import ApplicationServices
import Cocoa        // macOS 示例，iOS 需替换为私有 AX API
import Foundation

class ScreenTimeExtractor {

    static func extractWatchTime(from bundleIdentifier: String) -> String? {
        guard let app = NSWorkspace.shared.runningApplications.first(where: {
            $0.bundleIdentifier == bundleIdentifier
        }) else {
            print("⚠️ 目标应用未运行")
            return nil
        }
        let appElement = AXUIElementCreateApplication(app.processIdentifier)

        var timeValue: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(appElement,
                                                    kAXWindowsAttribute as CFString,
                                                    &timeValue)
        guard result == .success, let windows = timeValue as? [AXUIElement] else {
            return nil
        }

        for window in windows {
            if let label = findDurationLabel(in: window) {
                return label
            }
        }
        return nil
    }

    private static func findDurationLabel(in element: AXUIElement) -> String? {
        var desc: CFTypeRef?
        AXUIElementCopyAttributeValue(element, kAXDescriptionAttribute as CFString, &desc)

        if let descStr = desc as? String,
           (descStr.contains("时长") || matchesTimePattern(descStr)) {
            return descStr
        }

        var children: CFTypeRef?
        AXUIElementCopyAttributeValue(element, kAXChildrenAttribute as CFString, &children)
        if let childrenArr = children as? [AXUIElement] {
            for child in childrenArr {
                if let found = findDurationLabel(in: child) {
                    return found
                }
            }
        }
        return nil
    }

    private static func matchesTimePattern(_ text: String) -> Bool {
        let pattern = #"^\d{1,2}:\d{2}(:\d{2})?$"#
        return text.range(of: pattern, options: .regularExpression) != nil
    }
}
