import Foundation
import Firebase


final class SignUpModel: SimpleLogger {
    static var nameClassLogger: String = "SignUpModel"
    
    init() {}
    
    public func signUpUser(email: String?, password: String?, username: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let email = email, let password = password, let username = username else {
            completion(.failure(NSError()))
            return
        }
        
        guard isValidEmail(email: email) else {
            log(message: "Not valid email")
            completion(.failure(NSError()))
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] user, error in
            guard error == nil else {
                self?.log(message: "Error by create an user (\(String(describing: error)))")
                completion(.failure(error!))
                return
            }
            
            guard let user = user else {
                self?.log(message: "Error by create an user")
                completion(.failure(error!))
                return
            }
            
            DatabaseManager.shared.addUser(
                userData: UserModel(
                    uid: user.user.uid,
                    email: email,
                    password: password,
                    username: username,
                    avatar: ""
                ),
                completion: {result in
                    switch result {
                    case .failure(let error):
                        self?.log(message: "Error create an user")
                        completion(.failure(error))
                        break
                    case .success:
                        self?.log(message: "Success create an user")
                        completion(.success(Void()))
                        break
                    }
                }
            )
            
            completion(.success(Void()))
            return
        }
    }
}

// MARK: - Validation value from registration fields

private extension SignUpModel {
    private func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailPred.evaluate(with: email)
    }
}

