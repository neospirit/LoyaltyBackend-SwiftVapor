import Foundation
import Vapor
import Fluent
import HTTP

final class VoucherConfig: Model {
    
    static var entity: String = "voucher_config"
    
    static var `default` = VoucherConfig(purchaseAmount: 100.0, voucherValue: 10.0, voucherDuration: 600.0)
    
    // MARK: - Properties
    
    var id: Node?
    
    var purchaseAmount: Double
    var voucherValue: Double
    var voucherDuration: Double
    
    // MARK: - Init
    
    init(purchaseAmount: Double, voucherValue: Double, voucherDuration: Double) {
        self.purchaseAmount = purchaseAmount
        self.voucherValue = voucherValue
        self.voucherDuration = voucherDuration
    }
    
    // MARK: - NodeConvertible
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        purchaseAmount = try node.extract("purchase_amount")
        voucherValue = try node.extract("voucher_value")
        voucherDuration = try node.extract("voucher_duration")
    }
    
    func makeNode() throws -> Node {
        return try Node(node: [
            "id": id,
            "purchase_amount": purchaseAmount,
            "voucher_value": voucherValue,
            "voucher_duration": voucherDuration
        ])
    }
    
    // MARK: - Preparation
    
    static func prepare(_ database: Fluent.Database) throws {
        try database.create(entity) { config in
            config.id()
            config.double("purchase_amount")
            config.double("voucher_value")
            config.double("voucher_duration")
        }
        
        var defaultConfig = VoucherConfig.`default`
        try defaultConfig.save()
    }
    
    static func revert(_ database: Fluent.Database) throws {
        try database.delete(entity)
    }
    
    // MARK: - Override
    
    public func makeJSON() -> JSON {
        return try! JSON([
            "purchase_amount": purchaseAmount,
            "voucher_value": voucherValue,
            "voucher_duration": voucherDuration
        ])
    }
    
}
