import 'package:flutter/material.dart';

abstract class FormWidget<T> extends StatefulWidget {
  const FormWidget({super.key});
}

abstract class FormWidgetState<T> {
  T getData();
}
