import Foundation
import Firebase

final class PasswordEditModel {
    weak var output: PasswordEditViewControllerInput?
}
// MARK: - PasswordEditViewControllerOutput

extension PasswordEditModel: PasswordEditViewControllerOutput {
    func changeInfo(password: String) {
        DatabaseManager.shared.setPassword(password: password) { [weak self] result in
            switch result {
            case .failure(_):
                self?.output?.makeAlert(forTitleText: "Ошибка!", forBodyText: "Не удалось сменить пароль. Проверьте правильность ввода или попробуйте перезайти в аккаунт.")
            case .success():
                self?.output?.fetchInfo(password: password)
                self?.output?.makeAlert(forTitleText: "Успех!", forBodyText: "Пароль был успешно изменен.")
            }
        }
    }
    
    func getInfo() {
        DatabaseManager.shared.getMyConfidentInfo() { [weak self] result in
            switch result {
            case .failure(_):
                self?.output?.makeAlert(forTitleText: "Ошибка!", forBodyText: "Не удалось получить данные")
            case .success(let accountInfo):
                guard let strongPassword = accountInfo.password else { return }
                self?.output?.fetchInfo(password: strongPassword)
            }
        }
    }
}
