import 'dart:async';
import 'package:apanabazar/Validation/CreateAddressValidation.dart';
import 'package:rxdart/rxdart.dart';



class Bloc extends Object with CreateAddressValidators implements BaseBloc {
  final _fullAddressController = BehaviorSubject<String>();
  final _additionalAddressController = BehaviorSubject<String>();
  final _pincodeController = BehaviorSubject<String>();

  Function(String) get fullAddressChanged => _fullAddressController.sink.add;
  Function(String) get additionalAddressChanged => _additionalAddressController.sink.add;
  Function(String) get pincodeChanged => _pincodeController.sink.add;


  //Another way
  // StreamSink<String> get emailChanged => _emailController.sink;
  // StreamSink<String> get passwordChanged => _passwordController.sink;

  Stream<String> get fullAddress => _fullAddressController.stream.transform(fullAddressValidator);
  Stream<String> get additionalAddress => _additionalAddressController.stream.transform(AdditionalAddressValidator);
  Stream<String> get pincode => _pincodeController.stream.transform(PincodeValidator);
      

  Stream<bool> get submitCheck =>
      
      Rx.combineLatest3(fullAddress, additionalAddress, pincode, (a, b, c) => true);

  submit() {
    
  }

  @override
  void dispose() {
    _fullAddressController?.close();
    _additionalAddressController?.close();
    _pincodeController?.close();
  }
}

abstract class BaseBloc {
  void dispose();
}
