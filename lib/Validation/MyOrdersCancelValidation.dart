import 'dart:async';

mixin MyOrdersCancelValidators{

  var causeValidator = StreamTransformer<String,String>.fromHandlers(
    handleData: (cause,sink){
      
      if(cause.length>5)
      {
        sink.add(cause);
      }
      else{
        sink.addError("cause is not valid");
      }
    }
  );

  var descriptionValidator = StreamTransformer<String,String>.fromHandlers(
    handleData: (description,sink){
      if(description.length>5){
        sink.add(description);
      }else{
        sink.addError("AdditionalAddress is not valid");
      }
    }
  );

  

}