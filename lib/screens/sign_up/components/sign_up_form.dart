import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';

import '../../../components/custom_surfix_icon.dart';
import '../../../components/default_button.dart';
import '../../../components/form_error.dart';
import '../../../utlis/countries.dart';

import '../../../utlis/constants.dart';
import '../../../utlis/size_config.dart';
import 'upload_picture.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String firstName;
  String email;
  String bvn;
  String phno;
  bool remember = false;
  String _dialCode = '91';
  final List<String> errors = [];
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await FlutterSimCountryCode.simCountryCode;
    } on PlatformException {
      platformVersion = '91';
    }

    var dc = "91";
    Iterable<Country> dialCode =
        countryList.where((country) => country.isoCode == platformVersion);
    for (Country country in dialCode) {
      dc = country.phoneCode;
    }
    if (!mounted) return;

    setState(() {
      // _dialCode = countryCodes[platformVersion];
      _dialCode = dc;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildFirstNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildBVNField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhnoField(_dialCode),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Continue",
            press: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();

                phno = phno.replaceAll(" ", "");
                phno = phno.replaceAll("+", "");

                Navigator.pushNamed(context, "/uploadPicture",
                    arguments: UploadPictureScreenArguments(firstName, bvn, phno, email));
              }
            },
          ),
        ],
      ),
    );
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  TextFormField buildPhnoField(String dial_code) {
    return TextFormField(
      initialValue: "+" + dial_code + " ",
      keyboardType: TextInputType.phone,
      obscureText: false,
      onSaved: (newValue) => phno = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNullError);
        }
        phno = value.replaceAll(" ", "");
        phno = phno.replaceAll("+", "");
      },
      validator: (value) {
        if (!(isNumeric(phno))) {
          addError(error: kPhoneNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Phone No",
        hintText: "Enter your Phone Number",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildBVNField() {
    return TextFormField(
      obscureText: false,
      onSaved: (newValue) => bvn = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        bvn = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kUUIDNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "BVN No.",
        hintText: "Enter your BVN Number",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }else if(emailValidatorRegExp.hasMatch(value)){
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  TextFormField buildFirstNameFormField() {
    return TextFormField(
      onSaved: (newValue) => firstName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "First Name",
        hintText: "Enter your first name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
