import Foundation
import Firebase

final class SignInModel: SimpleLogger {
    static var nameClassLogger: String = "SignInModel"
    
    init() {}
    
    func signInUser(email: String?, password: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let email = email, let password = password else {
            completion(.failure(NSError()))
            return
        }
        
        guard isValidEmail(email: email) else {
            log(message: "Not valid email")
            completion(.failure(NSError()))
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            guard error == nil else {
                self?.log(message: "Error by login an user (\(String(describing: error)))")
                completion(.failure(error!))
                return
            }
            
            guard let _ = user else {
                self?.log(message: "Error by login an user")
                completion(.failure(error!))
                return
            }
            
            self?.log(message: "Success login an user")
            completion(.success(Void()))
            return
        }
    }
}

// MARK: - Validation value from registration fields

private extension SignInModel {
    private func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailPred.evaluate(with: email)
    }
}
