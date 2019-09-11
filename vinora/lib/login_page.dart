import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';
import 'auth_provider.dart';
import 'package:toast/toast.dart';
import 'package:connectivity/connectivity.dart';
import 'data/food_data.dart';
import 'package:progress_dialog/progress_dialog.dart';
class LoginPage extends StatefulWidget{
  const LoginPage({this.onSignedIn});
  final VoidCallback onSignedIn;
  @override
  State<StatefulWidget> createState() =>new _LoginPageState();
  }
  
  enum FormType{
    login,
    register
  }
  
  class _LoginPageState extends State<LoginPage>
  {
    String _email ,_password,_name,_mobile,_address;
    final formKey=new GlobalKey<FormState>();
    FormType _formType=FormType.login;
    ProgressDialog pr;
    
    @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Scaffold(
        
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView ( child: Stack(
          children: <Widget>[
            new Container(padding:EdgeInsets.all(11.0),
          child: new Form(
            key: formKey,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              
              children:logo()+slogan()+buidInputs()+buildSubmitButtons(),
                                            ),
                                          ),
                                        ),
          ],
        ),)
                                      );
                                    }
                  List<Widget> buidInputs(){
                    if(_formType==FormType.login)
                  {
                    return [Padding(
                  padding: const EdgeInsets.all(10),
                  child:new TextFormField(
                  decoration: new InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Email', 
                  ),
                  validator: (value)=>value.isEmpty?"Email can't be Empty":null ,
                  onSaved: (value)=>_email=value,
                ),
                
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child:new TextFormField(
                  decoration: new InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                     
                  ),
                  validator: (value)=>value.isEmpty?"Password can't be Empty":null ,
                  obscureText: true,
                  onSaved: (value)=>_password=value,
                ),
                
                ),
                ];
                  }else{
                    return [
                      Padding(
                  padding: const EdgeInsets.all(10),
                  child:new TextFormField(
                  decoration: new InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Name', 
                  ),
                  validator: (value)=>value.isEmpty?"Name can't be Empty":null ,
                  onSaved: (value)=>_name=value,
                ),
                
                ),
                      Padding(
                  padding: const EdgeInsets.all(10),
                  child:new TextFormField(
                  decoration: new InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Email', 
                  ),
                  validator: (value)=>value.isEmpty?"Email can't be Empty":null ,
                  onSaved: (value)=>_email=value,
                ),
                
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child:new TextFormField(
                  decoration: new InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Mobile Number', 
                  ),
                  validator: (value)=>value.isEmpty?"Mobile can't be Empty":null ,
                  onSaved: (value)=>_mobile=value,
                ),
                
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child:new TextFormField(
                  decoration: new InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Address', 
                  ),
                  validator: (value)=>value.isEmpty?"Address can't be Empty":null ,
                  onSaved: (value)=>_address=value,
                ),
                
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child:new TextFormField(
                  decoration: new InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password', 
                  ),
                  validator: (value)=>value.isEmpty?"Password can't be Empty":null ,
                  obscureText: true,
                  onSaved: (value)=>_password=value,
                ),
                
                ),
                ];
                  }
                  }
  
                List<Widget> buildSubmitButtons(){
                  if(_formType==FormType.login)
                  {
                      return [SizedBox(
                  width: 150,
                  height: 45,
                  child:RaisedButton (               
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  child: new Text("Login",
                  style: new TextStyle(fontSize: 20.0,color: Colors.black,)),
                  color: Theme.of(context).accentColor,
                  elevation: 4.0,   
                  splashColor: Colors.blueGrey,
                  onPressed: validateAndSubmit,
                                ),
                
                                ),
                  new FlatButton(
                  child: new Text('Create an account',style: new TextStyle(fontSize: 14.0),),
                  onPressed: moveToRegister,
                                )];
                  }else{
                    return [SizedBox(
                  width: 150,
                  height: 45,
                  child:RaisedButton (               
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  child: new Text("Register",
                  style: new TextStyle(fontSize: 20.0,color: Colors.black,)),
                  color: Theme.of(context).accentColor,
                  elevation: 4.0,   
                  splashColor: Colors.blueGrey,
                  onPressed: validateAndSubmit,
                                ),
                
                                ),
                  new FlatButton(
                  child: new Text('Have an Account ? Login',style: new TextStyle(fontSize: 14.0),),
                  onPressed: moveToLogin,
                                                )];
                                  }
                                  
                                }
                                                  
                                bool validateAndSave() {
                                  final form =formKey.currentState;
                                  if(form.validate()){
                                    form.save();
                                    return true;
                                  }else{
                                    return false;
                                  }
                                                      
                                    }
                                  
                                    Future<FirebaseUser> validateAndSubmit() async {
                                      var connectivityResult = await (Connectivity().checkConnectivity());
                                      
                                      if(validateAndSave()){
                                        if (connectivityResult == ConnectivityResult.mobile||connectivityResult == ConnectivityResult.wifi) {
                                          try{
                                          final BaseAuth auth = AuthProvider.of(context).auth;
                                          if(_formType==FormType.login){
                                            pr = new ProgressDialog(context,ProgressDialogType.Normal);
                                            pr.setMessage('Please wait...');
                                            pr.show();
                                             final String userId = await auth.signInWithEmailAndPassword(_email, _password);
                                             pr.hide();
                                             Load();
                                          }else{
                                            pr = new ProgressDialog(context,ProgressDialogType.Normal);
                                            pr.setMessage('Please wait...');
                                            pr.show();
                                             await auth.createUserWithEmailAndPassword(_name,_email, _password,_mobile,_address);
                                             pr.hide();
                                             Load();
                                            Toast.show("Registrasion Successfull", context, duration: 1, gravity:  Toast.BOTTOM);
                                            
                                          }
                                          widget.onSignedIn();
                                     
                                      }catch(e){
                                        Toast.show("Fail\n"+e.toString(), context, duration: 4, gravity:  Toast.BOTTOM,backgroundColor: Colors.red);
                                      }
                                      } else{
                                        Toast.show("Please Check The Internet Connection", context, duration: 4, gravity:  Toast.BOTTOM,backgroundColor: Colors.red);
                                      }
                                        
                                    }
                                  }
                                
                                
                                
                  void moveToRegister() {
                    formKey.currentState.reset();
                    setState(() {
                      _formType=FormType.register;
                    });
                                      
                                    
                  }
                
                  void moveToLogin() {
                    formKey.currentState.reset();
                    setState(() {                      
                    _formType=FormType.login;
                  });
  }

  
                   List<Widget> logo() {
                     AssetImage assetImage=AssetImage('images/logo1.png');
                     Image image=Image(image:assetImage,width: 150,height: 150);
                 return[                  
                    image
                   ];
               }

               List<Widget> slogan() {
                     return[
                       Text("The Next Level Of Ordering ...",textScaleFactor: 1.2, style: new TextStyle(fontWeight: FontWeight.bold,),)
                     ];
               }
                 
  
}