import 'package:crm/services/remote_services.dart';
import 'package:flutter/material.dart';

class updateCustomerDialog extends StatefulWidget {
  final Map<String, dynamic> mp;
  const updateCustomerDialog({Key? key, required this.mp}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _updateCustomerDialogState(mp: mp);
}

class _updateCustomerDialogState extends State {
  final Map<String, dynamic> mp;

  TextEditingController category = TextEditingController();
  TextEditingController company = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController jobTitle = TextEditingController();
  TextEditingController businessPhone = TextEditingController();
  TextEditingController homePhone = TextEditingController();
  TextEditingController mobilePhone = TextEditingController();
  TextEditingController faxNumber = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController zip = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController webpage= TextEditingController();
  TextEditingController notes= TextEditingController();
  TextEditingController attachment = TextEditingController();

  final snackBar1 = const SnackBar(
    content: Text('Please fill all the Required fields!'),
    backgroundColor: Colors.red,
  );

  final snackBar3 = const SnackBar(
    content: Text('Customer Updated Successfully'),
    backgroundColor: Colors.green,
  );

  final snackBar4 = const SnackBar(
    content: Text('Something Went Wrong!'),
    backgroundColor: Colors.red,
  );

  var apiClient = RemoteServices();
  bool loading = false;

  _updateCustomerDialogState({required this.mp}) {
    category.text = (mp["category"] == null ? "" : mp["category"].toString());
    company.text = (mp["company"] == null ? "" : mp["company"].toString());
    firstName.text = (mp["firstName"] == null ? "" : mp["firstName"].toString());
    lastName.text = (mp["lastName"] == null ? "" : mp["lastName"].toString());
    email.text = (mp["email"] == null ? "" : mp["email"].toString());
    jobTitle.text = (mp["jobTitle"] == null ? "" : mp["jobTitle"].toString());
    businessPhone.text = (mp["business"] == null ? "" : mp["business"].toString());
    homePhone.text = (mp["home"] == null ? "" : mp["home"].toString());
    mobilePhone.text = (mp["mobile"] == null ? "" : mp["mobile"].toString());
    faxNumber.text = (mp["fax"] == null ? "" : mp["fax"].toString());
    address.text = (mp["address"] == null ? "" : mp["address"].toString());
    city.text = (mp["city"] == null ? "" : mp["city"].toString());
    state.text = (mp["state"] == null ? "" : mp["state"].toString());
    zip.text = (mp["zip"] == null ? "" : mp["zip"].toString());
    country.text = (mp["country"] == null ? "" : mp["country"].toString());
    webpage.text = (mp["webpage"] == null ? "" : mp["webpage"].toString());
    notes.text = (mp["notes"] == null ? "" : mp["notes"].toString());
    attachment.text = (mp["attachments"] == null ? "" : mp["attachments"].toString());
  }

  void postData() async {

    if(validate()==true){
      dynamic res = await apiClient.updateCustomer(mp["id"].toString(), company.text, category.text, firstName.text, lastName.text, email.text, jobTitle.text, businessPhone.text, homePhone.text, mobilePhone.text, faxNumber.text, address.text, city.text, state.text, zip.text, country.text, webpage.text, notes.text, attachment.text);

      if(res?["success"]==true) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(snackBar3);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(snackBar4);
      }
    }

    await Future.delayed(Duration(seconds: 2));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  bool validate() {
    if(category.text=="" || company.text=="" || email.text=="" || firstName.text=="" || businessPhone.text=="" || jobTitle.text=="" ){
      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    category.dispose();
    company.dispose();
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    jobTitle.dispose();
    businessPhone.dispose();
    homePhone.dispose();
    mobilePhone.dispose();
    faxNumber.dispose();
    address.dispose();
    city.dispose();
    state.dispose();
    zip.dispose();
    country.dispose();
    webpage.dispose();
    notes.dispose();
    attachment.dispose();

    super.dispose();
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(Icons.close),
          onTap: () => Navigator.pop(context),
        ),
        title: Text("Update Customer"),
        titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 24
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: const Color.fromRGBO(41, 41, 41, 1),
      body: form(),
    );
  }

  Widget form() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: ListView(
        children: [
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            controller: category,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Category*",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            controller: company,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Company*",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            controller: firstName,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "First Name*",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            controller: lastName,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Last Name",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.emailAddress,
            controller: email,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Email-Address*",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            controller: jobTitle,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Job Title*",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            controller: businessPhone,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Business Phone*",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            controller: homePhone,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Home Phone",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            controller: mobilePhone,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Mobile Phone",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            controller: faxNumber,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Fax Number",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            controller: address,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Address",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            controller: city,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "City",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            controller: state,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "State",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            controller: zip,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "ZIP/Postal Code",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            controller: country,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Country",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            controller: webpage,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Webpage",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            controller: notes,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Notes",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            controller: attachment,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Attachment",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
            child: ElevatedButton(onPressed: () {
              postData();
            } ,
              style: ElevatedButton.styleFrom(primary: const Color.fromRGBO(134, 97, 255, 1)),
              child: const Text("Submit",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}