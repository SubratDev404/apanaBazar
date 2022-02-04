import 'dart:async';
import 'package:apanabazar/Validation/MyOrdersCancelValidation.dart';
import 'package:rxdart/rxdart.dart';




class Bloc extends Object with MyOrdersCancelValidators implements BaseBloc {
  final _causeController = BehaviorSubject<String>();
  final _descriptionController = BehaviorSubject<String>();
 

  Function(String) get causeChanged => _causeController.sink.add;
  Function(String) get descriptionChanged => _descriptionController.sink.add;
 

  //Another way
  // StreamSink<String> get emailChanged => _emailController.sink;
  // StreamSink<String> get passwordChanged => _passwordController.sink;

  Stream<String> get cause => _causeController.stream.transform(causeValidator);
  Stream<String> get description => _descriptionController.stream.transform(descriptionValidator);
  
      

  Stream<bool> get submitCheck =>
      
      Rx.combineLatest2(cause, description, (a, b) => true);

  submit() {
    
  }

  @override
  void dispose() {
    _causeController?.close();
    _descriptionController?.close();
    
  }
}

abstract class BaseBloc {
  void dispose();
}
