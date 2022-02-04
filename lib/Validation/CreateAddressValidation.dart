import 'dart:async';

mixin CreateAddressValidators{

  var fullAddressValidator = StreamTransformer<String,String>.fromHandlers(
    handleData: (fullAddres,sink){
      
      if(fullAddres.length>3)
      {
        sink.add(fullAddres);
      }
      else{
        sink.addError("fullAddres is not valid");
      }
    }
  );

  var AdditionalAddressValidator = StreamTransformer<String,String>.fromHandlers(
    handleData: (AdditionalAddress,sink){
      if(AdditionalAddress.length>4){
        sink.add(AdditionalAddress);
      }else{
        sink.addError("AdditionalAddress is not valid");
      }
    }
  );

  var PincodeValidator = StreamTransformer<String,String>.fromHandlers(
    handleData: (Pincode,sink){
      if(Pincode.length==6){
        sink.add(Pincode);
      }else{
        sink.addError("AdditionalAddress is not valid");
      }
    }
  );

}