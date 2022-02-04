// class ItemListModel{
//   bool status;
//   List data;

//   ItemListModel( 
//       {this.status, this.data}
//   );

//   factory ItemListModel.fromJson(Map<String, dynamic> json) {
//     return ItemListModel(
//     status:json['status'] == null ? null :json['status'] as bool,
//     data:json['items'] == null ? null :json['items'] as List,
//     );
    
//   }

//   Map<String,dynamic> toJson()=>{
//      "status":status == null ? null: status,
//      "items":data == null ? null: data,
//   };
  
// }

// class Items{

//   int id,itemvariantid,vendorid,saleprice,trackby,openingstock,inwardstock,
//   outwardstock,inventoryactive,itemid,unitid,quantity,mrp,productid,brandid,
//   taxrateid,taxratevalue,islive,iscustome,itemactive;

//   String discount,dimension,image,itemname,taxratename,itemcode;

//   List variantdetails;

//   Items(
//     {
//       this.id,this.brandid,this.dimension,this.discount,this.image,this.inventoryactive,this.inwardstock,this.iscustome,this.islive,
//       this.itemactive,this.itemcode,this.itemid,this.itemname,this.itemvariantid,this.mrp,this.openingstock,this.outwardstock,
//       this.productid,this.quantity,this.saleprice,this.taxrateid,this.taxratename,this.taxratevalue,this.trackby,this.unitid,
//       this.variantdetails,this.vendorid
//     }
//   );

//   factory  Items.fromJson(Map<String,dynamic> json){
//     return Items(
//       id:json['id'] == null ? null :json['id'],
//       itemvariantid:json['itemvariantid'] == null ? null :json['itemvariantid'],
//       vendorid:json['vendorid'] == null ? null :json['vendorid'],
//       saleprice:json['saleprice'] == null ? null :json['saleprice'],
//       trackby:json['trackby'] == null ? null :json['trackby'],
//       openingstock:json['openingstock'] == null ? null :json['openingstock'],
//       inwardstock:json['inwardstock'] == null ? null :json['inwardstock'],
//       outwardstock:json['outwardstock'] == null ? null :json['outwardstock'],
//       inventoryactive:json['inventoryactive'] == null ? null :json['inventoryactive'],
//       itemid:json['itemid'] == null ? null :json['itemid'],
//       unitid:json['unitid'] == null ? null :json['unitid'],
//       quantity:json['quantity'] == null ? null :json['quantity'],
//       mrp:json['mrp'] == null ? null :json['mrp'],
//       productid:json['productid'] == null ? null :json['productid'],
//       brandid:json['brandid'] == null ? null :json['brandid'],
//       taxrateid:json['taxrateid'] == null ? null :json['taxrateid'],
//       taxratevalue:json['taxratevalue'] == null ? null :json['taxratevalue'],
//       islive:json['islive'] == null ? null :json['islive'],
//       iscustome:json['iscustome'] == null ? null :json['iscustome'],
//       itemactive:json['itemactive'] == null ? null :json['itemactive'],
//       discount:json['discount'] == null ? null :json['discount'],
//       dimension:json['dimension'] == null ? null :json['dimension'],
//       image:json['image'] == null ? null :json['image'],
//       itemname:json['itemname'] == null ? null :json['itemname'],
//       taxratename:json['taxratename'] == null ? null :json['taxratename'],
//       itemcode:json['itemcode'] == null ? null :json['itemcode'],
//       variantdetails:(json['variantdetails'] == null ? null :json['variantdetails'] as List).map((map) => ('$map')).toList(),
//     );
//  }

//   Map<String,dynamic> toJson()=>{
//      "id":id == null ? null: id,
//      "itemvariantid":itemvariantid == null ? null: itemvariantid,
//      "vendorid":vendorid == null ? null: vendorid,
//      "saleprice":saleprice == null ? null: saleprice,
//      "trackby":trackby == null ? null: trackby,
//      "openingstock":openingstock == null ? null: openingstock,
//      "inwardstock":inwardstock == null ? null: inwardstock,
//      "outwardstock":outwardstock == null ? null: outwardstock,
//      "inventoryactive":inventoryactive == null ? null: inventoryactive,
//      "itemid":itemid == null ? null: itemid,
//      "unitid":unitid == null ? null: unitid,
//      "quantity":quantity == null ? null: quantity,
//      "mrp":mrp == null ? null: mrp,
//      "productid":productid == null ? null: productid,
//      "brandid":brandid == null ? null: brandid,
//      "taxrateid":taxrateid == null ? null: taxrateid,
//      "taxratevalue":taxratevalue == null ? null: taxratevalue,
//      "islive":islive == null ? null: islive,
//      "iscustome":iscustome == null ? null: iscustome,
//      "itemactive":itemactive == null ? null: itemactive,
//      "discount":discount == null ? null: discount,
//      "dimension":dimension == null ? null: dimension,
//      "image":image == null ? null: image,
//      "itemname":itemname == null ? null: itemname,
//      "taxratename":taxratename == null ? null: taxratename,
//      "itemcode":itemcode == null ? null: itemcode,
//      "variantdetails":variantdetails == null ? null:variantdetails,
    
//   };


// }

// class Variantdetails {

