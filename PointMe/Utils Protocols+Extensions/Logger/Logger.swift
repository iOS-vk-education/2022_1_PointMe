import Foundation


protocol SimpleLogger: AnyObject {
    static var nameClassLogger: String { get }
}

extension SimpleLogger {
    func log(message text: String) {
        let date = Date()
        let calendar = NSCalendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        print("\n[\(Self.nameClassLogger) - \(hour):\(minutes):\(seconds)] : \(text)")
    }
}
