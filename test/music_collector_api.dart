import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<TestFunctions>()])

class TestFunctions {
  void onPayErrorMessage(String message) {}

  void onPayException(Exception e) {}
  void onPayCancel(bool fromUser) {}
  void onComplete() {}
}
