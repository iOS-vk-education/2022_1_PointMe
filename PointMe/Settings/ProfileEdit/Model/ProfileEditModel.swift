import Foundation
import Firebase

final class ProfileEditModel {
    
    weak var output: ProfileEditViewControllerInput?
    
    private func changeAvatar(imageKey: String, imageData: Data, completion: @escaping () -> Void) {
        DatabaseManager.shared.setAvatar(imageKey: imageKey, imageData: imageData) { [weak self] result in
            switch result {
            case .failure(_):
                self?.output?.makeAlert(forTitleText: "Ошибка!", forBodyText: "Не удалось загрузить фотографию. Попробуйте позже")
            case .success():
                completion()
            }
        }
    }
    
    private func emailChange(email: String, completion: @escaping () -> Void) {
        DatabaseManager.shared.setEmail(email: email) { [weak self] result in
            switch result {
            case .failure(let error):
                let errCode = AuthErrorCode(rawValue: error._code)
                switch errCode {
                case .requiresRecentLogin:
                    self?.output?.makeAlert(forTitleText: "Внимание!", forBodyText: "Необходимо перезайти, чтобы изменить почту.")
                case .invalidEmail:
                    self?.output?.makeAlert(forTitleText: "Внимание!", forBodyText: "Неверно указана почта. Исправьте и попробуйте снова")
                default:
                    self?.output?.makeAlert(forTitleText: "Упс!", forBodyText: "Что-то пошло не так. Проверьте правильность ввода или перезайдите в аккаунт")
                }
            case .success():
                completion()
            }
        }
    }
    
    private func usernameChange(username: String, completion: @escaping () -> Void) {
        DatabaseManager.shared.setUsername(username: username) { [weak self] result in
            switch result {
            case .failure(_):
                self?.output?.makeAlert(forTitleText: "Ошибка!", forBodyText: "Не удалось изменить имя пользователя.")
            case .success():
                completion()
            }
        }
    }
}

// MARK: - ProfileEditViewControllerOutput

extension ProfileEditModel: ProfileEditViewControllerOutput {
    func changeInfo(username: String?, email: String?, avatar: Data?, avatarKey: String) {
        let group = DispatchGroup()
        if let strongUsername = username {
            group.enter()
            usernameChange(username: strongUsername) {
                group.leave()
            }
        }
        
        if let strongEmail = email {
            group.enter()
            emailChange(email: strongEmail) {
                group.leave()
            }
        }
        
        if let strongAvatar = avatar {
            group.enter()
            changeAvatar(imageKey: avatarKey, imageData: strongAvatar) {
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.output?.makeAlert(forTitleText: "Успешно!", forBodyText: "Удалось применить изменения.")
        }
    }
    
    func getInfo() {
        DatabaseManager.shared.getMyConfidentInfo() { [weak self] result in
            switch result {
            case .failure(_):
                self?.output?.makeAlert(forTitleText: "Ошибка!", forBodyText: "Не удалось получить данные о профиле")
            case .success(let accountInfo):
                guard let strongEmail = accountInfo.email else {
                    self?.output?.makeAlert(forTitleText: "Ошибка!", forBodyText: "Не удалось получить данные о профиле")
                    return
                }
                guard !accountInfo.userImageKey.isEmpty else {
                    self?.output?.fetchInfo(username: accountInfo.userName, email: strongEmail, image: nil, imageKey: "")
                    return
                }
                DatabaseManager.shared.getImage(destination: "avatars", imageKey: accountInfo.userImageKey) { result in
                    switch result {
                    case .failure(_):
                        self?.output?.makeAlert(forTitleText: "Ошибка!", forBodyText: "Не удалось получить данные о профиле")
                    case .success(let data):
                        self?.output?.fetchInfo(username: accountInfo.userName, email: strongEmail, image: data, imageKey: accountInfo.userImageKey)
                    }
                }
            }
            
        }
    }
}
