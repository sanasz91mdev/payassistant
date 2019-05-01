import 'package:flutter/material.dart';
import 'package:flutter_chat_demo/CustomWidgets/custom_text_field.dart';
import 'package:flutter_chat_demo/const.dart';

class PaymentData {
  String identifier;
  String amount;
  String amountAfterDueDate;
  String dueDate;
  bool isSendOtpSuccess = false;
  int currentStep = 0;

  PaymentData(
      {this.identifier, this.amount, this.isSendOtpSuccess, this.currentStep});

  void updatePaymentInformation(String id, String amount,
      String amountAfterDueDate, String dueDate, bool isSendOTPSuccess) {
    this.identifier = id;
    this.amount = amount;
    this.amountAfterDueDate = amountAfterDueDate;
    this.dueDate = dueDate;
    this.isSendOtpSuccess = isSendOTPSuccess;
  }
}

class PaymentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PaymentPageState();
}

class PaymentPageState extends State<PaymentPage> {
  PaymentData model = PaymentData(
      identifier: "", isSendOtpSuccess: false, amount: "", currentStep: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar(),
        body: Builder(builder: (BuildContext context) {
          return Column(
            children: <Widget>[
              model.currentStep == 0
                  ? InquiryPage(
                      paymentModel: model,
                      onContinue: () {
                        Messages(context: context, title: 'Payment')
                                .getSendOTPResponseMessages()[
                            model.isSendOtpSuccess]();
                        setState(() {
                          if (model.isSendOtpSuccess) {
                            ++model.currentStep;
                          }
                        });
                      })
                  : PayPage(
                      paymentModel: model,
                      onResendPressed: () {
                        setState(() {
                          --model.currentStep;
                        });
                      },
                    ),
            ],
          );
        }));
  }

  AppBar getAppBar() {
    final ThemeData theme = Theme.of(context);

    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        'Bill Payment',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      iconTheme: IconThemeData(
        color: theme.primaryColor,
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(65.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Center(child: Text("Pull payment")),
            Theme(
                data: theme.copyWith(canvasColor: Colors.white),
                child: SizedBox(
                  height: 74.0,
                  child: Stepper(
                    steps: buildStepper(),
                    type: StepperType.horizontal,
                    currentStep: model.currentStep,
                    onStepTapped: (step) {
                      setState(() {
                        if (step != 1) {
                          model.currentStep = step;
                        }
                      });
                    },
                  ),
                )),
          ],
        ),
      ),
      // bottom: _buildActions(_instrument.isActive),
    );
  }

  List<Step> buildStepper() {
    return [
      Step(
          title: Text(
            'Inquiry',
          ),
          content: Container(),
          state: StepState.indexed,
          isActive: model.currentStep == 0),
      Step(
          title: Text(
            'Payment',
          ),
          state: StepState.indexed,
          content: Container(),
          isActive: model.currentStep == 1),
    ];
  }
}

class InquiryPage extends StatefulWidget {
  InquiryPage({Key key, this.paymentModel, this.onContinue}) : super(key: key);

  final VoidCallback onContinue;
  final PaymentData paymentModel;

  @override
  State<StatefulWidget> createState() => InquiryPageState();
}

class InquiryPageState extends State<InquiryPage> {
  final GlobalKey<FormState> _customerInformationForm = GlobalKey<FormState>();
  final TextEditingController _identifierController = TextEditingController();
  final FocusNode _identifierFocusNode = FocusNode();
  bool isConsumerNumberRequired = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Form(
        key: _customerInformationForm,
        child: Column(
          children: <Widget>[
            CustomTextField(
              icon: Icons.account_box,
              focusNode: _identifierFocusNode,
              hintText: 'Consumer Number',
              labelText: 'Consumer Number',
              controller: _identifierController,
              keyboardType: TextInputType.number,
              hasError: isConsumerNumberRequired,
              maxLength: 14,
              counterText: '',
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: RaisedButton(
                color: themeColor,
                onPressed: () async {
                  print('sana');
                  // bool isSendOTPSuccess = await doInquiry();
                  widget.paymentModel.updatePaymentInformation(
                      "012345678910",
                      "2233",
                      "2255",
                      "15-05-2019",
                      true);
                  widget.onContinue();
                },
                child: Text(
                  'CONTINUE',style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PayPage extends StatefulWidget {
  PayPage({Key key, this.paymentModel, this.onResendPressed}) : super(key: key);

  final PaymentData paymentModel;
  final VoidCallback onResendPressed;

  @override
  State<StatefulWidget> createState() => PayPageState();
}

class PayPageState extends State<PayPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _otpFocusNode = FocusNode();
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Expanded(
        child: ListView(children: [
          ListTile(
            leading: Icon(Icons.perm_identity),
            title: Text('Sana Zehra'),
            subtitle: Text('Consumer Name'),
          ),
          ListTile(
            leading: Icon(Icons.confirmation_number),
            title: Text(widget.paymentModel.identifier),
            subtitle: Text('Consumer Number'),
          ),
          ListTile(
            leading: Icon(Icons.date_range),
            title: Text(widget.paymentModel.dueDate),
            subtitle: Text('Due Date'),
          ),
          ListTile(
            leading: Icon(Icons.monetization_on),
            title: Text(widget.paymentModel.amount),
            subtitle: Text('Amount payable'),
          ),
          ListTile(
            leading: Icon(Icons.money_off),
            title: Text(widget.paymentModel.amountAfterDueDate),
            subtitle: Text('Amount payable after due date'),
          ),
          Divider(
            height: 16.0,
            color: Colors.grey,
          ),
          CustomTextField(
            icon: Icons.security,
            focusNode: _otpFocusNode,
            hintText: 'otp',
            labelText: 'One Time PIN',
            controller: _otpController,
            keyboardType: TextInputType.number,
            hasError: false,
            maxLength: 4,
            counterText: '',
            obscureText: true,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                  child: Text('RESEND OTP'),
                  color: Colors.white,
                  textColor: Theme.of(context).primaryColor,
                  onPressed: () async {
                    bool isSendOTPSuccess = true;
                    Messages(context: context, title: 'PAYMENT')
                        .getSendOTPResponseMessages()[isSendOTPSuccess]();
                  },
                ),
                RaisedButton(
                  color: themeColor,
                  onPressed: () {
                    print("SUBMIT");
                  },
                  child: Text('PAYMENT'),
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class Messages {
  final BuildContext context;
  final String title;

  Messages({@required this.context, this.title});

  Map getSendOTPResponseMessages() =>
      {true: _getSnackBarAlert, false: _getDialogAlert};

  void _getSnackBarAlert() {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('OTP was sent successfully'),
      duration: Duration(seconds: 5),
    ));
  }

  void _getDialogAlert() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => new AlertDialog(
            title: Text(title),
            content: new Text('Failed to send OTP'),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: new Text('OK'))
            ],
          ),
    );
  }
}
