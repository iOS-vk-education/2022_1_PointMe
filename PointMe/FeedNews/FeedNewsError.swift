import Foundation


enum FeedNewsError: Error {
    case loadDataError
}


extension FeedNewsError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .loadDataError:
            return NSLocalizedString(
                "Ошибка при загрузке данных!",
                comment: ""
            )
        }
    }
}
