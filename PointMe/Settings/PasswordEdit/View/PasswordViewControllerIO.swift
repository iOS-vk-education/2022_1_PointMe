import Foundation

protocol PasswordEditViewControllerInput: AnyObject {
    func makeAlert(forTitleText: String, forBodyText: String)
    func fetchInfo(password: String)
}

protocol PasswordEditViewControllerOutput: AnyObject {
    func changeInfo(password: String)
    func getInfo()
}

