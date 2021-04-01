import Cocoa

enum CreditCardError: Error {
    case insufficientFunds (moneyNeed: Float)
    case frozenBalance
}

struct thing {
    var price: Float
}

class CreditCardOperation {
    let limit: Float = 30000
    var balance: Float = 0
    var cardIsBlocked = false
    
    func buySomethig(thing: thing) throws {
        guard cardIsBlocked != true else {
            throw CreditCardError.frozenBalance
        }
        guard thing.price <= (limit + self.balance) else {
            if balance < 0 {
                throw CreditCardError.insufficientFunds(moneyNeed: thing.price + limit + balance)
            } else {
                throw CreditCardError.insufficientFunds(moneyNeed: thing.price + limit - balance)
            }
        }
        
        balance = self.balance - thing.price
    }
    
    func depositeMoney (someMoney: Float) {
        balance = self.balance + someMoney
    }
    
    func printBalance() {
        print ("Баланс \(balance) р.")
    }
    
    func changeCardState(cardIsBlocked: Bool) {
        switch cardIsBlocked {
        case true:
            self.cardIsBlocked = true
        case false:
            self.cardIsBlocked = false
        }
    }
}

extension CreditCardError: CustomStringConvertible {
    var description: String {
        switch self {
        case .insufficientFunds(let moneyNeed): return "На вашей карте недостаточно средств для проведения данной операции. Ваш баланс: \(operation.balance) р., необходимо: \(moneyNeed) р."
        case .frozenBalance: return "Ваша карта заблокирована. Для уточнения информации обратитесь в банк."
        }
    }
}

let operation = CreditCardOperation()
do {
    try operation.buySomethig(thing: .init(price: 1000))
} catch let error as CreditCardError {
    print(error.description)
}
operation.printBalance()
operation.depositeMoney(someMoney: 110000)
operation.printBalance()
do {
    try operation.buySomethig(thing: .init(price: 12))
} catch let error as CreditCardError {
    print(error.description)
}
operation.printBalance()
do {
    try operation.buySomethig(thing: .init(price: 13))
} catch let error as CreditCardError {
    print(error.description)
}
operation.printBalance()

operation.changeCardState(cardIsBlocked: true)

do {
    try operation.buySomethig(thing: .init(price: 14))
} catch let error as CreditCardError {
    print(error.description)
}
