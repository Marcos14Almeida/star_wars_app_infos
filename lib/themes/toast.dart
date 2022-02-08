import 'package:fluttertoast/fluttertoast.dart';

void customToast(String message){
  Fluttertoast.showToast(msg: message,toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.TOP);
}