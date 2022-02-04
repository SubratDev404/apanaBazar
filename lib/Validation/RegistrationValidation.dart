import 'dart:async';

mixin RegistrationValidators{

  var nameValidator = StreamTransformer<String,String>.fromHandlers(
    handleData: (name,sink){
      if(name.length<3){
        sink.addError("Name is not valid");
      }
     
      else{
        
        sink.add(name);
      }
    }
  );

  var mobileValidator = StreamTransformer<String,String>.fromHandlers(
    handleData: (mobile,sink){
      if(mobile.length>9 && mobile.length==10){
        sink.add(mobile);
      }
     
      else{
        sink.addError("Mobile No. is not valid");
      }
    }
  );

  var emailValidator = StreamTransformer<String,String>.fromHandlers(
    handleData: (email,sink){
      if(email.contains("@")){
        sink.add(email);
      }
      else if(email.length>9)
      {
        sink.add(email);
      }
      else{
        sink.addError("Email is not valid");
      }
    }
  );

  var passwordValidator = StreamTransformer<String,String>.fromHandlers(
    handleData: (password,sink){
      if(password.length>4){
        sink.add(password);
      }else{
        sink.addError("Password length should be greater than 4 chars.");
      }
    }
  );

  var confirmPasswordValidator = StreamTransformer<String,String>.fromHandlers(
    handleData: (confirmPassword,sink){
      if(confirmPassword.length>4){
        sink.add(confirmPassword);
      }
      
      else{
        sink.addError("ConfirmPassword length should be greater than 4 chars.");
      }
    }
  );

}