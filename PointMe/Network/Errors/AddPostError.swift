import Foundation


enum AddPostError: Error {
    case invalidDataError
    case networkConnectionFailure
    case serverError
    case unknownError
}


extension AddPostError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidDataError:
            return NSLocalizedString(
                "Добавьте название, комментарий и оценку!",
                comment: ""
            )
        case .networkConnectionFailure:
            return NSLocalizedString(
                "Неудалось установить соединение с интернетом!",
                comment: ""
            )
        case .serverError:
            return NSLocalizedString(
                "Неудалось добавить пост!",
                comment: ""
            )
        case .unknownError:
            return NSLocalizedString(
                "Неизвестная ошибка!",
                comment: ""
            )
        }
    }
}