//   List variantdetails2;
//   Variantdetails(
//     {
//        this.variantdetails2
//     }
//   );

//   factory Variantdetails.fromJson(Map<String,dynamic> json){
//     return Variantdetails(
//       variantdetails2:(json['variantdetails'] == null ? null :json['variantdetails'] as List).map((map) => ('$map')).toList(),
//     );
//   }

//   Map<String,dynamic> toJson()=>{
    
//      "variantdetails":variantdetails2 == null ? null:variantdetails2,
//   };
  
// }

// class Variantdetails2{

//   String id,variantname,variantvalue;

//   Variantdetails2(
//     {
//       this.id,this.variantname,this.variantvalue
//     }
//   );

//   factory Variantdetails2.fromJson(Map<String, dynamic> json) {
//     return Variantdetails2(
//       id:json['id'] == null ? null :json['id'],
//       variantname:json['variantname'] == null ? null :json['variantname'],
//       variantvalue:json['variantvalue'] == null ? null :json['variantvalue'],
//     );
    
//   }

//   Map<String,dynamic> toJson()=>{
//     "id":id == null ? null: id,
//      "variantname":variantname == null ? null: variantname,
//      "variantvalue":variantvalue == null ? null: variantvalue,
//   };

// }


// To parse this JSON data, do
//
//     final itemListModel = itemListModelFromJson(jsonString);

import 'dart:convert';

ItemListModel itemListModelFromJson(String str) => ItemListModel.fromJson(json.decode(str));

String itemListModelToJson(ItemListModel data) => json.encode(data.toJson());

class ItemListModel {
    ItemListModel({
        this.status,
        this.items,
    });

    bool status;
    List<Item> items;

    factory ItemListModel.fromJson(Map<String, dynamic> json) => ItemListModel(
        status: json["status"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
    };
}

class Item {
    Item({
        this.id,
        this.itemvariantid,
        this.vendorid,
        this.saleprice,
        this.discount,
        this.trackby,
        this.openingstock,
        this.inwardstock,
        this.outwardstock,
        this.inventoryactive,
        this.itemid,
        this.variantdetails,
        this.unitid,
        this.quantity,
        this.mrp,
        this.dimension,
        this.image,
        this.productid,
        this.brandid,
        this.itemname,
        this.taxrateid,
        this.taxratename,
        this.taxratevalue,
        this.itemcode,
        this.islive,
        this.iscustome,
        this.itemactive,
    });

    String id;
    String itemvariantid;
    String vendorid;
    String saleprice;
    String discount;
    String trackby;
    String openingstock;
    String inwardstock;
    String outwardstock;
    String inventoryactive;
    String itemid;
    List<Variantdetail> variantdetails;
    String unitid;
    String quantity;
    String mrp;
    String dimension;
    String image;
    String productid;
    String brandid;
    String itemname;
    String taxrateid;
    String taxratename;
    String taxratevalue;
    String itemcode;
    String islive;
    String iscustome;
    String itemactive;

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        itemvariantid: json["itemvariantid"],
        vendorid: json["vendorid"],
        saleprice: json["saleprice"],
        discount: json["discount"],
        trackby: json["trackby"],
        openingstock: json["openingstock"],
        inwardstock: json["inwardstock"],
        outwardstock: json["outwardstock"],
        inventoryactive: json["inventoryactive"],
        itemid: json["itemid"],
        variantdetails: List<Variantdetail>.from(json["variantdetails"].map((x) => Variantdetail.fromJson(x))),
        unitid: json["unitid"],
        quantity: json["quantity"],
        mrp: json["mrp"],
        dimension: json["dimension"],
        image: json["image"],
        productid: json["productid"],
        brandid: json["brandid"],
        itemname: json["itemname"],
        taxrateid: json["taxrateid"],
        taxratename: json["taxratename"],
        taxratevalue: json["taxratevalue"],
        itemcode: json["itemcode"],
        islive: json["islive"],
        iscustome: json["iscustome"],
        itemactive: json["itemactive"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "itemvariantid": itemvariantid,
        "vendorid": vendorid,
        "saleprice": saleprice,
        "discount": discount,
        "trackby": trackby,
        "openingstock": openingstock,
        "inwardstock": inwardstock,
        "outwardstock": outwardstock,
        "inventoryactive": inventoryactive,
        "itemid": itemid,
        "variantdetails": List<dynamic>.from(variantdetails.map((x) => x.toJson())),
        "unitid": unitid,
        "quantity": quantity,
        "mrp": mrp,
        "dimension": dimension,
        "image": image,
        "productid": productid,
        "brandid": brandid,
        "itemname": itemname,
        "taxrateid": taxrateid,
        "taxratename": taxratename,
        "taxratevalue": taxratevalue,
        "itemcode": itemcode,
        "islive": islive,
        "iscustome": iscustome,
        "itemactive": itemactive,
    };
}

class Variantdetail {
    Variantdetail({
        this.id,
        this.variantname,
        this.variantvalue,
    });

    String id;
    String variantname;
    String variantvalue;

    factory Variantdetail.fromJson(Map<String, dynamic> json) => Variantdetail(
        id: json["id"],
        variantname: json["variantname"],
        variantvalue: json["variantvalue"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "variantname": variantname,
        "variantvalue": variantvalue,
    };
}
