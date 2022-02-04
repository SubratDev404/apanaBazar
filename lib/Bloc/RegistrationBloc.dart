
import 'package:apanabazar/Validation/RegistrationValidation.dart';
import 'package:rxdart/rxdart.dart';

class Bloc extends Object with RegistrationValidators implements BaseBloc {
  final _nameController = BehaviorSubject<String>();
  final _mobileController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _confirmPasswordController = BehaviorSubject<String>();

  Function(String) get nameChanged => _nameController.sink.add;
  Function(String) get mobileChanged => _mobileController.sink.add;
  Function(String) get emailChanged => _emailController.sink.add;
  Function(String) get passwordChanged => _passwordController.sink.add;
  Function(String) get confirmPasswordChanged => _confirmPasswordController.sink.add;

  //Another way
  // StreamSink<String> get emailChanged => _emailController.sink;
  // StreamSink<String> get passwordChanged => _passwordController.sink;
  
  Stream<String> get name => _nameController.stream.transform(nameValidator);
  Stream<String> get mobile => _mobileController.stream.transform(mobileValidator);
  Stream<String> get email => _emailController.stream.transform(emailValidator);
  Stream<String> get password =>
      _passwordController.stream.transform(passwordValidator);
  Stream<String> get confirmPassword =>
      _confirmPasswordController.stream.transform(confirmPasswordValidator);

  // Stream<bool> get submitCheck =>
  //     Rx.combineLatest2(email, password, (e, p) => true);
    Stream<bool> get submitCheck =>
      Rx.combineLatest5(name, mobile, email, password, confirmPassword, (a, b, c, d, e) => true);

  submit() {
    print(email.toString());
  }

  @override
  void dispose() {
    _nameController?.close();
    _mobileController?.close();
    _emailController?.close();
    _passwordController?.close();
    _confirmPasswordController?.close();
  }
}

abstract class BaseBloc {
  void dispose();
}
