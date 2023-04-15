import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ChatScreen extends StatefulWidget {
  static const String screenRoute='chat_screen';
  const ChatScreen ({Key? key}) : super(key: key);

  @override
  _ChatScreen createState() => _ChatScreen();
}

class _ChatScreen extends State<ChatScreen> {
  final _firestore=FirebaseFirestore.instance;
  final _auth=FirebaseAuth.instance;
  late User signdInUser;// will give a email
  String? messagetext;// will give a message
  @override
  void initState() {
    super.initState();
    getcurrentuser();
  }
  void getcurrentuser(){
    try{
    final user=_auth.currentUser;
    if (user != null){
      signdInUser=user;
      print(signdInUser.email);
    }}
        catch(e)
    {
      print(e);
    }
  }
  //void getMessages() async{
   //final messages= await _firestore.collection('messages').get();
   //for(var message in messages.docs ){
     //print(message.data());
   //}
  //}
  void messagesstream() async{
    await for (var snapshot in _firestore.collection('messages').snapshots()){
      for(var message in snapshot.docs){
        print(message.data());
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        title: Row(
         children: [
           Image.asset('images/WhatsApp Image 2023-03-29 at 5.23.38 PM.jpeg',height: 30,),
          SizedBox(width: 10,),
           Text('AskMe'),
         ],
        ),
        actions: [
          IconButton(
              onPressed: (){
                //add here logout function
              //_auth.signOut();
              //Navigator.pop(context);
                messagesstream();
              },
              icon: Icon(Icons.download))
        ],
      ),
    body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.orange,
                  width: 2,
                )
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child:TextField(
               //   keyboardType: TextInputType.none,
                  onChanged: (value){
                    messagetext=value;
                  },
                  decoration: InputDecoration(

                    contentPadding: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 20,
                    ),
                    hintText:'write your message here...',
                    border: InputBorder.none,
                    hintStyle:TextStyle(
                      fontSize: 17,fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ),
                TextButton(onPressed: (){
                _firestore.collection('messages').add({
                  'text':messagetext,
                  'sender':signdInUser.email,
                });
                }, child: Text(
                  'send',style: TextStyle(
                  color: Colors.blue[800],fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }
}
