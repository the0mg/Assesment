
import 'package:assesment/const/color_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TxtField extends StatelessWidget {
  TextEditingController? ctr;
  String lblTxt;
  String hintTxt;
  IconData icon;
  TextInputType txtInputType;
  Color? textColor;
  FontWeight txtWeight;
  double fontSize;
  int minLine;
  int maxLine;
  bool isReadOnly;
  bool centerTxt;
  List<TextInputFormatter>? inputFormatters;
  FormFieldValidator? validator;
  ValueChanged<String>? onChanged;
  FocusNode? focusNode;

  TxtField(
      {this.ctr,
        this.txtInputType = TextInputType.text,
        this.lblTxt = '',
        this.hintTxt = 'E-mail',
        this.textColor,
        this.icon = Icons.mail,
        this.txtWeight=FontWeight.w500,
        this.fontSize=19,
        this.maxLine=1,
        this.minLine=1,
        this.isReadOnly=false,
        this.centerTxt=false,
        this.inputFormatters,
        this.validator,
        this.onChanged,
        this.focusNode,
      });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double unitHeightValue = size.width * 0.0022;
    return Container(
      width: size.width/1.1,
      // height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        inputFormatters: inputFormatters,
        validator: validator,
        decoration: InputDecoration(
          enabledBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
          ),
          border: InputBorder.none,
          filled: true,
          prefixIcon: Icon(
              icon
          ),
          prefixIconColor: Colors.grey,
          contentPadding: EdgeInsets.symmetric(vertical: -3),
          fillColor: ColorConst.headerColor,
          labelText: lblTxt =='' ? null : lblTxt,
          hintText: hintTxt,
          hintStyle: TextStyle(
              fontSize: 14 * unitHeightValue,
              ),
        ),

        readOnly: isReadOnly,
        controller: ctr,
        keyboardType: txtInputType,
        textAlign: centerTxt ? TextAlign.center : TextAlign.start,
        style: TextStyle(
          fontSize: fontSize * unitHeightValue,
        ),
        minLines: minLine,
        maxLines: maxLine,
        onChanged: onChanged,
        focusNode: focusNode,
      ),
    );
  }
}
