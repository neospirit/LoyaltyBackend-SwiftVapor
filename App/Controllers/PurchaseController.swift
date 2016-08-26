import Vapor
import HTTP

final class PurchaseController: ResourceRepresentable {
    
    typealias Item = Purchase
    
    let drop: Droplet
    
    init(droplet: Droplet) {
        drop = droplet
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        return try Purchase.all().makeResponse()
    }
    
    func store(request: Request) throws -> ResponseRepresentable {
        guard
            let customerID = request.data["customer_id"].int,
            let amount = request.data["amount"].double
        else {
            throw Abort.badRequest
        }
        
        let voucherIDs = request.data["voucher_ids"].array
        
        let purchase = try LoyaltyController.makePurchase(customerID: Node(customerID), totalAmount: amount, voucherIDs: voucherIDs)
        
        if request.accept.prefers("html") {
            return Response(redirect: "/customers/\(customerID)")
        } else {
            return purchase
        }
    }
    
    func show(request: Request, item purchase: Purchase) throws -> ResponseRepresentable {
        return purchase
    }
    
    func update(request: Request, item customer: Purchase) throws -> ResponseRepresentable {
        throw Abort.badRequest
    }
    
    func destroy(request: Request, item purchase: Purchase) throws -> ResponseRepresentable {
        throw Abort.badRequest
    }
    
    func makeResource() -> Resource<Purchase> {
        return Resource(
            index: index,
            store: store,
            show: show,
            replace: update,
            destroy: destroy
        )
    }
    
}
