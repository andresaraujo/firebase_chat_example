import 'dart:html';
import 'package:firebase/firebase.dart';
import 'package:uuid/uuid.dart';

const BASE_FB = "https://supertinyrest.firebaseio.com/test";


final Firebase fb = new Firebase(BASE_FB);

final uuid = new Uuid().v4();

void main() {
  var list = querySelector("#items_id");
  
  fb.onValue.listen((e) {
    var ss = e.snapshot;
    list.children.clear();
    ss.forEach((data) {
      print(data.val());
      Map m = data.val();
      var section = new Element.section()..classes.add("card");
      
      var user = m['name'] == uuid ? "You": m['name'];
      section.children.add(new Element.tag('h2')..text = "$user :");
      section.children.add(new Element.div()..text = "${m['msg']}");
      list.children.add(section);
    });
    querySelector("#msg_id")
            ..focus()
            ..onKeyDown.listen(send)
            ..scrollIntoView();
  });
}

void send(KeyboardEvent e){
  if(e.keyCode == KeyCode.ENTER){
    InputElement msg = querySelector("#msg_id");
    if( msg.value.isNotEmpty ){
      fb.push().set({'name':  uuid, 'msg':  msg.value });
      querySelector("#msg_id")..value=""..focus();
    }
      
  }
}

