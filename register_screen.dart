import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  bool _showSpinner = false;

  String email;
  String password;

  PageController pageController;
  TextEditingController _emailEditingController;
  TextEditingController _passwordEditingController;

  @override
  void initState() {
    pageController = PageController();
    _emailEditingController = TextEditingController();
    _passwordEditingController = TextEditingController();
    super.initState();
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(//use any image for background),
                    fit: BoxFit.fill)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ), //background
          Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  width: double.maxFinite,
                  //height: 100,
                ),
              ),
              Expanded(
                //white box elements
                flex: 4,
                child: Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                    color: Colors.white.withOpacity(0.7),
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 90,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 203,
                          color: Colors.transparent,
                          child: PageView(
                            controller: pageController,
                            children: <Widget>[
                              Pages(
                                subject: "Email",
                                description: "It will used for logging in",
                                validator: emailValidator,
                                fieldLabelText: "Email",
                                fieldHintText: "Enter an active email ID",
                                obscureText: false,
                                textEditingController: _emailEditingController,
                                buttonFirstChild: SizedBox(
                                  width: 10,
                                ),
                                buttonSecondChild:
                                    getButton("Next", Icons.arrow_forward, () {
                                  email = _emailEditingController.text;
                                  pageController.nextPage(
                                      duration: Duration(milliseconds: 200),
                                      curve: Curves.decelerate);
                                }),
                              ),
                              ModalProgressHUD(
                                inAsyncCall: _showSpinner,
                                child: Pages(
                                  subject: "Password",
                                  description: "It will used for logging in",
                                  validator: passwordValidator,
                                  fieldLabelText: "Password",
                                  fieldHintText:
                                      "Enter a password only for this app",
                                  obscureText: true,
                                  textEditingController:
                                      _passwordEditingController,
                                  buttonFirstChild:
                                      getButton("Back", Icons.arrow_back, () {
                                    pageController.previousPage(
                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.decelerate);
                                  }),
                                  buttonSecondChild: getButton(
                                      "Register", Icons.arrow_forward, () async {
                                    password = _passwordEditingController.text;
                                    setState(() {
                                      _showSpinner = true;
                                    });
                                    final snackBar = SnackBar(
                                      content: Text('User already exists'),
                                    );

                                    // Find the Scaffold in the widget tree and use
                                    // it to show a SnackBar.

                                    try {
                                      final FirebaseUser newUser = (await _auth.createUserWithEmailAndPassword(
                                        email: email,
                                        password: password,
                                      ).whenComplete((){_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Registered Successfully")));}))
                                          .user;
                                      if (newUser == null) {
                                        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Registered Successfully"),));

                                      }
                                      setState(() {
                                        FocusScope.of(context)
                                            .requestFocus(new FocusNode());
                                        _showSpinner = false;
                                      });
                                    } catch (PlatformException) {
                                      _scaffoldKey.currentState.showSnackBar(
                                      snackBar);

                                      setState(() {
                                        FocusScope.of(context)
                                            .requestFocus(new FocusNode());
                                        _showSpinner = false;
                                      });
                                    }
                                  }),
                                ),
                              ),
                            ],
                            physics: NeverScrollableScrollPhysics(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ), //white box
            ],
          ),
          Column(
            //for the circles of profile picture
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  height: 100,
                ),
                flex: 3,
              ),
              Center(
                child: Container(
                    child: Stack(
                  children: <Widget>[
                    Center(
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.green,
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 60,
                          backgroundImage:
                              AssetImage(//set any image to show a default profile pic),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.5),
                          child: IconButton(
                              icon: Icon(
                                Icons.edit,
                                size: 15,
                                color: Colors.red,
                              ),
                              onPressed: null),
                        ),
                      ),
                    )
                  ],
                )),
              ),
              Expanded(
                child: SizedBox(
                  height: 100,
                ),
                flex: 7,
              )
            ],
          ) //circles
        ],
      ),
    );
  }

  String emailValidator(String val) {
    if (val.trim().length < 5 || val.isEmpty) {
      return "email too short";
    }
    int atRate = 0, fdot = 0, sdot = 0;
    if (val.length > 4) {
      if (val.indexOf('@') > 0) {
        atRate = val.indexOf('@');
        val = val.substring(atRate + 1);
        if (val.indexOf('@') == -1) {
          if (val.indexOf('.') > 0) {
            fdot = val.indexOf('.');
            val = val.substring(fdot + 1);
            if (val.indexOf('.') > 0) {
              sdot = val.indexOf('.');
              val = val.substring(sdot + 1);
              if (val.length > 2) {
                return "invalid domain name";
              }
            }
          } else {
            return "invalid domain name";
          }
        } else {
          return "invalid domain name";
        }
      } else {
        return "no domain name";
      }
    } else if (val.trim().length > 12) {
      return "email too long";
    } else {
      return null;
    }
  }

  String passwordValidator(String val) {
    if (val.trim().length < 5 || val.isEmpty) {
      return "Password too short";
    } else if (val.trim().length > 20) {
      return "Password too long";
    } else {
      return null;
    }
  }

  Padding getButton(String name, IconData icon, Function onPress) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 7),
      child: RawMaterialButton(
        shape: StadiumBorder(),
        fillColor: Colors.green,
        onPressed: onPress,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon),
              Text(
                name,
                style: getStyle(Colors.black, 15),
              )
            ],
          ),
        ),
      ),
    );
  }
}
              /////////////////////////////This is the main widget of this page///////////////////

class Pages extends StatelessWidget {
  final String subject;
  final String description;
  final FormFieldValidator<String> validator;
  final String fieldLabelText;
  final String fieldHintText;
  final bool obscureText;
  final Widget buttonFirstChild;
  final Widget buttonSecondChild;
  final TextEditingController textEditingController;

  Pages(
      {this.subject,
      this.description,
      this.validator,
      this.fieldLabelText,
      this.fieldHintText,
      this.obscureText,
      this.buttonFirstChild,
      this.buttonSecondChild,
      this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            subject,
            style: getStyle(Colors.black, 20),
          ),
          Text(
            description,
            style: getStyle(Colors.black45, 15),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  autovalidate: true,
                  child: TextFormField(
                    obscureText: obscureText,
                    validator: validator,
                    controller: textEditingController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: fieldLabelText,
                      labelStyle: TextStyle(fontSize: 15.0),
                      hintText: fieldHintText,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: buttonFirstChild,
              ),
              Container(
                child: buttonSecondChild,
              ),
            ],
          )
        ],
      ),
    );
  }
}
